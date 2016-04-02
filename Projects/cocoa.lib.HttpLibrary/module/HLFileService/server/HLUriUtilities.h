//
//  UriUtilities.h
//  remote_gateway
//
//  Created by Richard Long on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JBJsonObject.h"

@interface HLUriUtilities : NSObject {
    
}

+(NSString*)URI;


+(NSString*)getFileUri:(JBJsonObject*)jsonObject;


@end
