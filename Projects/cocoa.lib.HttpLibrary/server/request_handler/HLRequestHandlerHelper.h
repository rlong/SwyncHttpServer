//  Copyright (c) 2014 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface HLRequestHandlerHelper : NSObject



+(void)validateMimeTypeForRequestUri:(NSString*) requestUri;
+(void)validateRequestUri:(NSString*) requestUri;

@end
