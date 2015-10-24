//
//  AVFileContentTypeHelper.h
//  av_amigo
//
//  Created by rlong on 15/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XPStorageMetaData : NSObject


// will return nil, if not entry is found
+(NSString*)getContentTypeForFilename:(NSString*)filename;


+(void)saveContentType:(NSString*)contentType forFilename:(NSString*)filename;

@end
