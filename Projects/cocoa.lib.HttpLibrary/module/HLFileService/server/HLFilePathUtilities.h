//
//  FilePathUtilities.h
//  remote_gateway
//
//  Created by Richard Long on 19/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAJsonObject.h"

@interface HLFilePathUtilities : NSObject



+(NSString*)PARENT_FOLDER_PATH;
+(NSString*)FILE_NAME;
+(NSString*)FOLDER_NAME;

+(NSString*)FILE_PATH;

+(NSString*)getFilePath:(CAJsonObject*)jsonObject;
+(NSString*)getFolderPath:(CAJsonObject*)jsonObject;

@end
