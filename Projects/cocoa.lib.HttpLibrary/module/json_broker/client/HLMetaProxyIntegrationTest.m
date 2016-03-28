// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "HLMetaProxy.h"
#import "HLMetaProxyIntegrationTest.h"
#import "HLServicesRegistery.h"
#import "HLTestService.h"

@implementation HLMetaProxyIntegrationTest


-(void)test1 {
    
    Log_enteredMethod();
}


+(HLMetaProxy*)buildProxy {
    
    HLServicesRegistery *servicesRegistery =  [[HLServicesRegistery alloc] init];
    [servicesRegistery autorelease];
    
    HLTestService* testService = [[HLTestService alloc] init];
    [servicesRegistery addService:testService];
    
    HLMetaProxy* answer = [[HLMetaProxy alloc] initWithService:servicesRegistery];
    [answer autorelease];
    
    return answer;


}


-(void)testGetInterfaceVersion {
    
    Log_enteredMethod();
    
    HLMetaProxy* proxy = [HLMetaProxyIntegrationTest buildProxy];
    
    NSArray* version = [proxy getVersion:[HLTestService SERVICE_NAME]];
    XCTAssertNotNil( version, @"version = %p", version);
    
    NSNumber* majorVersion = [version objectAtIndex:0];
    XCTAssertNotNil( majorVersion, @"majorVersion = %p", majorVersion);
    XCTAssertTrue( 1 == [majorVersion intValue], @"[majorVersion intValue] = %d", [majorVersion intValue]);
    
    NSNumber* minorVersion = [version objectAtIndex:1];
    XCTAssertNotNil( minorVersion, @"minorVersion = %p", minorVersion);
    XCTAssertTrue( 0 == [minorVersion intValue], @"[minorVersion intValue] = %d", [minorVersion intValue]);
    
    
    
}


-(void)testGetInterfaceVersionFromNonExistingService { 
    
    Log_enteredMethod();
        
    HLMetaProxy* proxy = [HLMetaProxyIntegrationTest buildProxy];
    
    NSArray* version = [proxy getVersion:@"module.non-existing-service"];
    XCTAssertNil( version, @"version = %p", version);
    
    
}

@end





