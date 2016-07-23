//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "HLConnectionDelegate.h"

@class HLFileHandle;
@class HLTextWebSocket;



@interface HLEchoWebSocket : NSObject <HLConnectionDelegate> {

    // echoWebSocket
    HLTextWebSocket* _echoWebSocket;
    //@property (nonatomic, retain) JBTextWebSocket* echoWebSocket;
    //@synthesize echoWebSocket = _echoWebSocket;
    
    // socket
    HLFileHandle* _socket;
    //@property (nonatomic, retain) HLFileHandle* socket;
    //@synthesize socket = _socket;

}

@end
