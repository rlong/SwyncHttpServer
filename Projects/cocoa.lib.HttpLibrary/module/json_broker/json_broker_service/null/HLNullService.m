//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CABaseException.h"

#import "HLNullService.h"


@implementation HLNullService



-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
	
	NSString* warning = [NSString stringWithFormat:@"unimplemented; serviceName = '%@'; methodName = '%@'", [request serviceName], [request methodName]];
    Log_warn( warning );
	
	return [HLBrokerMessage buildResponse:request];
	
}


#pragma mark instance lifecycle


-(id)initWithServiceName:(NSString*)serviceName { 
    
    HLNullService* answer = [super init];
    
    [answer setServiceName:serviceName];
    
    return answer;
    
}

-(void)dealloc {
    
    [self setServiceName:nil];
	

}


#pragma mark fields


// serviceName
//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;




@end
