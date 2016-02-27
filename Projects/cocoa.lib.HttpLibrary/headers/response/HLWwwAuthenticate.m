// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLAuthenticationHeaderScanner.h"
#import "HLWwwAuthenticate.h"



// see section 3.2.1 of RFC-2617
@implementation HLWwwAuthenticate


-(void)validate {
	
}
+(HLWwwAuthenticate*)buildFromString:(NSString*)challenge {

	HLWwwAuthenticate* answer = [[HLWwwAuthenticate alloc] init];

	HLAuthenticationHeaderScanner* authenticationHeaderScanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:challenge];
	@try {
		[authenticationHeaderScanner scanPastDigestString];
		
		NSString* name = [authenticationHeaderScanner scanName];
		while( nil != name ) {
			if( [@"nonce" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setNonce:value];
			} else if( [@"opaque" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setOpaque:value];
			} else if( [@"qop" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setQop:value];
			} else if( [@"realm" isEqualToString:name] ) {
				NSString* value = [authenticationHeaderScanner scanQuotedValue];
				[answer setRealm:value];
			} else {
				// 'auth-param' in section 3.2.1 of RFC-2617 says ... 
				// Any unrecognized directive MUST be ignored.
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
	/*
	 WWW-Authenticate: Digest
	 realm="testrealm@host.com", 
	 qop="auth,auth-int", 
	 nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093", 
	 opaque="5ccc069c403ebaf9f0171e9517f40e41"
	 */
	NSString* answer = [NSString stringWithFormat:@"Digest realm=\"%@\", nonce=\"%@\", opaque=\"%@\", qop=\"%@\"", _realm, _nonce, _opaque, _qop ];
	return answer;
}

#pragma mark <HttpProcessor> implementation 

-(NSString*)getName {
    
    return @"WWW-Authenticate";
    
}

-(NSString*)getValue {
    
    return [self toString];
    
}


#pragma mark instance setup/teardown

-(id)init {
	
	id answer = [super init];
	
	[self setQop:@"auth,auth-int"];
	
	return answer;
	
}

-(void)dealloc {
	
	
	[self setNonce:nil];
	[self setOpaque:nil];
	[self setQop:nil];
	[self setRealm:nil];
	
}
	 
#pragma mark fields
	 
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

@end
