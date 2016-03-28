//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CABaseException.h"

#import "HLIntegrationTestUtilities.h"
#import "HLTestService.h"
#import "HLTestServiceIntegrationTest.h"
#import "HLTestProxy.h"

@implementation HLTestServiceIntegrationTest



-(void)test1 {
    
    Log_enteredMethod();
}


-(HLTestProxy*)buildProxy {

    HLTestService* testService = [[HLTestService alloc] init];
    [testService autorelease];
    
    id<HLService> service = [[HLIntegrationTestUtilities getInXCTAnce] wrapService:testService];
    
    HLTestProxy* answer = [[HLTestProxy alloc] initWithService:service];
    [answer autorelease];
    
    return answer;

}

-(void)testPing {

    HLTestProxy* proxy = [self buildProxy];
    [proxy ping];
}


-(void)testRaiseError { 
    
    Log_enteredMethod();
    
    HLTestProxy* proxy = [self buildProxy];
    {
        @try {
            [proxy raiseError];
            XCTFail( @"'BaseException' should have been thrown, %d",0);
        }
        @catch (BaseException *exception) {
            NSString* actual = [exception errorDomain];
            XCTAssertTrue( [@"jsonbroker.TestService.RAISE_ERROR" isEqualToString:actual], @"actual = '%@'", actual);
            
        }
    }
    
}


//#define SOAK_TEST
#ifdef SOAK_TEST

-(void)testSoak {
    
    Log_enteredMethod();
    
    TestProxy* proxy = [self buildProxy];

    
    for( int i = 0; i < 1024; i++ )  {
        
        if( 0 == i%10) {
            Log_debugInt( i );
        }
        
        @try {
            [proxy ping];
        }
        @catch (BaseException *exception) {
            Log_warnInt( [exception faultCode] );
        }
    }
}

#endif


@end
