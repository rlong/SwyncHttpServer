//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CABaseException.h"

#import "HLBrokerMessage.h"


@protocol HLJavascriptCallbackAdapter 
	
	-(void)onFault:(NSException*)fault request:(HLBrokerMessage*)request;
		
	-(void)onResponse:(HLBrokerMessage*)response;
	

@end


