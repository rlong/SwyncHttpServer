//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CADataHelper.h"


#import "HLCorsServicesRequestHandler.h"
#import "HLDataEntity.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLSerializer.h"
#import "HLServicesRequestHandler.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLCorsServicesRequestHandler ()

// servicesRegistery
//ServicesRegistery* _servicesRegistery;
@property (nonatomic, retain) HLServicesRegistery* servicesRegistery;
//@synthesize servicesRegistery = _servicesRegistery;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLCorsServicesRequestHandler



-(void)addService:(id<HLDescribedService>)service {
    
    Log_debugString( [[service serviceDescription] serviceName] );

    [_servicesRegistery addService:service];
    
}

#pragma mark -
#pragma mark <HLRequestHandler> implementation




-(HLHttpResponse*)buildOptionsResponse:(HLHttpRequest*)request {
    
    HLHttpResponse* answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_NO_CONTENT_204];
    
    // vvv http://www.w3.org/TR/cors/#access-control-allow-methods-response-header
    [answer putHeader:@"Access-Control-Allow-Methods" value:@"OPTIONS, POST"];
    // ^^^ http://www.w3.org/TR/cors/#access-control-allow-methods-response-header
    
    NSString* accessControlAllowOrigin = [request getHttpHeader:@"origin"];
    if( nil == accessControlAllowOrigin ) {
        accessControlAllowOrigin = @"*";
    }
    
    [answer putHeader:@"Access-Control-Allow-Origin" value:accessControlAllowOrigin];
    
    NSString* accessControlRequestHeaders = [request getHttpHeader:@"access-control-request-headers"];
    if( nil != accessControlRequestHeaders ) {
        
        [answer putHeader:@"Access-Control-Allow-Headers" value:accessControlRequestHeaders];
    }
    
    return answer;
    
}

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    
    // vvv `chrome` (and possibly others) preflights any CORS requests
    if( [HLHttpMethod OPTIONS] == [request method] ) {
        return [self buildOptionsResponse:request];
    }
    // ^^^ `chrome` (and possibly others) preflights any CORS requests
    
    if( [HLHttpMethod POST] != [request method] ) {
        Log_errorFormat( @"unsupported method; [[request method] name] = '%@'", [[request method] name]);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    HLHttpResponse* answer = [HLServicesRequestHandler processPostRequest:request withServiceRegistery:_servicesRegistery];
    
    // vvv without echoing back the 'origin' for CORS requests, chrome (and possibly others) complains "Origin http://localhost:8081 is not allowed by Access-Control-Allow-Origin."
    
    {
        NSString* origin = [request getHttpHeader:@"origin"];
        if( nil != origin ) {
            
            [answer putHeader:@"Access-Control-Allow-Origin" value:origin];
        }
    }
    
    // ^^^ without echoing back the 'origin' for CORS requests, chrome (and possibly others) complains "Origin http://localhost:8081 is not allowed by Access-Control-Allow-Origin."
    
    
    return answer;
    
}

-(NSString*)getProcessorUri {
    return @"/cors_services";
    
}


#pragma mark -
#pragma mark instance lifecycle



-(id)init {
    
    HLCorsServicesRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        answer->_servicesRegistery = [[HLServicesRegistery alloc] init];
    }
    
    return answer;
    
}

-(id)initWithServicesRegistery:(HLServicesRegistery*)servicesRegistery {
    
    
    HLCorsServicesRequestHandler* answer = [super init];
    
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
