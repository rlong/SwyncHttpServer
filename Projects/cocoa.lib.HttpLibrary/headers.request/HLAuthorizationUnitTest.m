// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <XCTest/XCTest.h>


#import "CABaseException.h"

#import "HLAuthorization.h"



@interface HLAuthorizationUnitTest : XCTestCase

@end

@implementation HLAuthorizationUnitTest


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

-(void)testBuildFromString {
	
	NSString* input = @"Digest username=\"Mufasa\", realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", uri=\"/dir/index.html\", qop=auth, nc=00000001, cnonce=\"0a4f113b\", response=\"6629fae49393a05397450978507c4ef1\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	HLAuthorization* authorizationRequestHeader = [HLAuthorization buildFromString:input];

	XCTAssertTrue( [@"Mufasa" isEqualToString:[authorizationRequestHeader username]], @"actual = %@", [authorizationRequestHeader username] ); 
	XCTAssertTrue( [@"testrealm@host.com" isEqualToString:[authorizationRequestHeader realm]], @"actual = %@", [authorizationRequestHeader realm] ); 
	XCTAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:[authorizationRequestHeader nonce]], @"actual = %@", [authorizationRequestHeader nonce] ); 
	XCTAssertTrue( [@"/dir/index.html" isEqualToString:[authorizationRequestHeader uri]], @"actual = %@", [authorizationRequestHeader uri] ); 
	XCTAssertTrue( [@"auth" isEqualToString:[authorizationRequestHeader qop]], @"actual = %@", [authorizationRequestHeader qop] ); 
	XCTAssertTrue( 1 == [authorizationRequestHeader nc], @"actual = %d", [authorizationRequestHeader nc] ); 	
	XCTAssertTrue( [@"0a4f113b" isEqualToString:[authorizationRequestHeader cnonce]], @"actual = %@", [authorizationRequestHeader cnonce] ); 
	XCTAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:[authorizationRequestHeader response]], @"actual = %@", [authorizationRequestHeader response] ); 
	XCTAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:[authorizationRequestHeader opaque]], @"actual = %@", [authorizationRequestHeader opaque] ); 
}


-(void)testBuildFromStringWithUnkownEntries { 
	
	NSString* input = @"Digest realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", bad-field=\"bad\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	@try {
		[HLAuthorization buildFromString:input];
		// good

	}
	@catch (BaseException * e) {
		XCTFail( @"'bad-field' should not have caused an exception to be thrown" );
	}
}


@end
