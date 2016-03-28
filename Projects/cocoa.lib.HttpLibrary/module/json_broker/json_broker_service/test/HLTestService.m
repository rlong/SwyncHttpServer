//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CABaseException.h"

#import "HLServiceHelper.h"
#import "HLTestService.h"


@implementation HLTestService

static NSString* _SERVICE_NAME = @"jsonbroker.TestService"; 
static HLServiceDescription* _SERVICE_DESCRIPTION = nil; 


+(void)initialize {
	
    _SERVICE_DESCRIPTION = [[HLServiceDescription alloc] initWithServiceName:_SERVICE_NAME];
	
}


+(NSString*)SERVICE_NAME {
    return _SERVICE_NAME;
}


-(void)ping {
	Log_enteredMethod();
}

-(void)raiseError { 
    
	Log_enteredMethod();
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"[jsonbroker.TestService raiseError] called "];
    [e setErrorDomain:@"jsonbroker.TestService.RAISE_ERROR"];
    @throw e;
    
                      
}

#pragma mark -
#pragma mark <DescribedService> implementation 

-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
	
	NSString* methodName = [request methodName];
	
	if( [@"ping" isEqualToString:methodName] ) { 
		
		[self ping];
		
		return [HLBrokerMessage buildResponse:request];

	}
    
    if( [@"raiseError" isEqualToString:methodName] ) { 
		
		[self raiseError];
		
		return [HLBrokerMessage buildResponse:request];
        
	}
	
    @throw [HLServiceHelper methodNotFound:self request:request];
	
	
}


-(HLServiceDescription*)serviceDescription {
    return _SERVICE_DESCRIPTION;
}




@end
