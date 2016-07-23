// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <XCTest/XCTest.h>

#import "CABaseException.h"

#import "HLWwwAuthenticate.h"



@interface HLWwwAuthenticateUnitTest : XCTestCase

@end


@implementation HLWwwAuthenticateUnitTest


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
	
	NSString* input = @"Digest realm=\"testrealm@host.com\", qop=\"auth,auth-int\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	
	HLWwwAuthenticate* authenticateResponseHeader = [HLWwwAuthenticate buildFromString:input];
	XCTAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:[authenticateResponseHeader nonce]], @"actual = %@", [authenticateResponseHeader nonce] ); 
	XCTAssertTrue( [@"5ccc069c403ebaf9f0171e9517f40e41" isEqualToString:[authenticateResponseHeader opaque]], @"actual = %@", [authenticateResponseHeader opaque] ); 
	XCTAssertTrue( [@"auth,auth-int" isEqualToString:[authenticateResponseHeader qop]], @"actual = %@", [authenticateResponseHeader qop] ); 
	XCTAssertTrue( [@"testrealm@host.com" isEqualToString:[authenticateResponseHeader realm]], @"actual = %@", [authenticateResponseHeader realm] ); 
}

-(void)testBuildFromStringWithUnkownEntries { 
	
	NSString* input = @"Digest realm=\"testrealm@host.com\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", bad-field=\"bad\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"";
	@try {
		[HLWwwAuthenticate buildFromString:input];
		// good
	}
	@catch (BaseException * e) {
        
		XCTFail( @"'bad-field' should not have caused an exception to be thrown" );
	}
}
@end
