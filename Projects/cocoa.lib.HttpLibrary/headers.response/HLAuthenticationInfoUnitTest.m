// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <XCTest/XCTest.h>


#import "CABaseException.h"
#import "CALog.h"

#import "HLAuthenticationInfo.h"




@interface HLAuthenticationInfoUnitTest : XCTestCase

@end


@implementation HLAuthenticationInfoUnitTest


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
	
	NSString* input = @"cnonce=\"0a4f113b\", nc=000000FF, nextnonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", qop=auth-int, rspauth=\"6629fae49393a05397450978507c4ef1\"";
	
	HLAuthenticationInfo* authenticationInfoHeader = [HLAuthenticationInfo buildFromString:input];
	
	XCTAssertTrue( [@"0a4f113b" isEqualToString:[authenticationInfoHeader cnonce]], @"actual = %@", [authenticationInfoHeader cnonce] ); 
	XCTAssertTrue( 255 == [authenticationInfoHeader nc], @"actual = %d", [authenticationInfoHeader nc] ); 
	XCTAssertTrue( [@"dcd98b7102dd2f0e8b11d0f600bfb0c093" isEqualToString:[authenticationInfoHeader nextnonce]], @"actual = %@", [authenticationInfoHeader nextnonce] ); 
	XCTAssertTrue( [@"auth-int" isEqualToString:[authenticationInfoHeader qop]], @"actual = %@", [authenticationInfoHeader qop] ); 
	XCTAssertTrue( [@"6629fae49393a05397450978507c4ef1" isEqualToString:[authenticationInfoHeader rspauth]], @"actual = %@", [authenticationInfoHeader rspauth] ); 
    
    
    Log_debugString([authenticationInfoHeader toString] );
	
	
}

-(void)testBuildFromStringWithUnkownEntries { 

	NSString* input = @"nextnonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", bad-field=\"bad\"";

	@try {
		[HLAuthenticationInfo buildFromString:input];
		// good
	}
	@catch (BaseException * e) {
		XCTFail( @"'bad-field' should not have caused an exception to be thrown" );
	}
}

@end
