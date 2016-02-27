// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@interface HLAuthenticationHeaderScanner : NSObject {

	NSScanner* _scanner;
	//@property (nonatomic, retain) NSScanner* scanner;
	//@synthesize scanner = _scanner;
	
}

-(void)scanPastDigestString;


-(NSString*)scanName;
-(NSString*)scanQuotedValue;
-(NSString*)scanValue;
-(UInt32)scanHexUInt32;

-(id)initWithHeaderValue:(NSString*)headerValue;


#pragma mark fields

//NSScanner* _scanner;
@property (nonatomic, retain) NSScanner* scanner;
//@synthesize scanner = _scanner;



@end
