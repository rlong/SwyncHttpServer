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
	
    
    
    NSJSONReadingOptions options = NSJSONReadingMutableContainers;

    NSError *error = nil;
    id blob = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:options
                 error:&error];
    
    if( nil != error ) {
        

        @throw exceptionWithMethodNameAndError(@"[NSJSONSerialization JSONObjectWithData:options:error:]", error);
    }
    
    if(![blob isKindOfClass:[NSMutableArray class]]) {
        
        
        NSString* reason = [NSString stringWithFormat:@"![object isKindOfClass:[NSMutableArray class]]; NSStringFromClass([blob class]) = %@", NSStringFromClass([blob class])];
        @throw exceptionWithReason( reason );
        
    }


    NSMutableArray* mutableArray = (NSMutableArray*)blob;
    CAJsonArray* messageComponents = [[CAJsonArray alloc] initWithValue:mutableArray];

    HLBrokerMessage* answer = [[HLBrokerMessage alloc] initWithValues:messageComponents];
    
    return answer;

	
	
}


@end
