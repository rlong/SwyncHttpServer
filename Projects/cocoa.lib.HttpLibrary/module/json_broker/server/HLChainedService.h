//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLService.h"

@interface HLChainedService : NSObject <HLService> {
    
	// serviceName
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;

    // next
	id<HLService> _serviceDelegate;
	//@property (nonatomic, retain) id<Service> serviceDelegate;
	//@synthesize serviceDelegate = _serviceDelegate;

    // next
	id<HLService> _next;
	//@property (nonatomic, retain) id<Service> next;
	//@synthesize next = _next;

    
}

@end
