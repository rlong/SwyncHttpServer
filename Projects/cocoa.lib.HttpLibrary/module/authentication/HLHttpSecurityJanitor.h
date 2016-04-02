//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

#import "HLHttpSecurityManager.h"


@interface HLHttpSecurityJanitor : NSObject {
    
    // httpSecurityManager
	HLHttpSecurityManager* _httpSecurityManager;
	//@property (nonatomic, retain) HttpSecurityManager* httpSecurityManager;
	//@synthesize httpSecurityManager = _httpSecurityManager;

}

-(void)start;


#pragma mark instance lifecycle 



-(id)initWithHttpSecurityManager:(HLHttpSecurityManager*) httpSecurityManager;


@end
