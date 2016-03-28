//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>


#import "HLServicesRegistery.h"

#import "HLRequestHandler.h"

@interface HLServicesRequestHandler : NSObject <HLRequestHandler> {
    
	// servicesRegistery
	HLServicesRegistery* _servicesRegistery;
	//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
	//@synthesize servicesRegistery = _servicesRegistery;

}


-(void)addService:(id<HLDescribedService>)service;


+(HLHttpResponse*)processPostRequest:(HLHttpRequest*)request withServiceRegistery:(HLServicesRegistery*)servicesRegistery;

#pragma mark instance lifecycle 

-(id)init;
-(id)initWithServicesRegistery:(HLServicesRegistery*)servicesRegistery;


@end
