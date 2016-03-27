// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CAInputStreamHelper.h"
#import "CALog.h"

#import "HLStreamEntity.h"
#import "HLEntity.h"
#import "HLHttpDispatcher.h"
#import "HLHttpRunLoop.h"
#import "HLDataEntity.h"
#import "HLHttpStatus.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpDispatcher ()
@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLHttpDispatcher





+(NSDictionary*)getHeaders:(NSURLResponse *)response {
 
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary* allHeaderFields = [httpResponse allHeaderFields];
    
    NSMutableDictionary* answer = [[NSMutableDictionary alloc] initWithCapacity:[allHeaderFields count]];
    
    for( NSString* key in allHeaderFields ) {
        
        NSString* value = [allHeaderFields objectForKey:key];
        
        [answer setObject:value forKey:[key lowercaseString]];
    }
    
    return answer;

}





// authenticator can be null 
-(int)dispatch:(NSMutableURLRequest*)request authenticator:(HLAuthenticator*)authenticator responseHandler:(id<HLHttpResponseHandler>)responseHandler {
    
    
    NSURLResponse* urlResponse = nil;
	NSError* error = nil;

    HLHttpRunLoop* httpRunLoop = [HLHttpRunLoop getInstance];
    
	NSData* data = [httpRunLoop sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
	if( nil != error ) { 
        
        Log_errorInt( [error code] );
        Log_errorString( [error localizedDescription] );
        {
            NSDictionary* userInfo = [error userInfo];
            for( NSString* key in userInfo ) { 
                Log_debugString( key );
                NSObject* value = [userInfo objectForKey:key];
                Log_debugString( NSStringFromClass([value class]));
                if( [value isKindOfClass:[NSString class]] ) {
                    Log_debugString( (NSString*)value );
                }
            }
        }
        
		NSString* technicalError = [error localizedDescription];
		
		CABaseException* e = [[CABaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e setFaultCode:(int)[error code]];
		[e setError:error];
		
		@throw e;
		
	}
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)urlResponse;


    @try {

        NSDictionary* responsehHeaders = [HLHttpDispatcher getHeaders:httpResponse];
        if( nil != authenticator ) { 
            [authenticator handleHttpResponseHeaders:responsehHeaders];
        }
        
        int statusCode = (int)[httpResponse statusCode];
        if( 200 <= statusCode && 300 > statusCode ) {
            
            // all is well
            if( nil == data ) { // e.g. http 204 
                [responseHandler handleResponseHeaders:responsehHeaders responseEntity:nil];
            } else {
                HLDataEntity* dataEntity = [[HLDataEntity alloc] initWithData:data];
                [responseHandler handleResponseHeaders:responsehHeaders responseEntity:dataEntity];                
            }
        }
        return statusCode;
    }
    @finally {
        // close a stream in java & C# ... no equivalent in objective-c 
    }

}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


// authenticator can be null 
-(NSMutableURLRequest*)buildGetRequest:(HLHttpRequestAdapter*)requestAdapter authenticator:(HLAuthenticator*)authenticator { 
    
    NSString* requestUri = [requestAdapter requestUri];
    
    NSString* urlString = [NSString stringWithFormat:@"http://%@%@", [_networkAddress toString], requestUri];
    // Log_debugString( urlString );
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* answer = [NSMutableURLRequest requestWithURL:url];
    
    [answer setHTTPMethod:@"GET"]; // just to be explicit
    
    // extra headers ... 
    {
    
        NSDictionary* requestHeaders = [requestAdapter requestHeaders];
        for( NSString* name in requestHeaders ) { 
            NSString* value = [requestHeaders objectForKey:name];
            [answer addValue:value forHTTPHeaderField:name];
            // Log_debugFormat( @"%@: %@", name, value );
        }        
    }
    
    if( nil != authenticator ) { 

        NSString* authorization = [authenticator getRequestAuthorizationForMethod:[answer HTTPMethod] requestUri:requestUri entity:nil];

        if( nil != authorization ) {
            [answer addValue:authorization forHTTPHeaderField:@"Authorization"];
        }
    }
    
    return answer;
    
}





////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


-(void)get:(HLHttpRequestAdapter*)requestAdapter authenticator:(HLAuthenticator*)authenticator responseHandler:(id<HLHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildGetRequest:requestAdapter authenticator:authenticator];
    
    int statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    
    if( 401 == statusCode ) {
        request = [self buildGetRequest:requestAdapter authenticator:authenticator];
        statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    }
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[HLHttpStatus getReason:statusCode]];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
}


-(void)get:(HLHttpRequestAdapter*)requestAdapter responseHandler:(id<HLHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildGetRequest:requestAdapter authenticator:nil];
    
    int statusCode = [self dispatch:request authenticator:nil responseHandler:responseHandler];
    
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[HLHttpStatus getReason:statusCode]];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
    
    
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////



// authenticator can be null 
-(NSMutableURLRequest*)buildPostRequest:(HLHttpRequestAdapter*)requestAdapter authenticator:(HLAuthenticator*)authenticator { 
    
    NSString* requestUri = [requestAdapter requestUri];
    id<HLEntity> entity = [requestAdapter requestEntity];
    
    NSString* urlString = [NSString stringWithFormat:@"http://%@%@", [_networkAddress toString], requestUri];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* answer = [NSMutableURLRequest requestWithURL:url];
    [answer setHTTPMethod:@"POST"]; // just to be explicit
    
    
    // extra headers ... 
    {
        
        NSDictionary* requestHeaders = [requestAdapter requestHeaders];
        for( NSString* name in requestHeaders ) { 
            NSString* value = [requestHeaders objectForKey:name];
            [answer addValue:value forHTTPHeaderField:name];
        }        
    }
    
    // auth headers ... 
    if( nil != authenticator ) { 
        NSString* authorization = [authenticator getRequestAuthorizationForMethod:[answer HTTPMethod] requestUri:requestUri entity:entity];

        if( nil != authorization ) {
            [answer addValue:authorization forHTTPHeaderField:@"Authorization"];
        } else {
            // no-op
        }
    }
    
    // body ... 
    if( [entity isKindOfClass:[HLDataEntity class]] ) { 
        
        HLDataEntity* dataEntity = (HLDataEntity*)entity;
        [answer setHTTPBody:[dataEntity data]];
    } else { 

        NSInputStream* inputStream = [entity getContent];
        int contentLength = (int)[entity getContentLength];
        
        NSData* httpBody = [CAInputStreamHelper readDataFromStream:inputStream count:contentLength];
        [answer setHTTPBody:httpBody];
    }
    
    NSString* contentLength = [NSString stringWithFormat:@"%lld", [entity getContentLength]];
    [answer setValue:contentLength forHTTPHeaderField:@"Content-Length"];

    return answer;
    
}


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


-(void)post:(HLHttpRequestAdapter*)requestAdapter authenticator:(HLAuthenticator*)authenticator responseHandler:(id<HLHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildPostRequest:requestAdapter authenticator:authenticator];
    
    int statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    
    if( 401 == statusCode ) {
        request = [self buildPostRequest:requestAdapter authenticator:authenticator];
        statusCode = [self dispatch:request authenticator:authenticator responseHandler:responseHandler];
    }
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[HLHttpStatus getReason:statusCode]];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
}


-(void)post:(HLHttpRequestAdapter*)requestAdapter responseHandler:(id<HLHttpResponseHandler>)responseHandler {
    
    
    NSMutableURLRequest* request = [self buildPostRequest:requestAdapter authenticator:nil];
    
    int statusCode = [self dispatch:request authenticator:nil responseHandler:responseHandler];
    
    
    if( statusCode < 200 || statusCode > 299 ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:[HLHttpStatus getReason:statusCode]];
        [e setFaultCode:statusCode];
        NSString* requestUri = [requestAdapter requestUri];
        [e addStringContext:requestUri withName:@"requestUri"];
        @throw  e;
    }
        
}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithNetworkAddress:(CANetworkAddress*)networkAddress {
	
	HLHttpDispatcher* answer = [super init];
	
	
	[answer setNetworkAddress:networkAddress];
	
	return answer;
	
}

-(void)dealloc { 
	
	Log_enteredMethod();
	
	[self setNetworkAddress:nil];
	
}

#pragma mark -
#pragma mark fields

//NetworkAddress* _networkAddress;
//@property (nonatomic, retain) NetworkAddress* networkAddress;
@synthesize networkAddress = _networkAddress;


		   
@end


