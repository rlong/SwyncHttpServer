//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CAJsonHandler.h"
#import "CAJsonObjectHandler.h"
#import "CAJsonStringOutput.h"

#import "HLBrokerMessage.h"
#import "HLJavascriptCallbackAdapterHelper.h"
#import "HLFaultSerializer.h"


@implementation HLJavascriptCallbackAdapterHelper




+(NSString*)buildJavascriptFault:(HLBrokerMessage*)request fault:(NSException*)fault {
	
	
	CAJsonStringOutput* jsonWriter = [[CAJsonStringOutput alloc] init];
	
	[jsonWriter appendString:@"jsonbroker.forwardFault(\"fault\","];
	
	CAJsonObjectHandler* jsonObjectHandler = [CAJsonObjectHandler getInstance];
	[jsonObjectHandler writeValue:[request metaData] writer:jsonWriter];
	
	[jsonWriter appendString:@",\""];
	[jsonWriter appendString:[request serviceName]];
	[jsonWriter appendString:@"\",1,0,\""];
	[jsonWriter appendString:[request methodName]];
	[jsonWriter appendString:@"\","];
	[jsonObjectHandler writeValue:[HLFaultSerializer toJSONObject:fault] writer:jsonWriter];
	[jsonWriter appendString:@");"];
	NSString* answer = [jsonWriter toString];
	
	
	return answer;
	
}




+(NSString*)buildJavascriptResponse:(HLBrokerMessage*)response  {
	
	
	CAJsonStringOutput* jsonWriter = [[CAJsonStringOutput alloc] init];
	
	[jsonWriter appendString:@"jsonbroker.forwardResponse(\"response\","];
	
	CAJsonObjectHandler* jsonObjectHandler = [CAJsonObjectHandler getInstance];
	[jsonObjectHandler writeValue:[response metaData] writer:jsonWriter];
	
	[jsonWriter appendString:@",\""];
	[jsonWriter appendString:[response serviceName]];
	[jsonWriter appendString:@"\",1,0,\""];
	[jsonWriter appendString:[response methodName]];
	[jsonWriter appendString:@"\","];
	[jsonObjectHandler writeValue:[response associativeParamaters] writer:jsonWriter];
    
    
    if( [response hasOrderedParamaters] ) {
        
        CAJsonArray* orderedParamaters = [response orderedParamaters];

        [jsonWriter appendString:@",["];
        
        bool firstParameter = true;
        
        for( int i = 0, count = [orderedParamaters count]; i < count; i++ ) {
            
            if( firstParameter ) {
                firstParameter = false;
            } else {
                [jsonWriter appendChar:','];
            }
            id blob = [orderedParamaters objectAtIndex:i];
            CAJsonHandler* handler = [CAJsonHandler getHandlerForObject:blob];
            [handler writeValue:blob writer:jsonWriter];
        }
        
        [jsonWriter appendString:@"]"];

    }
    
	
	
	[jsonWriter appendString:@");"];
	NSString* answer = [jsonWriter toString];
	
	
	return answer;
	
}


+(NSString*)buildJavascriptForwardRequest:(HLBrokerMessage*)request  {
    
    NSMutableString* answer = [NSMutableString stringWithString:@"jsonbroker.forwardRequest( "];
    [answer appendString:[request toString]];
    
    [answer appendString:@" );"];
    
    return answer;
}




@end
