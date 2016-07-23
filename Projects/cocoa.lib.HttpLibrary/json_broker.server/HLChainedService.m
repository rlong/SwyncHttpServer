//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLChainedService.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLChainedService () 

// serviceName
//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;

// next
//id<Service> _serviceDelegate;
@property (nonatomic, retain) id<HLService> serviceDelegate;
//@synthesize serviceDelegate = _serviceDelegate;

// next
//id<Service> _next;
@property (nonatomic, retain) id<HLService> next;
//@synthesize next = _next;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLChainedService


#pragma mark <Service> implementation

-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
    
    NSString* serviceName = [request serviceName];
    if( [_serviceName isEqualToString:serviceName] ) { 
        return [_serviceDelegate process:request];
    }
    return [_next process:request];
    
}

#pragma mark instance lifecycle


-(id)initWithServiceName:(NSString*)serviceName serviceDelegate:(id<HLService>)serviceDelegate nextService:(id<HLService>)nextService {

    HLChainedService* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setServiceName:serviceName];
        [answer setServiceDelegate:serviceDelegate];
        [answer setNext:nextService];
    }
    
    return answer;
    
}
-(void)dealloc { 
    
    [self setServiceName:nil];
    [self setServiceDelegate:nil];
    [self setNext:nil];
    
}

#pragma mark fields


// serviceName
//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;

// next
//id<Service> _serviceDelegate;
//@property (nonatomic, retain) id<Service> serviceDelegate;
@synthesize serviceDelegate = _serviceDelegate;

// next
//id<Service> _next;
//@property (nonatomic, retain) id<Service> next;
@synthesize next = _next;


@end
