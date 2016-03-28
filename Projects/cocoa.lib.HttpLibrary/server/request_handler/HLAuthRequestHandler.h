//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



@class HLHttpSecurityManager;
#import "HLRequestHandler.h"


@interface HLAuthRequestHandler : NSObject <HLRequestHandler> {

    // processors
	NSMutableDictionary* _processors;
	//@property (nonatomic, retain) NSMutableDictionary* processors;
	//@synthesize processors = _processors;
    
	// securityManager
	HLHttpSecurityManager* _securityManager;
	//@property (nonatomic, retain) HttpSecurityManager* securityManager;
	//@synthesize securityManager = _securityManager;

}


-(void)addRequestHandler:(id<HLRequestHandler>)processor;


#pragma mark instance lifecycle

-(id)initWithSecurityManager:(HLHttpSecurityManager*)httpSecurityManager;

@end
