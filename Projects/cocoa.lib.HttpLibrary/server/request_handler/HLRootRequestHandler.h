//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import <Foundation/Foundation.h>


#import "HLRequestHandler.h"

@interface HLRootRequestHandler : NSObject <HLRequestHandler> {
    
    // httpProcessors
	NSMutableArray* _httpProcessors;
	//@property (nonatomic, retain) NSMutableArray* httpProcessors;
	//@synthesize httpProcessors = _httpProcessors;
    
    
    // defaultProcessor
	id<HLRequestHandler> _defaultProcessor;
	//@property (nonatomic, retain) id<HttpProcessor> defaultProcessor;
	//@synthesize defaultProcessor = _defaultProcessor;


    
}

-(void)addRequestHandler:(id<HLRequestHandler>)httpProcessor;


#pragma mark instance lifecycle 

-(id)init;
-(id)initWithDefaultProcessor:(id<HLRequestHandler>)defaultProcessor;

@end
