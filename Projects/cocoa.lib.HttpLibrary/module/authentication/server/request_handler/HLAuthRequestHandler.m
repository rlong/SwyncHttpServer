//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CABaseException.h"

#import "HLAuthorization.h"
#import "HLAuthRequestHandler.h"
#import "HLBrokerMessage.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpSecurityManager.h"
#import "HLHttpStatus.h"
#import "HLHttpStatus_ErrorDomain.h"
#import "HLServicesRegistery.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLAuthRequestHandler () 


// processors
//NSMutableDictionary* _processors;
@property (nonatomic, retain) NSMutableDictionary* processors;
//@synthesize processors = _processors;


// securityManager
//HttpSecurityManager* _securityManager;
@property (nonatomic, retain) HLHttpSecurityManager* securityManager;
//@synthesize securityManager = _securityManager;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLAuthRequestHandler


static NSString* _REQUEST_URI = @"/_dynamic_/auth"; 



-(void)addRequestHandler:(id<HLRequestHandler>)processor {
    
    NSString* requestUri = [NSString stringWithFormat:@"%@%@", _REQUEST_URI, [processor getProcessorUri]];
    Log_debugString( requestUri );
    
    [_processors setObject:processor forKey:requestUri];
    
}


-(id<HLRequestHandler>)getRequestHandler:(NSString*)requestUri {
    
    Log_debugString( requestUri );
    
    NSRange indexOfQuestionMark = [requestUri rangeOfString:@"?"];
    if( NSNotFound != indexOfQuestionMark.location ) { 
        
        requestUri = [requestUri substringToIndex:indexOfQuestionMark.location];
    }
    
    
    id<HLRequestHandler> answer = [_processors objectForKey:requestUri];
    
    return answer;
}

-(NSString*)getProcessorUri {
    return _REQUEST_URI;
}


-(HLAuthorization*)getAuthorizationRequestHeader:(HLHttpRequest*)request {
    
    HLAuthorization* answer = nil;
    
    
    NSString* authorization = [request getHttpHeader:@"authorization"];
    if( nil == authorization ) {
        
        Log_error( @"nil == authorization" );
        @throw  [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
    }
    
    answer = [HLAuthorization buildFromString:authorization];
    
    if( ![@"auth" isEqualToString:[answer qop]] ) { 
    
        Log_errorFormat( @"![@\"auth\" isEqualToString:[answer qop]]; [answer qop] = '%@'", [answer qop] );
        @throw  [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
    }
    
    return answer;
    
}


-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    
    NSString* requestUri = [request requestUri];
    
    id<HLRequestHandler> httpProcessor;
    {
        httpProcessor = [self getRequestHandler:requestUri];
        
        if( nil ==  httpProcessor ) {
            
            Log_errorFormat( @"nil ==  processor; requestUri = '%@'", requestUri );
            @throw [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
        }

    }
    
    
    HLHttpResponse* answer = nil;
    HLAuthorization* authorization = nil;
    
    @try {
        authorization = [self getAuthorizationRequestHeader:request];
        [_securityManager authenticateRequest:[[request method] name] authorizationRequestHeader:authorization];
        
        answer = [httpProcessor processRequest:request];
        return answer;
    }
    @catch (BaseException *exception) {
        
        NSString* UNAUTHORIZED_401 = [[HLHttpStatus errorDomain] UNAUTHORIZED_401];
        
        if( [UNAUTHORIZED_401 isEqualToString:[exception errorDomain]] ) {
            Log_warn( [exception reason] );
        } else {
            Log_errorException( exception );
        }
        
        answer = [HLHttpErrorHelper toHttpResponse:exception];
        return answer;            
    }
    @catch (NSException *exception) {
        Log_errorException( exception );
        answer = [HLHttpErrorHelper toHttpResponse:exception];
        return answer;
    }
    @finally {
        id<HLHttpHeader> header = [_securityManager getHeaderForResponse:authorization responseStatusCode:[answer status] responseEntity:[answer entity]];
        [answer putHeader:[header getName] value:[header getValue]];

    }
    
}


#pragma mark instance lifecycle

-(id)initWithSecurityManager:(HLHttpSecurityManager*)httpSecurityManager { 
    
    HLAuthRequestHandler* answer = [super init];
    
    if( nil != answer ) { 
        
        answer->_processors = [[NSMutableDictionary alloc] init];
        [answer setSecurityManager:httpSecurityManager];
        
    }
    
    return answer;
    
}


-(void)dealloc {
	
	[self setProcessors:nil];
	[self setSecurityManager:nil];
	
	
}


#pragma mark fields

// processors
//NSMutableDictionary* _processors;
//@property (nonatomic, retain) NSMutableDictionary* processors;
@synthesize processors = _processors;


// securityManager
//HttpSecurityManager* _securityManager;
//@property (nonatomic, retain) HttpSecurityManager* securityManager;
@synthesize securityManager = _securityManager;



@end
