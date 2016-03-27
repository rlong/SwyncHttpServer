// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLContentDisposition.h"
#import "HLMediaType.h"

@interface HLPartHandlerHelper : NSObject


+(HLContentDisposition*)getContentDispositionWithName:(NSString*)name value:(NSString*)value;
+(HLMediaType*)getContentTypeWithName:(NSString*)name value:(NSString*)value;

@end
