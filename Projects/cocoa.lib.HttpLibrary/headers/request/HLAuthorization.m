// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLAuthenticationHeaderScanner.h"
#import "HLAuthorization.h"


@implementation HLAuthorization


// will return nil if it fails
+(HLAuthorization*)buildFromString:(NSString*)credentials {
	
	HLAuthorization* answer = [[HLAuthorization alloc] init];

	HLAuthenticationHeaderScanner* authenticationHeaderScanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:credentials];

	@try {
		[authenticationHeaderScanner scanPastDigestString];
		
		NSString* name = [authenticationHeaderScanner scanName];
		while( nil != name ) {
			if( [@"cnonce" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setCnonce:value];
			} else if( [@"nc" isEqualToString:name] ) {
				UInt32 value = [authenticationHeaderScanner scanHexUInt32];
				[answer setNc:value];
			} else if( [@"nonce" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setNonce:value];
			} else if( [@"opaque" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setOpaque:value];
			} else if( [@"qop" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanValue];
				[answer setQop:value];
			} else if( [@"realm" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setRealm:value];
			} else if( [@"response" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setResponse:value];
			} else if( [@"uri" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setUri:value];
			} else if( [@"username" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setUsername:value];
			} else {
                
				// 'auth-param' is permitted according to 3.2.2 of RFC-2617
				// 'auth-param' in section 3.2.1 of RFC-2617 says ... 
				// Any unrecognized directive MUST be ignored.
				// 
				NSString* value = [authenticationHeaderScanner scanValue];
				NSString* warning = [NSString stringWithFormat:@"unrecognised name-value pair. name = '%@', value = '%@'", name, value];
                Log_warn( warning );
			}
			name = [authenticationHeaderScanner scanName];
		}
	}
	@finally {
	}
	
	return answer;
}

-(NSString*)toString {
	
	NSString* answer = [NSString stringWithFormat:@"Digest username=\"%@\", realm=\"%@\", nonce=\"%@\", uri=\"%@\", response=\"%@\", cnonce=\"%@\", opaque=\"%@\", qop=%@, nc=%08x", _username, _realm, _nonce, _uri, _response, _cnonce, _opaque, _qop, (int)_nc];
	return answer;
	
}


#pragma mark <HttpProcessor> implementation 

-(NSString*)getName {
    return @"HLAuthorization";
}

-(NSString*)getValue {
    
    return [self toString];
    
}


#pragma mark instance lifecycle


-(id)init {
	
	HLAuthorization* answer = [super init];
	
	[answer setQop:@"auth-int"];

	return answer;
}

-(void)dealloc {
	
	
	[self setCnonce:nil];
	[self setNonce:nil];
	[self setOpaque:nil];
	[self setQop:nil];
	[self setRealm:nil];
	[self setResponse:nil];
	[self setUri:nil];
	[self setUsername:nil];
	
}

#pragma mark fields


//NSString* _cnonce;
//@property (nonatomic, retain) NSString* cnonce;
@synthesize cnonce = _cnonce;

//UInt32 _nc;
//@property (nonatomic) UInt32 nc;
@synthesize nc = _nc;

//NSString* _nonce;
//@property (nonatomic, retain) NSString* nonce;
@synthesize nonce = _nonce;

//NSString* _opaque;
//@property (nonatomic, retain) NSString* opaque;
@synthesize opaque = _opaque;

//NSString* _qop;
//@property (nonatomic, retain) NSString* qop;
@synthesize qop = _qop;

//NSString* _realm;
//@property (nonatomic, retain) NSString* realm;
@synthesize realm = _realm;

//NSString* _response;
//@property (nonatomic, retain) NSString* response;
@synthesize response = _response;


//NSString* _uri;
//@property (nonatomic, retain) NSString* uri;
@synthesize uri = _uri;


//NSString* _username;
//@property (nonatomic, retain) NSString* username;
@synthesize username = _username;


@end
