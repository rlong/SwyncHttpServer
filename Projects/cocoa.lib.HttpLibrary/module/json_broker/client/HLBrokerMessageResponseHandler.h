// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "HLHttpResponseHandler.h"

@class HLBrokerMessage;

@interface HLBrokerMessageResponseHandler : NSObject <HLHttpResponseHandler> {
    
    // responseData
	NSData* _responseData;
	//@property (nonatomic, retain) NSData* responseData;
	//@synthesize responseData = _responseData;

}


-(HLBrokerMessage*)getResponse;

@end
