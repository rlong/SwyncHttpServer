//
//  AVStorageManagerHelper.h
//  av_amigo
//
//  Created by rlong on 8/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLStorageManagerHelper : NSObject



+(uint64_t)getFreeSpaceForPath:(NSString*)path;

+(BOOL)removeFileWithPath:(NSString*)fullPath swallowErrors:(BOOL)swallowErrors;
+(BOOL)removeFileWithName:(NSString*)filename inFolder:(NSString*)folderPath swallowErrors:(BOOL)swallowErrors;

+(uint64_t)sizeOfFileWithName:(NSString*)filename inFolder:(NSString*)folderPath;

@end
