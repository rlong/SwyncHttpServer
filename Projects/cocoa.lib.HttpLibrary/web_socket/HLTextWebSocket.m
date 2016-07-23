//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CADataHelper.h"
#import "CAInputStreamHelper.h"
#import "CALog.h"
#import "CAOutputStreamHelper.h"
#import "CAStreamHelper.h"
#import "CAStringHelper.h"

#import "HLFileHandle.h"

#import "HLFrame.h"
#import "HLTextWebSocket.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLTextWebSocket ()

// inputStream
//NSInputStream* _inputStream;
@property (nonatomic, retain) NSInputStream* inputStream;
//@synthesize inputStream = _inputStream;


// outputStream
//NSOutputStream* _outputStream;
@property (nonatomic, retain) NSOutputStream* outputStream;
//@synthesize outputStream = _outputStream;


// socket
//HLFileHandle* _socket;
@property (nonatomic, retain) HLFileHandle* socket;
//@synthesize socket = _socket;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLTextWebSocket


-(void)close {
    
    [_socket close];
    
    [CAStreamHelper closeStream:_inputStream swallowErrors:false caller:self];
    [CAStreamHelper closeStream:_outputStream swallowErrors:false caller:self];

    
}



-(NSMutableData*)recieveTextFrameBytes {
    
    
    
    
    HLFrame* frame = [HLFrame readFrame:_inputStream];
    if( nil == frame ) {
        return nil;
    }
    
    // browser is letting us know that it's closing the connection
    if( JBFrame_OPCODE_CONNECTION_CLOSE == [frame opCode] ) {
        
        // vvv http://tools.ietf.org/html/rfc6455#section-5.5.1
        
        [self sendCloseFrame];
        
        // ^^^ http://tools.ietf.org/html/rfc6455#section-5.5.1
        
        return nil;
    }


    NSMutableData* answer = [CAInputStreamHelper readMutableDataFromStream:_inputStream count:[frame payloadLength]];
    [frame applyMask:answer];

    return answer;
    
}

-(NSString*)recieveTextFrame {
 
    NSMutableData* textFrameBytes = [self recieveTextFrameBytes];
    
    if( nil == textFrameBytes ) {
        
        return nil;
    }
    
    NSString* answer = [CADataHelper toUtf8String:textFrameBytes];
    return answer;

}

-(void)sendCloseFrame {
    
    Log_enteredMethod();
    HLFrame* frame = [[HLFrame alloc] initWithOpCode:JBFrame_OPCODE_CONNECTION_CLOSE payloadLength:0];
    
    [frame writeTo:_outputStream];
    
}

-(void)sendTextFrame:(NSString*)text {
    
    
    NSData* utf8Data = [CAStringHelper toUtf8Data:text];
    uint32_t payloadLength = (uint32_t)[utf8Data length];

    HLFrame* frame = [[HLFrame alloc] initWithOpCode:JBFrame_OPCODE_TEXT_FRAME payloadLength:payloadLength];
    
    [frame writeTo:_outputStream];
    [CAOutputStreamHelper writeTo:_outputStream buffer:[utf8Data bytes] bufferLength:[utf8Data length]];

    // TextWebSocket.sendTextFrame() in java sends a flush but there does not appear to be an API to flush an `NSOutputStream`
    
    
}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithSocket:(HLFileHandle*)socket inputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream {
    
    HLTextWebSocket* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setInputStream:inputStream];
        [answer setOutputStream:outputStream];
        [answer setSocket:socket];
        
    }
    
    return answer;
    
    
}

-(void)dealloc {
    
    [self setInputStream:nil];
    [self setOutputStream:nil];
    [self setSocket:nil];
    
    
}


#pragma mark -
#pragma mark fields


// inputStream
//NSInputStream* _inputStream;
//@property (nonatomic, retain) NSInputStream* inputStream;
@synthesize inputStream = _inputStream;

// outputStream
//NSOutputStream* _outputStream;
//@property (nonatomic, retain) NSOutputStream* outputStream;
@synthesize outputStream = _outputStream;


// socket
//HLFileHandle* _socket;
//@property (nonatomic, retain) HLFileHandle* socket;
@synthesize socket = _socket;



@end
