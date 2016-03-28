//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#import "CALog.h"
#import "CABaseException.h"

#import "HLConnectionHandler.h"
#import "HLFileHandle.h"
#import "HLRequestHandler.h"
#import "HLWebServer.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLWebServer () 

// httpProcessor
//id<HttpProcessor> _httpProcessor;
@property (nonatomic, retain) id<HLRequestHandler> httpProcessor;
//@synthesize httpProcessor = _httpProcessor;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLWebServer





-(void)closeServerSocket {

    @synchronized(self) {
        
        
        if( -1 == _serverSocketFileDescriptor ) {
            Log_debug( @"-1 == _serverSocketFileDescriptor" );
            return;
        }
        
        if( -1 == close( _serverSocketFileDescriptor ) ) {
            Log_errorCallFailed(@"close", errno);
            // fall through ...
        }
        
        _serverSocketFileDescriptor = -1;
        
    }
    
}


-(void)acceptIncomingConnection:(int)serverSocketFileDescriptor {
	
	int socketfd;
	
	length = sizeof(cli_addr);
	if((socketfd = accept(serverSocketFileDescriptor, (struct sockaddr *)&cli_addr, &length)) < 0) {
        
        Log_warnCallFailed( @"accept", errno);
        return;
	}
    
    // vvv http://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly
    
    int set = 1;
    if ( 0 < setsockopt(socketfd,SOL_SOCKET,SO_NOSIGPIPE, (void *)&set, sizeof(int)) ) {
        Log_warnCallFailed( @"setsockopt(socketfd,SOL_SOCKET,SO_NOSIGPIPE, (void *)&set, sizeof(int))", errno);
    }

    // ^^^ http://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly
    
    
    HLFileHandle* socket = [[HLFileHandle alloc] initWithFileDescriptor:socketfd];
    [HLConnectionHandler handleConnection:socket httpProcessor:_httpProcessor];
	
}


- (void)timerCallback:(NSTimer*)theTimer {
    
    
    int serverSocketFileDescriptor;
    
    @synchronized(self) {
        // make a local copy of the `_serverSocketFileDescriptor` on the stack
        serverSocketFileDescriptor = _serverSocketFileDescriptor;
    }
    
    if( -1 == serverSocketFileDescriptor ) {
        
        [theTimer invalidate];
        
		CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
		CFRunLoopStop( currentRunLoop );
        
    } else {
        
        [self acceptIncomingConnection:serverSocketFileDescriptor];
    }
}


-(void)run:(NSObject*)ignoredObject {
	
    
    NSString* threadName = [NSString stringWithFormat:@"WebServer:%d", _port];
	[[NSThread currentThread] setName:threadName];
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    {

        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] run];

    }
//	[pool release];

}


-(void)setup {
	
	static struct sockaddr_in serv_addr; /* static = initialised to zeros */
	
	/* setup the network socket */
	if((_serverSocketFileDescriptor = socket(AF_INET, SOCK_STREAM,0)) <0) {
        
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"socket" failedWithErrno:errno];		
		@throw e;
		
	}

	{		
		/*
		 If a socket is not completely shut down after a previous run of theis program 
		 (or another program that used the same port), then some connections could be in a variety of states (e.g. 'TIME_WAIT')
		 Under this scenario, if we do not 'SO_REUSEADDR', then we get the error ...
		 ''bind' call failed, errno = 48, strerror(errno)=Address already in use
		 
		 http://www.unixguide.net/network/socketfaq/4.5.shtml
		 */
		u_int yes=1;
		if ( 0 < setsockopt(_serverSocketFileDescriptor,SOL_SOCKET,SO_REUSEADDR,&yes,sizeof(yes)) ) {
            Log_warnCallFailed( @"setsockopt", errno);
		}
	}
	
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = htons(_port);
	if(bind(_serverSocketFileDescriptor, (struct sockaddr *)&serv_addr,sizeof(serv_addr)) <0) {
		
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"bind" failedWithErrno:errno];
        [e setErrorDomain:@"jsonbroker.WebServer.SOCKET_BIND_FAILED"];
		@throw e;
		
	}
	if( listen(_serverSocketFileDescriptor,64) <0) {
		
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"listen" failedWithErrno:errno];		
		@throw e;
		
	}
	
}


-(void)start {
	
	
	[self setup];
	
	[NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:nil];

}

-(void)stop {
    
    if( -1 == _serverSocketFileDescriptor ) {
        // shouldn't be calling stop on an instance that is not listening
        Log_warn(@"-1 == _serverSocketFileDescriptor");
        return;
    }
    
    [self closeServerSocket];
    
}



#pragma mark instance lifecycle

-(id)initWithPort:(int)port httpProcessor:(id<HLRequestHandler>)httpProcessor {
	
	HLWebServer* answer = [super init];
    
    if( nil != answer ) { 
        
        
        answer->_port = port;
        [answer setHttpProcessor:httpProcessor];
        
    }
	
	
	return answer;
}
	 
-(id)initWithHttpProcessor:(id<HLRequestHandler>)httpProcessor {
    
    return [self initWithPort:8081 httpProcessor:httpProcessor];
    
}
	 

-(void)dealloc {
	
    
    if( -1 != _serverSocketFileDescriptor ) {
        
        Log_warn(@"-1 != _serverSocketFileDescriptor; should **not** leave it up to `dealloc` to close file descriptor");
        [self closeServerSocket];
        
    }
    [self setHttpProcessor:nil];
}

#pragma mark fields


// httpProcessor
//id<HttpProcessor> _httpProcessor;
//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
@synthesize httpProcessor = _httpProcessor;



@end
