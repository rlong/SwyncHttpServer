// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "HLAuthenticationHeaderScanner.h"


@implementation HLAuthenticationHeaderScanner


-(void)scanPastDigestString {
	[_scanner scanString:@"Digest" intoString:nil];
}

-(NSString*)scanName {
	if( [_scanner isAtEnd] ) {
		return nil;
	}	
	NSString* answer = nil;
	
	if( [_scanner scanUpToString:@"=" intoString:&answer] ) {
		[_scanner scanString:@"=" intoString:nil]; // dispose of the '='		
	}
	return answer;
}

-(NSString*)scanQuotedValue {
	
	[_scanner scanString:@"\"" intoString:nil]; // dispose of the opening '"'
	NSString* answer = nil;
	[_scanner scanUpToString:@"\"" intoString:&answer];
	[_scanner scanString:@"\"" intoString:nil]; // dispose of the closing '"'
	[_scanner scanString:@"," intoString:nil]; // discard any trailing ',' that *might* exist
	return answer;
	
}

-(NSString*)scanValue {
	NSString* answer = nil;
	[_scanner scanUpToString:@"," intoString:&answer];
	[_scanner scanString:@"," intoString:nil]; // discard any trailing ',' that *might* exist
	return answer;
}

-(UInt32)scanHexUInt32 {
	
	
	unsigned long long longLong; 
	[_scanner scanHexLongLong:&longLong];
	
	if( longLong > 0xFFFFFFFF ) { // overflow
        Log_warn( @"longLong > 0xFFFFFFFF" );
		return 0;
	}
	[_scanner scanString:@"," intoString:nil]; // discard any trailing ',' that *might* exist
	
	UInt32 answer = (UInt32)longLong;
	return answer;
}


-(id)initWithHeaderValue:(NSString*)headerValue {
	
	HLAuthenticationHeaderScanner* answer = [super init];
	
	
	answer->_scanner = [[NSScanner alloc] initWithString:headerValue];
	
	return answer;
}

-(void)dealloc {
	
	
	[self setScanner:nil];
	
}

#pragma mark fields

//NSScanner* _scanner;
//@property (nonatomic, retain) NSScanner* scanner;
@synthesize scanner = _scanner;


@end
