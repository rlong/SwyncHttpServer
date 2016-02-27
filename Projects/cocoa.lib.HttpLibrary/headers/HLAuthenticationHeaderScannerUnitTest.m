// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <XCTest/XCTest.h>

#import "CALog.h"

#import "HLAuthenticationHeaderScanner.h"


@interface HLAuthenticationHeaderScannerUnitTest : XCTestCase

@end


@implementation HLAuthenticationHeaderScannerUnitTest


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)test1 {
    Log_enteredMethod();
}


-(void)testAuthenticateHeader {
	
	NSString* headerValue = @"Digest realm=\"testrealm@host.com\", qop=\"auth,auth-int\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";

	HLAuthenticationHeaderScanner* scanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];

	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	XCTAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );

	NSString* value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );

	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"qop" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"auth,auth-int" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"nonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:value], @"actual = %@", value );

	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"opaque" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:value], @"actual = %@", value );

	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( nil == name, @"actual = %p", name );
	
}

-(void)testAuthorizationHeader {
	
	NSString* headerValue = @"Digest username=\"Mufasa\", realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", uri=\"/dir/index.html\", qop=auth, nc=00000001, cnonce=\"0a4f113b\", response=\"6629fae49393a05397450978507c4ef1\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";

	HLAuthenticationHeaderScanner* scanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];

	
	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	XCTAssertTrue( [@"username" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"Mufasa" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"nonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"uri" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"/dir/index.html" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"qop" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanValue];
	XCTAssertTrue( [@"auth" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"nc" isEqualToString:name], @"actual = %@", name );
	
	UInt32 nc = [scanner scanHexUInt32];
	XCTAssertTrue( 1 == nc, @"actual = %d", nc );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"cnonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"0a4f113b" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"response" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"opaque" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( nil == name, @"actual = %p", name );
	
	
}


-(void)testHexIntegers {
	
	NSString* headerValue = @"value00000000=00000000, value0000000a=0000000a, valueFFFFFFFF=FFFFFFFF, valueFFFFFFFFFFFF=FFFFFFFFFFFF";
	
	HLAuthenticationHeaderScanner* scanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];
	
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	XCTAssertTrue( [@"value00000000" isEqualToString:name], @"actual = %@", name );
	
	UInt32 value = [scanner scanHexUInt32];
	XCTAssertTrue( 0 == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
	name = [scanner scanName];
	XCTAssertTrue( [@"value0000000a" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanHexUInt32];
	XCTAssertTrue( 10 == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////

	name = [scanner scanName];
	XCTAssertTrue( [@"valueFFFFFFFF" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanHexUInt32];
	XCTAssertTrue( 0xFFFFFFFF == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"valueFFFFFFFFFFFF" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanHexUInt32];
	XCTAssertTrue( 0 == value, @"actual = %u", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
}

-(void)testHeaderWithNonQuotedValueAtEnd {
	NSString* headerValue = @"Digest realm=\"testrealm@host.com\", qop=auth-int"; // not a valid RFC-2617, but thats not relevant here
	
	HLAuthenticationHeaderScanner* scanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];

	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	XCTAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////

	
	name = [scanner scanName];
	XCTAssertTrue( [@"qop" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"auth-int" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
	
	
}


-(void)testHeaderWithHexIntegerAtEnd {
	NSString* headerValue = @"Digest realm=\"testrealm@host.com\", nc=0000000a"; // not a valid RFC-2617, but thats not relevant here
	
	HLAuthenticationHeaderScanner* scanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];
	
	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	XCTAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"testrealm@host.com" isEqualToString:value], @"actual = %@", value );
	
	////////////////////////////////////////////////////////////////////////////
	
	
	name = [scanner scanName];
	XCTAssertTrue( [@"nc" isEqualToString:name], @"actual = %@", name );
	
	UInt32 nc = [scanner scanHexUInt32];
	XCTAssertTrue( 10 == nc, @"actual = %u", nc );

	////////////////////////////////////////////////////////////////////////////
	
}


-(void)testRealm1 {
	
	NSString* headerValue = @"Digest realm=\"users@al's computer\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\"";
	
	HLAuthenticationHeaderScanner* scanner = [[HLAuthenticationHeaderScanner alloc] initWithHeaderValue:headerValue];
	
	
	////////////////////////////////////////////////////////////////////////////
	
	[scanner scanPastDigestString];
	
	////////////////////////////////////////////////////////////////////////////
	
	NSString* name = [scanner scanName];
	XCTAssertTrue( [@"realm" isEqualToString:name], @"actual = %@", name );
	
	NSString* value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"users@al's computer" isEqualToString:value], @"actual = %@", value );
	
	
	////////////////////////////////////////////////////////////////////////////
	
	name = [scanner scanName];
	XCTAssertTrue( [@"nonce" isEqualToString:name], @"actual = %@", name );
	
	value = [scanner scanQuotedValue];
	XCTAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:value], @"actual = %@", value );
	
}

@end
