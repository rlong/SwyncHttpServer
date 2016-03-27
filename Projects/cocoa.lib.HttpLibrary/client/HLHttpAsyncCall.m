// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CABaseException.h"

#import "HLHttpAsyncCall.h"


#define PENDING_COMPLETION 100
#define COMPLETED 300


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpAsyncCall ()


// delegate
//id<HLHttpAsyncResponseHandler> _delegate;
@property (nonatomic, assign) id<HLHttpAsyncResponseHandler> delegate;
//@synthesize delegate = _delegate;


// urlConnection
//NSURLConnection* _urlConnection;
@property (nonatomic, retain) NSURLConnection* urlConnection;
//@synthesize urlConnection = _urlConnection;

// conditionLock
//NSConditionLock* _conditionLock;
@property (nonatomic, retain) NSConditionLock* conditionLock;
//@synthesize conditionLock = _conditionLock;


// error
//NSError* _error;
@property (nonatomic, retain) NSError* error;
//@synthesize error = _error;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLHttpAsyncCall


-(void)start:(NSRunLoop*)runLoop {
    
    [_urlConnection scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [_urlConnection start];
    
    
}


-(void)cancel {
    
    Log_info(@"[NSURLConnection cancel] requested");
    
    [_delegate onResponseCancelled];
    [_urlConnection cancel];
    [_conditionLock lock];
    [_conditionLock unlockWithCondition:COMPLETED];

    
}



#pragma mark NSURLConnection delegate callbacks related to "Connection Authentication"


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
    

    return NO;
}

#pragma mark NSURLConnection delegate callbacks related to "Connection Data and Responses"



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {


    if( ![response isKindOfClass:[NSHTTPURLResponse class]] ) {
        Log_warnFormat( @"![response isKindOfClass:[NSHTTPURLResponse class]]; NSStringFromClass([NSHTTPURLResponse class]) = %@", NSStringFromClass([NSHTTPURLResponse class]));
        return;
    }

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    
    NSDictionary* allHeaderFields = [httpResponse allHeaderFields];
    
    for( NSString* headerName in allHeaderFields ) {
        
        NSString* headerValue = [allHeaderFields valueForKey:headerName];
        
        NSString* lowerHeaderName = [headerName lowercaseString]; // http headers are case insensitive
        [_delegate onResponseHeaderWithName:lowerHeaderName value:headerValue];
    }

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    

    if( !_onResponseEntityStartedCalled ) {
    
        [_delegate onResponseEntityStarted];
        _onResponseEntityStartedCalled = true;
        
    }
    
    [_delegate onResponseBytes:[data bytes] length:[data length]];
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    Log_enteredMethod();

    [_delegate onResponseEntityCompleted];
    
    
    [_conditionLock lock];
    [_conditionLock unlockWithCondition:COMPLETED];


}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    Log_enteredMethod();
    
    [self setError:error];
    [_delegate onResponseError:error];
    
    [_conditionLock lock];
    [_conditionLock unlockWithCondition:COMPLETED];


}

-(void)waitUntilCompleted {

    Log_debug( @"waiting ...");

    @try {
        [_conditionLock lockWhenCondition:COMPLETED];
        [_conditionLock unlock];

        if( nil != _error ) {
            
            NSString* faultString = [NSString stringWithFormat:@"%@ (%@)", [_error localizedDescription], [_error domain]];
            @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultString:faultString];
            
        }

    }
    @finally {
        
        Log_debug( @"completed");
        
    }
    
    
}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithRequest:(NSURLRequest*)request delegate:(id<HLHttpAsyncResponseHandler>)delegate {
    
    HLHttpAsyncCall* answer = [super init];
    
    if( nil != answer ) { 
        
        
        [answer setDelegate:delegate];
        answer->_urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:FALSE];
        answer->_conditionLock = [[NSConditionLock alloc] initWithCondition:PENDING_COMPLETION];

        answer->_onResponseEntityStartedCalled = false;
    }
    

    return answer;
    
}
-(void)dealloc {
    
    
    [self setDelegate:nil];
    [self setUrlConnection:nil];
    
    [self setConditionLock:nil];
    [self setError:nil];
    
    
}

#pragma mark fields


// delegate
//id<HLHttpAsyncResponseHandler> _delegate;
//@property (nonatomic, assign) id<HLHttpAsyncResponseHandler> delegate;
@synthesize delegate = _delegate;


// urlConnection
//NSURLConnection* _urlConnection;
//@property (nonatomic, retain) NSURLConnection* urlConnection;
@synthesize urlConnection = _urlConnection;


// conditionLock
//NSConditionLock* _conditionLock;
//@property (nonatomic, retain) NSConditionLock* conditionLock;
@synthesize conditionLock = _conditionLock;


// error
//NSError* _error;
//@property (nonatomic, retain) NSError* error;
@synthesize error = _error;



@end
