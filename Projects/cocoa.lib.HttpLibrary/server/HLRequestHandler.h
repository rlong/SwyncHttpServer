//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@class HLHttpRequest;
@class HLHttpResponse;

@protocol HLRequestHandler <NSObject>


-(NSString*)getProcessorUri;

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request;


@end
