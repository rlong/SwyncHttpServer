// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CAJsonObject.h"

#import "HLBrokerMessage.h"
#import "HLMetaProxy.h"
#import "HLService.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLMetaProxy () 

// service
//id<Service> _service;
@property (nonatomic, retain) id<HLService> service;
//@synthesize service = _service;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLMetaProxy


-(NSArray*)getVersion:(NSString*)serviceName {
    
    HLBrokerMessage* metaRequest = [HLBrokerMessage buildMetaRequestWithServiceName:serviceName methodName:@"getVersion"];
    HLBrokerMessage* metaResponse = [_service process:metaRequest];
    
    CAJsonObject* associativeParamaters = [metaResponse associativeParamaters];
    bool exists = [associativeParamaters boolForKey:@"exists"];
    
    if( !exists ) { 
        return nil;
    } else {
        int majorVersion = [associativeParamaters intForKey:@"majorVersion"];
        int minorVersion = [associativeParamaters intForKey:@"minorVersion"];
        
        NSArray* answer = [NSArray arrayWithObjects:[NSNumber numberWithInt:majorVersion], [NSNumber numberWithInt:minorVersion], nil];
        return answer;
    }
    
}

#pragma mark instance lifecycle

-(id)initWithService:(id<HLService>)service {
    
    HLMetaProxy* answer = [super init];
    
    
    if( nil != answer ) {
        
        [answer setService:service];
    
    }
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setService:nil];
	
	
}


#pragma mark fields

// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;

@end
