// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CABaseException.h"
#import "CADataHelper.h"
#import "CAJsonArrayHandler.h"
#import "CAJsonDataInput.h"
#import "CAJsonStringOutput.h"

#import "HLSerializer.h"



@implementation HLSerializer


static CAJsonArrayHandler* _jsonArrayHandler = nil; 

+(void)initialize {
	
    _jsonArrayHandler = [CAJsonArrayHandler getInstance];
	
}

	
+(HLBrokerMessage*)deserialize:(NSData*)data {
	
	CAJsonDataInput* reader = [[CAJsonDataInput alloc] initWithData:data];
	
    
    //Log_debugData( data );
    
	[reader scanToNextToken];

    CAJsonArray* messageComponents;
    @try {
        messageComponents = [[CAJsonArrayHandler getInstance] readJSONArray:reader];
    }
    @catch (BaseException *exception) {
        
        [exception addIntContext:[reader cursor] withName:@"Serializer.dataOffset"];
        @throw exception;
        
    }
	
	HLBrokerMessage* answer = [[HLBrokerMessage alloc] initWithValues:messageComponents];
	
	return answer;
	
}


@end
