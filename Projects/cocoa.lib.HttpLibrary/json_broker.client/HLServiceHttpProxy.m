// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "CALog.h"
#import "CAJsonArray.h"
#import "CAJsonArrayHelper.h"

#import "HLDataEntity.h"
#import "HLServiceHttpProxy.h"
#import "HLSerializer.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLServiceHttpProxy () 

// httpDispatcher
//HttpDispatcher* _httpDispatcher;
@property (nonatomic, retain) HLHttpDispatcher* httpDispatcher;
//@synthesize httpDispatcher = _httpDispatcher;




// responseHandler
//BrokerMessageResponseHandler* _responseHandler;
@property (nonatomic, retain) HLBrokerMessageResponseHandler* responseHandler;
//@synthesize responseHandler = _responseHandler;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLServiceHttpProxy



-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
    
    CAJsonArray* messageComponents = [request toJsonArray];
    NSData* bodyData = [CAJsonArrayHelper toData:messageComponents];
    
    
    id<HLEntity> entity = [[HLDataEntity alloc] initWithData:bodyData];
    
    NSString* requestUri;
    
    if( nil == _authenticator ) {
        requestUri = @"/_dynamic_/open/services";
    } else {
        if( [_authenticator authInt] ) { 
            requestUri = @"/_dynamic_/auth-int/services";
        } else {
            requestUri = @"/_dynamic_/auth/services";
        }
    }
    
    HLHttpRequestAdapter* requestAdapter = [[HLHttpRequestAdapter alloc] initWithRequestUri:requestUri];
    [requestAdapter setRequestEntity:entity];
    
    [_httpDispatcher post:requestAdapter authenticator:_authenticator responseHandler:_responseHandler];
    
    return [_responseHandler getResponse];
    
}


// can return nil
-(NSString*)realm {

    if( nil == _authenticator ) { 
        return nil;
    }
    
    NSString* realm = [_authenticator realm];
    return realm;
    
}

-(NSString*)serviceName {
    return nil;
}

#pragma mark instance lifecycle

-(id)initWithHttpDispatcher:(HLHttpDispatcher*)httpDispatcher {
    
    HLServiceHttpProxy* answer = [super init];
    
    [answer setHttpDispatcher:httpDispatcher];
    answer->_authenticator = nil; // just to be clear about our intent
    answer->_responseHandler = [[HLBrokerMessageResponseHandler alloc] init];
    
    return answer;
    
}


-(id)initWithHttpDispatcher:(HLHttpDispatcher*)httpDispatcher authenticator:(HLAuthenticator*)authenticator {
    
    HLServiceHttpProxy* answer = [super init];
    
    [answer setHttpDispatcher:httpDispatcher];
    [answer setAuthenticator:authenticator];
    answer->_responseHandler = [[HLBrokerMessageResponseHandler alloc] init];
    
    return answer;

}


-(void)dealloc {
	
	[self setHttpDispatcher:nil];
	[self setAuthenticator:nil];
    [self setResponseHandler:nil];

	
}


#pragma mark fields


// httpDispatcher
//HttpDispatcher* _httpDispatcher;
//@property (nonatomic, retain) HttpDispatcher* httpDispatcher;
@synthesize httpDispatcher = _httpDispatcher;

// authenticator
//Authenticator* _authenticator;
//@property (nonatomic, retain) Authenticator* authenticator;
@synthesize authenticator = _authenticator;


// responseHandler
//BrokerMessageResponseHandler* _responseHandler;
//@property (nonatomic, retain) BrokerMessageResponseHandler* responseHandler;
@synthesize responseHandler = _responseHandler;



@end
