//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CABaseException.h"
#import "CAJsonObject.h"

#import "HLBrokerMessageType.h"
#import "HLServiceHelper.h"
#import "HLServicesRegistery.h"
#import "HLMainThreadServiceDelegator.h"



@implementation HLServicesRegisteryErrorDomain

-(NSString*)SERVICE_NOT_FOUND {
    return @"jsonbroker.ServicesRegistery.SERVICE_NOT_FOUND";
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLServicesRegistery () 

//NSMutableDictionary* _services;
@property (nonatomic, retain) NSMutableDictionary* services;
//@synthesize services = _services;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLServicesRegistery


static HLServicesRegisteryErrorDomain* _errorDomain = nil;

+(void)initialize {
	
	_errorDomain = [[HLServicesRegisteryErrorDomain alloc] init];
	
}

+(HLServicesRegisteryErrorDomain*)errorDomain {
    return _errorDomain;
}


-(void)addMainThreadService:(id<HLMainThreadService>)service  {

    if( nil == service ) {
        Log_warnPointer( (__bridge  void *)service  );
        return;
    }
    
    NSString* serviceName = [[service serviceDescription] serviceName];
    
    id<HLService> existingService = [_services objectForKey:serviceName];
    if( nil != existingService ) {
        Log_warnString( serviceName );
        Log_warnPointer( (__bridge  void *)existingService );
    }
    
    HLMainThreadServiceDelegator* mainThreadService = [[HLMainThreadServiceDelegator alloc] initWithDelegate:service];
    
    [_services setObject:mainThreadService forKey:serviceName];
    

}


-(void)addService:(id<HLDescribedService>)service {

    
    // vvv http://stackoverflow.com/questions/2344672/objective-c-given-a-class-id-can-i-check-if-this-class-implements-a-certain-p
    
    if( [[service class] conformsToProtocol:@protocol(HLMainThreadService)] ) 
        
        // ^^^ http://stackoverflow.com/questions/2344672/objective-c-given-a-class-id-can-i-check-if-this-class-implements-a-certain-p
    { 
        
        id<HLMainThreadService> userInterfaceService = (id<HLMainThreadService>)service;
        [self addMainThreadService:userInterfaceService];
        
    } else { 
        
        NSString* serviceName = [[service serviceDescription] serviceName];
        [_services setObject:service forKey:serviceName];
    }

}





-(bool)hasService:(NSString*)serviceName {

    id<HLService> answer = [_services objectForKey:serviceName];
    
	if( nil != answer ) { 
        return true;
    }
    return false;
}

-(id<HLService>)getService:(NSString*)serviceName {
	
	
	id<HLService> answer = [_services objectForKey:serviceName];
	if( nil == answer ) { 
        
        if( nil != _next ) { 
            return [_next getService:serviceName];
        }
        
		NSString* technicalError = [NSString stringWithFormat:@"null == answer, serviceName = '%@'", serviceName];
		
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e setErrorDomain:[_errorDomain SERVICE_NOT_FOUND]];
		@throw e;
							  
	}
	
	return answer;
	
}


-(void)removeService:(id<HLDescribedService>)serviceToRemove {
 
    Log_enteredMethod();
    
    if( nil == serviceToRemove ) {
        Log_warnPointer( (__bridge void *)serviceToRemove  );
        return;
    }

    NSString* serviceName = [[serviceToRemove serviceDescription] serviceName];
	
    id<HLService> service = [_services objectForKey:serviceName];

    if( nil == service ) { 
		
		NSString* warning = [NSString stringWithFormat:@"nil == service; serviceName = '%@'", serviceName];
        Log_warn( warning );
        return;
	}
    
    if( serviceToRemove != service ) { 
		NSString* warning = [NSString stringWithFormat:@"serviceToRemove != service; serviceName = '%@'; serviceToRemove = %p; service = %p", serviceName, serviceToRemove, service];
        Log_warn( warning );
        return;
        
    }
    
	[_services removeObjectForKey:serviceName];

}


-(HLBrokerMessage*)processMetaRequest:(HLBrokerMessage*)request {
    
    
    NSString* methodName = [request methodName];
    
    if( [@"getVersion" isEqualToString:methodName] ) { 
        
        NSString* serviceName = [request serviceName];
        
        HLBrokerMessage* answer = [HLBrokerMessage buildMetaResponse:request];
        CAJsonObject* associativeParamaters = [answer associativeParamaters];
        
        id<HLDescribedService> describedService = [_services objectForKey:serviceName];
        if( nil == describedService ) { 
            
            [associativeParamaters setBool:false forKey:@"exists"];
            
        } else {
            
            [associativeParamaters setBool:true forKey:@"exists"];
            HLServiceDescription* serviceDescription = [describedService serviceDescription];
            [associativeParamaters setInt:[serviceDescription majorVersion] forKey:@"majorVersion"];
            [associativeParamaters setInt:[serviceDescription minorVersion] forKey:@"minorVersion"];
            
        }
        
        return answer;
        
    }
    
    @throw [HLServiceHelper methodNotFound:self request:request];
    
}

#pragma mark <Service> implmentation 




-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
    
    
    if( [HLBrokerMessageType metaRequest] == [request messageType] ) { 
        
        return [self processMetaRequest:request];
        
    }
    

    NSString* serviceName = [request serviceName];
    id<HLService> serviceDelegate = [self getService:serviceName];
    return [serviceDelegate process:request];
    
}


#pragma mark instance lifecycle

-(id)init { 
	
	HLServicesRegistery* answer = [super init];
	
	
	answer->_services = [[NSMutableDictionary alloc] init];
	 
	
	return answer;
}

// 'next' can be nil
-(id)initWithService:(id<HLDescribedService>)service next:(HLServicesRegistery*)next { 
    
    HLServicesRegistery* answer = [super init];
	
	
	answer->_services = [[NSMutableDictionary alloc] init];
    [answer addService:service];      
    [answer setNext:next];
    
	return answer;

}


-(void)dealloc {
	
	
	[self setServices:nil];
    [self setNext:nil];
	
}

#pragma mark fields

//NSMutableDictionary* _services;
//@property (nonatomic, retain) NSMutableDictionary* services;
@synthesize services = _services;


#pragma mark fields


// next
//ServicesRegistery* _next;
//@property (nonatomic, retain) ServicesRegistery* next;
@synthesize next = _next;



@end
