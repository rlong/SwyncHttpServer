// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLAuthenticationHeaderScanner.h"
#import "HLAuthenticationInfo.h"


@implementation HLAuthenticationInfo



-(NSString*)toString {
	NSString* answer = [NSString stringWithFormat:@"nextnonce=\"%@\", qop=%@, rspauth=\"%@\", cnonce=\"%@\", nc=%08x", _nextnonce, _qop, _rspauth, _cnonce, (int)_nc ];
	return answer;
}


+(HLAuthenticationInfo*)buildFromString:(NSString*)authInfo {
	
	HLAuthenticationInfo* answer = [[HLAuthenticationInfo alloc] init];
	
	HLAuthenticationHeaderScanner* authenticationHeaderScanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:authInfo];
	@try {
		NSString* name = [authenticationHeaderScanner scanName];
		while( nil != name ) {
			if( [@"cnonce" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setCnonce:value];
			} else if( [@"nextnonce" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setNextnonce:value];
			} else if( [@"nc" isEqualToString:name] ) {
				UInt32 value = [authenticationHeaderScanner scanHexUInt32];
				[answer setNc:value];
			} else if( [@"qop" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanValue];
				[answer setQop:value];
			} else if( [@"rspauth" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setRspauth:value];
			} else {
				// 'auth-param' is not permitted according to 3.2.3 of RFC-2617
				// 'auth-param' in section 3.2.1 of RFC-2617 says ... 
				// Any unrecognized directive MUST be ignored.
				//
				// For consistency, we mimic the behaviour specified in sections 3.2.1 & 3.2.2 in relation to 'auth-param'
				NSString* value = [authenticationHeaderScanner scanValue];
				NSString* warning = [NSString stringWithFormat:@"unrecognised name-value pair. name = '%@', value = '%@'", name, value];
                Log_warn( warning);
				//[Log warn:warning inFunction:__func__];
			}
			name = [authenticationHeaderScanner scanName];
		}
	}
	@finally {
	}
	return answer;
	
}


#pragma mark <HttpProcessor> implementation 

-(NSString*)getName {
    
    return @"Authentication-Info";
    
}

-(NSString*)getValue {
    return [self toString];
}


#pragma mark instance setup/teardown

-(id)init {
	
	
	id answer = [super init];
	
	[self setQop:@"auth-int"];
	
	return answer;
	
}


-(void)dealloc {
	
	
	[self setCnonce:nil];
	[self setNextnonce:nil];
	// nc 
	[self setQop:nil];
	[self setRspauth:nil];
	
}

#pragma mark fields


//NSString* _cnonce;
//@property (nonatomic, retain) NSString* cnonce;
@synthesize cnonce = _cnonce;



//NSString* _nextnonce;
//@property (nonatomic, retain) NSString* nextnonce;
@synthesize nextnonce = _nextnonce;

//UInt32 _nc;
//@property (nonatomic) UInt32 nc;
@synthesize nc = _nc;


//NSString* _qop;
//@property (nonatomic, retain) NSString* qop;
@synthesize qop = _qop;

//NSString* _rspauth;
//@property (nonatomic, retain) NSString* rspauth;
@synthesize rspauth = _rspauth;

@end
