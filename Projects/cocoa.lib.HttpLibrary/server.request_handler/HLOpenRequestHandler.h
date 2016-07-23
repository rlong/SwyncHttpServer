//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>



#import "HLHttpRequest.h"

#import "HLRequestHandler.h"


@interface HLOpenRequestHandler : NSObject <HLRequestHandler> {
    
	// processors
	NSMutableDictionary* _processors;
	//@property (nonatomic, retain) NSMutableDictionary* processors;
	//@synthesize processors = _processors;
    
}

+(NSString*)REQUEST_URI;

-(void)addRequestHandler:(id<HLRequestHandler>)processor;




@end
