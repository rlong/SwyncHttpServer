//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>



#import "HLHttpRequest.h"
#import "HLRequestHandler.h"
#import "HLServicesRegistery.h"


@interface HLCorsServicesRequestHandler : NSObject <HLRequestHandler> {
    
	// servicesRegistery
	HLServicesRegistery* _servicesRegistery;
	//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
	//@synthesize servicesRegistery = _servicesRegistery;
    
}

-(void)addService:(id<HLDescribedService>)service;

#pragma mark -
#pragma mark instance lifecycle


-(id)init;
-(id)initWithServicesRegistery:(HLServicesRegistery*)servicesRegistery;



@end
