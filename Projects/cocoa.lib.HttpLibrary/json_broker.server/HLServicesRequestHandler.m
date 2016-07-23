//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CADataHelper.h"
#import "CADefaults.h"
#import "CALog.h"
#import "CAJsonArrayHelper.h"

#import "HLBrokerMessageType.h"
#import "HLDataEntity.h"
#import "HLEntityHelper.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLSerializer.h"
#import "HLServicesRequestHandler.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLServicesRequestHandler () 

// servicesRegistery
//ServicesRegistery* _servicesRegistery;
@property (nonatomic, retain) HLServicesRegistery* servicesRegistery;
//@synthesize servicesRegistery = _servicesRegistery;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLServicesRequestHandler


static int _MAXIMUM_REQUEST_ENTITY_LENGTH;

+(void)initialize {
    
    
    CADefaults* defaults = [CADefaults getDefaultsForScope:@"vlc_amigo.ServicesRequestHandler"];

    _MAXIMUM_REQUEST_ENTITY_LENGTH = [defaults intWithName:@"_MAXIMUM_REQUEST_ENTITY_LENGTH" defaultValue:32 * 1024];
    Log_debugInt( _MAXIMUM_REQUEST_ENTITY_LENGTH );
    
}


-(void)addService:(id<HLDescribedService>)service {
    
    Log_debugString( [[service serviceDescription] serviceName] );
    
    [_servicesRegistery addService:service];
    
}

#pragma mark -
#pragma mark <HLRequestHandler> implementation



+(HLBrokerMessage*)processBrokerRequest:(HLBrokerMessage*)request  withServiceRegistery:(HLServicesRegistery*)servicesRegistery {
    
    @try {
        
        return [servicesRegistery process:request];
        
    }
    @catch (NSException *exception) {
        Log_errorException( exception );
        return [HLBrokerMessage buildFault:request exception:exception];
    }
}


+(HLHttpResponse*)processPostRequest:(HLHttpRequest*)request withServiceRegistery:(HLServicesRegistery*)servicesRegistery {
    
    if( [HLHttpMethod POST] != [request method] ) {
        Log_errorFormat( @"unsupported method; [[request method] name] = '%@'", [[request method] name]);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    id<HLEntity> entity = [request entity];
    
    
    
    if( _MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength] ) {
        Log_errorFormat( @"_MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength]; _MAXIMUM_REQUEST_ENTITY_LENGTH = %d; [entity getContentLength] = %d", _MAXIMUM_REQUEST_ENTITY_LENGTH, [entity getContentLength]);
        @throw  [HLHttpErrorHelper requestEntityTooLarge413FromOriginator:self line:__LINE__];
    }
    
    
    NSData* data = [HLEntityHelper toData:entity];
    
    
    HLBrokerMessage* call = [HLSerializer deserialize:data];
    HLBrokerMessage* response = [self processBrokerRequest:call withServiceRegistery:servicesRegistery];
    
    
    HLHttpResponse* answer;
    {
        if( [HLBrokerMessageType oneway] == [call messageType] ) {
            
            answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_NO_CONTENT_204];
            
        } else {
        
            CAJsonArray* responseComponents = [response toJsonArray];
            NSData* responseData = [CAJsonArrayHelper toData:responseComponents];
            
            
            id<HLEntity> responseBody = [[HLDataEntity alloc] initWithData:responseData];
            
            answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:responseBody];
        }
    }

    return answer;
}



-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    return [HLServicesRequestHandler processPostRequest:request withServiceRegistery:_servicesRegistery];
    
}

-(NSString*)getProcessorUri {
    return @"/services";
    
}


#pragma mark -
#pragma mark instance lifecycle 



-(id)init {

    HLServicesRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        answer->_servicesRegistery = [[HLServicesRegistery alloc] init];
    }
    
    return answer;

}


-(id)initWithServicesRegistery:(HLServicesRegistery*)servicesRegistery {
    
    
    HLServicesRequestHandler* answer = [super init];

    if( nil != answer ) {
        [answer setServicesRegistery:servicesRegistery];
    }
    
    
    return answer;
    
}

-(void)dealloc {
	
    [self setServicesRegistery:nil];
	
	
}


#pragma mark fields


// servicesRegistery
//ServicesRegistery* _servicesRegistery;
//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
@synthesize servicesRegistery = _servicesRegistery;



@end
