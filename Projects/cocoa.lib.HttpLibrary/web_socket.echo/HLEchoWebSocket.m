
//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLEchoWebSocket.h"
#import "HLTextWebSocket.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLEchoWebSocket ()

// echoWebSocket
//JBTextWebSocket* _echoWebSocket;
@property (nonatomic, retain) HLTextWebSocket* echoWebSocket;
//@synthesize echoWebSocket = _echoWebSocket;

// socket
//HLFileHandle* _socket;
@property (nonatomic, retain) HLFileHandle* socket;
//@synthesize socket = _socket;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLEchoWebSocket

// can return a `nil` which indicates processing on the socket should stop
-(id<HLConnectionDelegate>)processRequestOnSocket:(HLFileHandle*)socket inputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream {
    
    
    if( socket != _socket ) {
        [self setSocket:socket];
        [self setEchoWebSocket:nil];
        _echoWebSocket = [[HLTextWebSocket alloc] initWithSocket:socket inputStream:inputStream outputStream:outputStream];
    }
    
    NSString* line = [_echoWebSocket recieveTextFrame];
    Log_debugString( line );

    if( nil == line ) {
        return nil;
    }

    [_echoWebSocket sendTextFrame:line];
    
    return self;
    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    HLEchoWebSocket* answer = [super init];
    
    if( nil != answer ) {
        answer->_echoWebSocket = nil; // just to be explicit
        answer->_socket = nil; // just to be explicit
    }
    
    return answer;
    
}

-(void)dealloc {
    
    [self setEchoWebSocket:nil];
    [self setSocket:nil];
    
}

#pragma mark -
#pragma mark fields

// echoWebSocket
//JBTextWebSocket* _echoWebSocket;
//@property (nonatomic, retain) JBTextWebSocket* echoWebSocket;
@synthesize echoWebSocket = _echoWebSocket;


// socket
//HLFileHandle* _socket;
//@property (nonatomic, retain) HLFileHandle* socket;
@synthesize socket = _socket;


@end
