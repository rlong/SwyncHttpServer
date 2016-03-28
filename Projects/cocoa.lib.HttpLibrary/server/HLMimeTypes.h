//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface HLMimeTypes : NSObject


+(NSString*)getMimeTypeForPath:(NSString*) path;

@end



extern NSString* const MimeTypes_AUDIO_MPEG;

extern NSString* const MimeTypes_VIDEO_MP4;
