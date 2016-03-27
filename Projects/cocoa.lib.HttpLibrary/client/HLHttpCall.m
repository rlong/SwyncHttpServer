// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "HLHttpCall.h"


#define PENDING_COMPLETION 100
#define COMPLETED 300


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpCall ()


// started
//NSDate* _started;
@property (nonatomic, retain) NSDate* started;
//@synthesize started = _started;

// url
//NSString* _url;
@property (nonatomic, retain) NSString* url;
//@synthesize url = _url;


// conditionLock
//NSConditionLock* _conditionLock;
@property (nonatomic, retain) NSConditionLock* conditionLock;
//@synthesize conditionLock = _conditionLock;


// urlConnection
//NSURLConnection* _urlConnection;
@property (nonatomic, retain) NSURLConnection* urlConnection;
//@synthesize urlConnection = _urlConnection;

// request
//NSURLRequest* _request;
@property (nonatomic, retain) NSURLRequest* request;
//@synthesize request = _request;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLHttpCall


-(void)start:(NSRunLoop*)runLoop {
    
    [_urlConnection scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    
    [self setStarted:[NSDate date]];
    [_urlConnection start];
    
    
}



-(void)httpCallCompleted {
    
    
    NSString* httpStatus = @"-";
    if( nil != _response && [_response isKindOfClass:[NSHTTPURLResponse class]] ) { 
        
        NSHTTPURLResponse* httpUrlResponse = (NSHTTPURLResponse*)_response;
        httpStatus = [NSString stringWithFormat:@"%ld", (long)[httpUrlResponse statusCode]];
    }
    
    NSString* contentLength = @"-";
    if( nil != _responseData ) { 
        contentLength = [NSString stringWithFormat:@"%ld", (long)[_responseData length]];
        //Log_debugData( _responseData );
    }
    
    NSTimeInterval timeTaken;
    {
        NSDate* now = [NSDate date];
        NSTimeInterval nowTimeIntervalSince1970 = [now timeIntervalSince1970];
        NSTimeInterval startedTimeIntervalSince1970 = [_started timeIntervalSince1970];
        timeTaken = nowTimeIntervalSince1970 - startedTimeIntervalSince1970;
        
    }
    
    NSString* logMessage = [NSString stringWithFormat:@"%@ %@ %@ %f", httpStatus, _url, contentLength, timeTaken];
    Log_info( logMessage );
    
}


#pragma mark -
#pragma mark <NSURLConnectionDelegate> implementation

#pragma mark NSURLConnection delegate callbacks related to "Connection Authentication"



- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    Log_enteredMethod();
    
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    
    
}

////This method is called before connection:didReceiveAuthenticationChallenge:, allowing the delegate to inspect a protection space before attempting to authenticate against it. By returning YES, the delegate indicates that it can handle the form of authentication, which it does in the subsequent call to connection:didReceiveAuthenticationChallenge:. If the delegate returns NO, the system attempts to use the user’s keychain to authenticate. If your delegate does not implement this method and the protection space uses client certificate authentication or server trust authentication, the system behaves as if you returned NO. The system behaves as if you returned YES for all other authentication methods.
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//    
//    Log_enteredMethod();
//    
//    
//    return YES;
//}


- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    Log_enteredMethod();
}

//This method gives the delegate the opportunity to determine the course of action taken for the challenge: provide credentials, continue without providing credentials, or cancel the authentication challenge and the download.
//
//The delegate can determine the number of previous authentication challenges by sending the message previousFailureCount to challenge.
//
//If the previous failure count is 0 and the value returned by proposedCredential is nil, the delegate can create a new NSURLCredential object, providing information specific to the type of credential, and send a useCredential:forAuthenticationChallenge: message to [challenge sender], passing the credential and challenge as parameters. If proposedCredential is not nil, the value is a credential from the URL or the shared credential storage that can be provided to the user as feedback.
//
//The delegate may decide to abandon further attempts at authentication at any time by sending [challenge sender] a continueWithoutCredentialForAuthenticationChallenge: or a cancelAuthenticationChallenge: message. The specific action is implementation dependent.
//
//If the delegate implements this method, the download will suspend until [challenge sender] is sent one of the following messages: useCredential:forAuthenticationChallenge:, continueWithoutCredentialForAuthenticationChallenge: or cancelAuthenticationChallenge:.
//
//If the delegate does not implement this method the default implementation is used. If a valid credential for the request is provided as part of the URL, or is available from the NSURLCredentialStorage the [challenge sender] is sent a useCredential:forAuthenticationChallenge: with the credential. If the challenge has no credential or the credentials fail to authorize access, then continueWithoutCredentialForAuthenticationChallenge: is sent to [challenge sender] instead.
//
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    Log_enteredMethod();
    
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    //[[challenge sender] cancelAuthenticationChallenge:challenge];
}


//This method is called before any attempt to authenticate is made. By returning NO, the delegate tells the connection not to consult the credential storage and makes itself responsible for providing credentials for any authentication challenges. Not implementing this method is the same as returning YES. The delegate is free to consult the credential storage itself when it receives a connection:didReceiveAuthenticationChallenge: message.
//
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    
    Log_enteredMethod();

    return NO;
}

#pragma mark NSURLConnection delegate callbacks related to "Connection Data and Responses"



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    Log_enteredMethod();
    
    if( [response isKindOfClass:[NSHTTPURLResponse class]] ) {
        
        NSHTTPURLResponse* httpUrlResponse = (NSHTTPURLResponse*)response;
        NSDictionary *allHeaderFields = [httpUrlResponse allHeaderFields];
        for( NSString* key in allHeaderFields ) {
            Log_debugFormat( @"%@: %@", key, [allHeaderFields objectForKey:key] );
        }
    }

    
    [self setResponse:response];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    Log_enteredMethod();
    //Log_debugInt( [data length] );
    
    if( nil == _responseData ) { 
        _responseData = [[NSMutableData alloc] initWithData:data];
        return;
    }
    [_responseData appendData:data];
    
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    Log_enteredMethod();
    [self httpCallCompleted];
    [_conditionLock lock];
    [_conditionLock unlockWithCondition:COMPLETED];
    

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    [self setError:error];
    
    [self httpCallCompleted];
    [_conditionLock lock];
    [_conditionLock unlockWithCondition:COMPLETED];

}




#pragma mark -

-(void)waitUntilCompleted {
    
    [_conditionLock lockWhenCondition:COMPLETED];
    [_conditionLock unlock];
    
}

#pragma mark instance lifecycle 

-(id)initWithRequest:(NSURLRequest*)request { 
    
    HLHttpCall* answer = [super init];
    
    if( nil != answer ) { 
        
        
        [answer setUrl:[[request URL] absoluteString]];
        answer->_conditionLock = [[NSConditionLock alloc] initWithCondition:PENDING_COMPLETION]; 
        answer->_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:FALSE];
    }
    

    return answer;
    
}
-(void)dealloc {
    
    
    [self setStarted:nil];
    [self setUrl:nil];
    
    [self setConditionLock:nil];
    [self setUrlConnection:nil];
    [self setRequest:nil];    
    
    [self setResponse:nil];
    [self setResponseData:nil];
    [self setError:nil];
    
    
}

#pragma mark fields


// started
//NSDate* _started;
//@property (nonatomic, retain) NSDate* started;
@synthesize started = _started;

// url
//NSString* _url;
//@property (nonatomic, retain) NSString* url;
@synthesize url = _url;


// conditionLock
//NSConditionLock* _conditionLock;
//@property (nonatomic, retain) NSConditionLock* conditionLock;
@synthesize conditionLock = _conditionLock;


// urlConnection
//NSURLConnection* _urlConnection;
//@property (nonatomic, retain) NSURLConnection* urlConnection;
@synthesize urlConnection = _urlConnection;


// request
//NSURLRequest* _request;
//@property (nonatomic, retain) NSURLRequest* request;
@synthesize request = _request;


    
// response
//NSURLResponse* _response;
//@property (nonatomic, retain) NSURLResponse* response;
@synthesize response = _response;
     
// responseData
//NSMutableData* _responseData;
//@property (nonatomic, retain) NSMutableData* responseData;
@synthesize responseData = _responseData;

// error
//NSError* _error;
//@property (nonatomic, retain) NSError* error;
@synthesize error = _error;


@end
