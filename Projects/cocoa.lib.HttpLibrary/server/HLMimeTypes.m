//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "HLMimeTypes.h"


extern NSString* const MimeTypes_APPLICATION_JSON;

@implementation HLMimeTypes



static NSMutableDictionary* mimeTypes = nil; 


+(void)initialize {
	
	mimeTypes = [[NSMutableDictionary alloc] init];
	
	[mimeTypes setObject:@"text/css" forKey:@".css"];
	[mimeTypes setObject:@"application/vnd.ms-fontobject" forKey:@".eot"]; // http://symbolset.com/blog/properly-serve-webfonts/
	[mimeTypes setObject:@"text/html" forKey:@".html"];
	[mimeTypes setObject:@"image/gif" forKey:@".gif"];
	[mimeTypes setObject:@"image/x-icon" forKey:@".ico"];	
	[mimeTypes setObject:@"image/jpeg" forKey:@".jpeg"];
	[mimeTypes setObject:@"image/jpeg" forKey:@".jpg"];
	[mimeTypes setObject:@"application/javascript" forKey:@".js"];
	[mimeTypes setObject:MimeTypes_APPLICATION_JSON forKey:@".json"];
	[mimeTypes setObject:MimeTypes_APPLICATION_JSON forKey:@".map"]; // http://stackoverflow.com/questions/19911929/what-mime-type-should-i-use-for-source-map-files
	[mimeTypes setObject:@"image/png" forKey:@".png"];
	[mimeTypes setObject:@"image/svg+xml" forKey:@".svg"]; // http://www.ietf.org/rfc/rfc3023.txt, section 8.19
	[mimeTypes setObject:@"text/x.typescript" forKey:@".ts"]; // http://stackoverflow.com/questions/13213787/whats-the-mime-type-of-typescript
	[mimeTypes setObject:@"application/x-font-ttf" forKey:@".ttf"]; // http://symbolset.com/blog/properly-serve-webfonts/
	[mimeTypes setObject:@"application/x-font-woff" forKey:@".woff"]; // http://symbolset.com/blog/properly-serve-webfonts/
    [mimeTypes setObject:@"application/font-woff2" forKey:@".woff2"]; // http://stackoverflow.com/questions/25796609/font-face-isnt-working-in-iis-8-0

}


+(NSString*)getMimeTypeForPath:(NSString*) path {
	
	
	NSRange lastDot = [path rangeOfString:@"." options:(NSBackwardsSearch)];
	
	if( NSNotFound == lastDot.location ) {
		return nil;
	}
	
	NSString* extension = [path substringFromIndex:lastDot.location];
	NSString* answer = [mimeTypes objectForKey:extension];
	return answer;
	
}


@end

NSString* const MimeTypes_APPLICATION_JSON = @"application/json";

NSString* const MimeTypes_AUDIO_MPEG = @"audio/mpeg";

NSString* const MimeTypes_VIDEO_MP4 = @"video/mp4";

