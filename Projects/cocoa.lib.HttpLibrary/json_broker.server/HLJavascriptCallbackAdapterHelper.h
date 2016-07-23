//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CABaseException.h"
#import "HLBrokerMessage.h"

@interface HLJavascriptCallbackAdapterHelper : NSObject {

}

+(NSString*)buildJavascriptFault:(HLBrokerMessage*)request fault:(NSException*)fault;
+(NSString*)buildJavascriptResponse:(HLBrokerMessage*)response;
+(NSString*)buildJavascriptForwardRequest:(HLBrokerMessage*)request;





@end
