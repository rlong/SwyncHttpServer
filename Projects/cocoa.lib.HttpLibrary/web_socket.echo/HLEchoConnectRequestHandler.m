//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "CALog.h"

#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLHttpStatus.h"

#import "HLEchoConnectRequestHandler.h"
#import "HLEchoWebSocket.h"
#import "HLWebSocketUtilities.h"


@implementation HLEchoConnectRequestHandler

-(NSString*)getProcessorUri {
    
    return @"/echo";
    
}

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    NSString* upgrade = [request getHttpHeader:@"upgrade"];
    Log_debugString( upgrade );
    
    if( nil == upgrade ) {
        Log_error( @"nil == upgrade" );
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }

    NSString* secWebSocketKey = [request getHttpHeader:@"sec-websocket-key"];
    Log_debugString( secWebSocketKey );
    
    if( nil == secWebSocketKey ) {
        Log_error( @"nil == secWebSocketKey" );
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    HLHttpResponse* answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_SWITCHING_PROTOCOLS_101];
    
    NSString* secWebSocketAccept = [HLWebSocketUtilities buildSecWebSocketAccept:secWebSocketKey];
    
    [answer putHeader:@"Connection" value:@"Upgrade"];
    [answer putHeader:@"Sec-WebSocket-Accept" value:secWebSocketAccept];
    [answer putHeader:@"Upgrade" value:@"websocket"];
    
    {
        HLEchoWebSocket* connectionDelegate = [[HLEchoWebSocket alloc] init];
        {
        
            [answer setConnectionDelegate:connectionDelegate];
        }
        
    }

    return answer;
}

@end
