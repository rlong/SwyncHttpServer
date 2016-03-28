//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



@class HLFileHandle;
@protocol HLRequestHandler;

#import "HLConnectionDelegate.h"


@interface HLHttpDelegate : NSObject  <HLConnectionDelegate> {
	
    
	// httpProcessor
	id<HLRequestHandler> _httpProcessor;
	//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
	//@synthesize httpProcessor = _httpProcessor;

}


#pragma mark -
#pragma mark instance setup/teardown


-(id)initWithRequestHandler:(id<HLRequestHandler>)httpProcessor;



@end
