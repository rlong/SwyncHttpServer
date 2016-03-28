//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLDescribedService.h"
#import "HLMainThreadService.h"
#import "HLService.h"



@interface HLServicesRegisteryErrorDomain : NSObject {
}

-(NSString*)SERVICE_NOT_FOUND;

@end


@interface HLServicesRegistery : NSObject <HLService> {
	
	
	NSMutableDictionary* _services;
	//@property (nonatomic, retain) NSMutableDictionary* services;
	//@synthesize services = _services;
	
	// next
	HLServicesRegistery* _next;
	//@property (nonatomic, retain) ServicesRegistery* next;
	//@synthesize next = _next;
	
	
}

+(HLServicesRegisteryErrorDomain*)errorDomain;

-(void)addService:(id<HLDescribedService>)service;
-(bool)hasService:(NSString*)serviceName;
-(id<HLService>)getService:(NSString*)serviceName;
-(void)removeService:(id<HLDescribedService>)serviceToRemove;



#pragma mark instance lifecycle

-(id)init;

// 'next' can be nil
-(id)initWithService:(id<HLDescribedService>)service next:(HLServicesRegistery*)next;

#pragma mark fields


// next
//ServicesRegistery* _next;
@property (nonatomic, retain) HLServicesRegistery* next;
//@synthesize next = _next;

@end


