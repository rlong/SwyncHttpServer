// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@protocol HLService;

@interface HLMetaProxy : NSObject {
    
    // service
	id<HLService> _service;
	//@property (nonatomic, retain) id<Service> service;
	//@synthesize service = _service;

}


-(NSArray*)getVersion:(NSString*)serviceName;

#pragma mark instance lifecycle

-(id)initWithService:(id<HLService>)service;

@end
