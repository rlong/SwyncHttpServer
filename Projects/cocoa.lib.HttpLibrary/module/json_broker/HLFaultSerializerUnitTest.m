// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "CABaseException.h"
#import "CADataHelper.h"
#import "CAJsonDataInput.h"
#import "CAJsonArrayHandler.h"
#import "CALog.h"

#import "HLFaultSerializer.h"
#import "HLFaultSerializerUnitTest.h"


@implementation HLFaultSerializerUnitTest

-(void)test1 {
    Log_enteredMethod();
}

-(void)testHandleJsonBrokerFault { 
    
    Log_enteredMethod();

    
    NSString* associativeParameters = @"{\"originator\":\"HttpDispatcher:170\",\"stackTrace\":[\"0x355db8bf\",\"0x307181e5\",\"0x74757\",\"0x7541f\",\"0x78b4b\",\"0x759df\",\"0x4139b\",\"0x4170f\",\"0x6b933\",\"0x72c49\",\"0x6d50b\",\"0x32ea361d\",\"0x355afa63\",\"0x355af6c9\",\"0x355ae29f\",\"0x355314dd\",\"0x355313a5\",\"0x32e02b85\",\"0x32e1c533\",\"0x6d6ed\",\"0x32e0ea91\",\"0x32ea25a1\",\"0x35d61c1d\",\"0x35d61ad8\"],\"underlyingFaultMessage\":null,\"faultCode\":-1005,\"faultMessage\":\"The network connection was lost.\",\"faultContext\":{\"atos\":\"/usr/bin/atos -o /\"/var/mobile/Applications/581E03E0-C1B6-4BCF-B830-806ECEB39ECB/VLC Amigo.app/VLC Amigo/\"  0x355db8bf  0x307181e5  0x74757  0x7541f  0x78b4b  0x759df  0x4139b  0x4170f  0x6b933  0x72c49  0x6d50b  0x32ea361d  0x355afa63  0x355af6c9  0x355ae29f  0x355314dd  0x355313a5  0x32e02b85  0x32e1c533  0x6d6ed  0x32e0ea91  0x32ea25a1  0x35d61c1d  0x35d61ad8\"}}";
    NSString* input = [NSString stringWithFormat:@"[\"oneway\",{},\"vlc_amigo.RgPairGuiService\",1,0,\"showErrorDialog\",%@]", associativeParameters];
    
    Log_debugString( input );
    
    NSData* data = [CADataHelper getUtf8Data:input];
    
    CAJsonDataInput* jsonDataInput = [[CAJsonDataInput alloc] initWithData:data];
    
    HLJsonArray* jsonArray = [[CAJsonArrayHandler getInstance] readJSONArray:jsonDataInput];
    
    XCTAssertTrue( 7 == [jsonArray count], @"actual = %d", [jsonArray count]);
    
}

-(void)testException  {

    
    NSException* e = nil;
    
    @try {
        BaseException* e2 = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@""];
        
        @throw e2;

    }
    @catch (NSException *exception) {
        e = exception;
    }
    
    
    HLJsonObject* jo = [HLFaultSerializer toJSONObject:e];
    
    Log_debugString( [jo toString] );
    
    
    
    
}

@end







