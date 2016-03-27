// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLPartHandlerHelper.h"


@implementation HLPartHandlerHelper

+(HLContentDisposition*)getContentDispositionWithName:(NSString*)name value:(NSString*)value {
    
    
    if( [@"content-disposition" isEqualToString:name] ) {
        
        
        return [HLContentDisposition buildFromString:value];
        
        
    }
    
    return nil;
    
    
}


+(HLMediaType*)getContentTypeWithName:(NSString*)name value:(NSString*)value {

    if( [@"content-type" isEqualToString:name] ) {
        
        
        return [HLMediaType buildFromString:value];
        
        
    }

    return nil;

}



@end
