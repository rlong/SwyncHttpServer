//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLBrokerMessage.h"
#import "HLSerializer.h"
#import "HLTestService.h"
#import "HLTestProxy.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLTestProxy () 


// service
//id<Service> _service;
@property (nonatomic, retain) id<HLService> service;
//@synthesize service = _service;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLTestProxy


-(void)ping { 
    
    HLBrokerMessage* request = [HLBrokerMessage buildRequestWithServiceName:[HLTestService SERVICE_NAME] methodName:@"ping"];
    
    [_service process:request];
    
}


-(void)raiseError { 
    
    
    HLBrokerMessage* request = [HLBrokerMessage buildRequestWithServiceName:[HLTestService SERVICE_NAME] methodName:@"raiseError"];
    
    [_service process:request];
    
                              
}

#pragma instance -
#pragma instance lifecycle  

-(id)initWithService:(id<HLService>)service {
    
    
    HLTestProxy* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setService:service];
    
    }
    
    
    return answer;
}

-(void)dealloc {

	[self setService:nil];
	
	
}

#pragma instance -
#pragma mark fields


// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;



@end
