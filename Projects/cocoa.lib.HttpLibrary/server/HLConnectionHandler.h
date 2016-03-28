//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@protocol HLConnectionDelegate;
@class HLFileHandle;
@protocol HLRequestHandler;


@interface HLConnectionHandler : NSObject {
    
    // delegate
    id<HLConnectionDelegate> _delegate;
    //@property (nonatomic, retain) id<HLConnectionDelegate> delegate;
    //@synthesize delegate = _delegate;
    
    
    // socket
    HLFileHandle* _socket;
    //@property (nonatomic, retain) HLFileDescriptor* socket;
    //@synthesize socket = _socket;
    
    // inputStream
    NSInputStream* _inputStream;
    //@property (nonatomic, retain) NSInputStream* inputStream;
    //@synthesize inputStream = _inputStream;
    
    
    // outputStream
    NSOutputStream* _outputStream;
    //@property (nonatomic, retain) NSOutputStream* outputStream;
    //@synthesize outputStream = _outputStream;
    
    NSTimer* _callbackTimer;
    //@property (nonatomic, retain) NSTimer* callbackTimer;
    //@synthesize callbackTimer = _callbackTimer;
    
}


+(void)handleConnection:(HLFileHandle*)fileDescriptor httpProcessor:(id<HLRequestHandler>)httpProcessor;



@end
