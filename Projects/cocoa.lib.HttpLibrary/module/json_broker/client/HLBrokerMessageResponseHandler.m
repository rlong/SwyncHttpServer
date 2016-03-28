// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CADataHelper.h"

#import "HLBrokerMessage.h"
#import "HLBrokerMessageResponseHandler.h"
#import "HLBrokerMessageType.h"
#import "HLEntityHelper.h"
#import "HLFaultSerializer.h"
#import "HLSerializer.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLBrokerMessageResponseHandler () 

// responseData
//NSData* _responseData;
@property (nonatomic, retain) NSData* responseData;
//@synthesize responseData = _responseData;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLBrokerMessageResponseHandler 


-(void)handleResponseHeaders:(NSDictionary*)headers responseEntity:(id<HLEntity>)responseEntity {
    
    
    
    [self setResponseData:[HLEntityHelper toData:responseEntity]];
    
}


-(HLBrokerMessage*)getResponse {
    HLBrokerMessage* answer = [HLSerializer deserialize:_responseData];
    
    if( [HLBrokerMessageType fault] == [answer messageType] ) {
        CAJsonObject* associativeParamaters = [answer associativeParamaters];
        BaseException* e = [HLFaultSerializer toBaseException:associativeParamaters];
        @throw e;
    }
    
    return answer;
    
}


#pragma mark instance lifecycle 

-(void)dealloc {
	
	[self setResponseData:nil];
	
	
}


#pragma mark fields


// responseData
//NSData* _responseData;
//@property (nonatomic, retain) NSData* responseData;
@synthesize responseData = _responseData;


@end
