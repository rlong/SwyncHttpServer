//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#include <sys/socket.h> // `SOL_SOCKET`



#import "CALog.h"
#import "CABaseException.h"
#import "CAOutputStreamHelper.h"
#import "CAInputStreamHelper.h"
#import "CAStreamHelper.h"

#import "HLAuthRequestHandler.h"
#import "HLConnectionHandler.h"
#import "HLConnectionDelegate.h"
#import "HLFileHandle.h"
#import "HLFileGetRequestHandler.h"
#import "HLHttpDelegate.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpRequestReader.h"
#import "HLHttpResponseWriter.h"
#import "HLHttpStatus.h"
#import "HLRequestHandler.h"
#import "HLOpenRequestHandler.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLConnectionHandler ()



// delegate
//id<HLConnectionDelegate> _delegate;
@property (nonatomic, retain) id<HLConnectionDelegate> delegate;
//@synthesize delegate = _delegate;


// socket
//HLFileDescriptor* _socket;
@property (nonatomic, retain) HLFileHandle* socket;
//@synthesize socket = _socket;


// inputStream
//NSInputStream* _inputStream;
@property (nonatomic, retain) NSInputStream* inputStream;
//@synthesize inputStream = _inputStream;



// outputStream
//NSOutputStream* _outputStream;
@property (nonatomic, retain) NSOutputStream* outputStream;
//@synthesize outputStream = _outputStream;


//NSTimer* _callbackTimer;
@property (nonatomic, retain) NSTimer* callbackTimer;
//@synthesize callbackTimer = _callbackTimer;


@property (nonatomic) bool delegateSetupCalled;



- (void)teardownTimerCallback;

#pragma mark instance setup/teardown

-(id)initWithSocket:(HLFileHandle*)socket httpProcessor:(id<HLRequestHandler>)requestHandler;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////




@implementation HLConnectionHandler {
    
    bool _delegateSetupCalled;
    id<HLRequestHandler> _requestHandler;
}

static int _connectionId = 1;

#pragma mark - instance setup/teardown


-(id)initWithSocket:(HLFileHandle*)socket httpProcessor:(id<HLRequestHandler>)requestHandler {
    
    HLConnectionHandler* answer = [super init];
    
    if( nil != answer ) {
        
        
        answer->_delegateSetupCalled = false;
        [answer setSocket:socket];
        answer->_requestHandler = requestHandler;
        
    }
    
    
    return answer;
    
}

-(void)dealloc{
    
    
    [self setDelegate:nil];
    
    [self setSocket:nil];
    
    [self setInputStream:nil];
    [self setOutputStream:nil];
    
    [self setCallbackTimer:nil];
    
}


- (void)delegateSetup {
    
    Log_enteredMethod();
    
    
    // vvv http://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly
    
    {
        int set = 1;
        if ( 0 < setsockopt([_socket fileDescriptor], SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int)) ) {
            Log_warnCallFailed( @"setsockopt(socketfd,SOL_SOCKET,SO_NOSIGPIPE, (void *)&set, sizeof(int))", errno);
        }
        
    }
    
    // ^^^ http://stackoverflow.com/questions/108183/how-to-prevent-sigpipes-or-handle-them-properly
    
    
    // vvv derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`
    
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, [_socket fileDescriptor], &readStream, &writeStream);
    {
        assert(readStream != NULL);
        
        [self setInputStream:(__bridge NSInputStream*)readStream];
        [self setOutputStream:(__bridge NSOutputStream*)writeStream];
    }

#ifdef RHUBARB_AND_CUSTARD // i.e. skip
    [_inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
    [_outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertyShouldCloseNativeSocket];
#endif
    
    [_inputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertySocketExtendedBackgroundIdleMode];
    
    [_outputStream setProperty:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamPropertySocketExtendedBackgroundIdleMode];
    
    
    CFRelease(readStream);
    CFRelease(writeStream);
    
    // ^^^ derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`
    
    
    [_inputStream open];
    [_outputStream open];

#ifdef RHUBARB_AND_CUSTARD // i.e. skip

    // vvv derived from [iphone - CFNetwork HTTP timeout? - Stack Overflow](http://stackoverflow.com/questions/962076/cfnetwork-http-timeout)
    {
        
        // setup the `readStream` to never timeout on a read
        
#define _kCFStreamPropertyReadTimeout CFSTR("_kCFStreamPropertyReadTimeout")
        
        double to = 0; // never timeout
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberDoubleType, &to);
        CFReadStreamSetProperty(readStream, _kCFStreamPropertyReadTimeout, num);
        CFRelease(num);
        
    }
    // ^^^ derived from [iphone - CFNetwork HTTP timeout? - Stack Overflow](http://stackoverflow.com/questions/962076/cfnetwork-http-timeout)
    
    // vvv set write timeout to never
    {
#define _kCFStreamPropertyWriteTimeout CFSTR("_kCFStreamPropertyWriteTimeout")
        double to = 0; // never timeout
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberDoubleType, &to);
        CFWriteStreamSetProperty(writeStream, _kCFStreamPropertyWriteTimeout, num);
        CFRelease(num);
        
    }
    // ^^^ set write timeout to never
#endif
    
    
    
    _delegate = [[HLHttpDelegate alloc] initWithRequestHandler:_requestHandler];
    
    // vvv derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`
    
    _inputStream.delegate = self;
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    _outputStream.delegate = self;
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    
    // ^^^ derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`

    
    

    _delegateSetupCalled = true;

}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
{
    
//    NSStreamEventNone = 0,
//    NSStreamEventOpenCompleted = 1UL << 0,
//    NSStreamEventHasBytesAvailable = 1UL << 1,
//    NSStreamEventHasSpaceAvailable = 1UL << 2,
//    NSStreamEventErrorOccurred = 1UL << 3,
//    NSStreamEventEndEncountered = 1UL << 4
    
    if( aStream == _inputStream ) {
//        Log_debugFormat( @"aStream == _inputStream; eventCode = %d", eventCode );
        return;
    }


    if( NSStreamEventNone == eventCode ) {
        Log_debug( @"NSStreamEventNone == eventCode" );
    }
    if( NSStreamEventOpenCompleted == eventCode ) {
        Log_debug( @"NSStreamEventOpenCompleted == eventCode" );
        return;
    } else if( NSStreamEventHasBytesAvailable == eventCode ) {
//        Log_debug( @"NSStreamEventHasBytesAvailable == eventCode" );
    } else if( NSStreamEventHasSpaceAvailable == eventCode ) {
//        Log_debug( @"NSStreamEventHasSpaceAvailable == eventCode" );
    } else if( NSStreamEventErrorOccurred == eventCode ) {
        Log_debug( @"NSStreamEventErrorOccurred == eventCode" );
    } else if( NSStreamEventEndEncountered == eventCode ) {
        Log_debug( @"NSStreamEventEndEncountered == eventCode" );
    } else {
        Log_debugInt( eventCode );
    }

    
    do {
        _delegate = [_delegate processRequestOnSocket:_socket inputStream:_inputStream outputStream:_outputStream];
        if( [_inputStream hasBytesAvailable] ) {
            Log_debug(@"[_inputStream hasBytesAvailable]");
        }
        
    } while( nil != _delegate && [_inputStream hasBytesAvailable] );

    if( nil == _delegate ) {
        
        Log_debug( @"finishing" );
        
        /////////////////////////////////////
        [self teardownTimerCallback];
        /////////////////////////////////////
        
        [_inputStream close];
        [_outputStream close];
        
        
        @try {
            
            [_socket close];
        }
        @catch (BaseException* exception) {
            Log_warnException( exception );
        }
        
    }

    
}



- (void)timerCallback:(NSTimer*)theTimer {
    

    @try {
        
        if( !_delegateSetupCalled ) {
            [self delegateSetup];
        }

#ifdef RHUBARB_AND_CUSTARD // i.e. skip
        do {
            _delegate = [_delegate processRequestOnSocket:_socket inputStream:_inputStream outputStream:_outputStream];
            if( [_inputStream hasBytesAvailable] ) {
                Log_debug(@"[_inputStream hasBytesAvailable]");
            }
            
        } while( nil != _delegate && [_inputStream hasBytesAvailable] );
#endif
        
        
    }
    @catch (NSException *exception) {
        Log_warnException(exception);
    }
    
    
    if( nil == _delegate ) {
        
        Log_debug( @"finishing" );
        
        /////////////////////////////////////
        [self teardownTimerCallback];
        /////////////////////////////////////
        
        [_inputStream close];
        [_outputStream close];

        
        @try {
            
            [_socket close];
        }
        @catch (BaseException* exception) {
            Log_warnException( exception );
        }
        
    }
    
}


- (void)setupTimerCallback {
    
    NSTimer *callbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
    [self setCallbackTimer:callbackTimer];
    
}

- (void)teardownTimerCallback {
    
    [_callbackTimer invalidate];
    [self setCallbackTimer:nil];
    
}


-(void)run:(NSObject*)ignoredObject {
    
    
    NSString* threadName = [NSString stringWithFormat:@"ConnectionHandler.%d.%d", _connectionId++, [_socket fileDescriptor]];
    [[NSThread currentThread] setName:threadName];
    {
        
        [self setupTimerCallback];
        [[NSRunLoop currentRunLoop] run];
        
    }
}


+(void)handleConnection:(HLFileHandle*)socket httpProcessor:(id<HLRequestHandler>)httpProcessor {
    
    HLConnectionHandler* connectionHandler = [[HLConnectionHandler alloc] initWithSocket:socket httpProcessor:httpProcessor];
    {
        [NSThread detachNewThreadSelector:@selector(run:) toTarget:connectionHandler withObject:nil];
    }
    
}


#pragma mark fields


// delegate
//id<HLConnectionDelegate> _delegate;
//@property (nonatomic, retain) id<HLConnectionDelegate> delegate;
@synthesize delegate = _delegate;


// socket
//HLFileDescriptor* _socket;
//@property (nonatomic, retain) HLFileDescriptor* socket;
@synthesize socket = _socket;


// inputStream
//NSInputStream* _inputStream;
//@property (nonatomic, retain) NSInputStream* inputStream;
@synthesize inputStream = _inputStream;


// outputStream
//NSOutputStream* _outputStream;
//@property (nonatomic, retain) NSOutputStream* outputStream;
@synthesize outputStream = _outputStream;

//NSTimer* _callbackTimer;
//@property (nonatomic, retain) NSTimer* callbackTimer;
@synthesize callbackTimer = _callbackTimer;





@end
