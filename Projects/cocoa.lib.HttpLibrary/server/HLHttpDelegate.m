//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CABaseException.h"
#import "CALog.h"
#import "CAOutputStreamHelper.h"
#import "CAInputStreamHelper.h"
#import "CAStreamHelper.h"


#import "HLAuthRequestHandler.h"
#import "HLHttpDelegate.h"
#import "HLFileGetRequestHandler.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpResponseWriter.h"

#import "HLFileHandle.h"
#import "HLHttpRequest.h"
#import "HLRequestHandler.h"
#import "HLHttpRequestReader.h"
#import "HLHttpStatus.h"
#import "HLHttpStatus_ErrorDomain.h"
#import "HLOpenRequestHandler.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpDelegate () 



// httpProcessor
//id<HttpProcessor> _httpProcessor;
@property (nonatomic, retain) id<HLRequestHandler> httpProcessor;
//@synthesize httpProcessor = _httpProcessor;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



@implementation HLHttpDelegate



-(HLHttpRequest*)readRequest:(NSInputStream*)inputStream {

    HLHttpRequest* answer = nil;
    
    @try {
        
        answer = [HLHttpRequestReader readRequest:inputStream];
        
    }
    @catch (NSException *exception) {
        Log_warnException( exception );
    }
    
    return answer;

    
}


-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    
    @try {
        
        return [_httpProcessor processRequest:request];
    }
    @catch (NSException *exception) {
        
        if( [exception isKindOfClass:[CABaseException class]] ) {
            CABaseException* be = (CABaseException*)exception;
            NSString* errorDomain = [be errorDomain];
            
            if(  [[[HLHttpStatus errorDomain] NOT_FOUND_404] isEqualToString:errorDomain] ) {
                Log_warnFormat( @"errorDomain = '%@'; [be reason] = '%@'", errorDomain, [be reason]);
            } else {
                Log_warnException( exception );
            }
        } else {
            Log_warnException( exception );
        }
        
        return [HLHttpErrorHelper toHttpResponse:exception];
    }
    
}


-(bool)writeResponse:(HLHttpResponse*)response to:(NSOutputStream*)outputStream {
    
    @try {
        // write the response ...
        [HLHttpResponseWriter writeResponse:response outputStream:outputStream];
    }
    @catch (BaseException* exception) {
        
        if( [[CAStreamHelper ERROR_DOMAIN_BROKEN_PIPE] isEqualToString:[exception errorDomain]] ) {
#ifdef DEBUG
            Log_warn( @"broken pipe" );
#else
            // quietly swallow the 'broken pipe'
#endif
        } else {
            Log_warnException( exception );
        }
        return false;
    }
    @catch (NSException *exception) {
        Log_warnException( exception );
        return false;
    }
    
    return true;
    
    
    
}


-(void)logReqest:(HLHttpRequest*)request response:(HLHttpResponse*)response writeResponseSucceded:(bool)writeResponseSucceded{

    int statusCode = [response status];

    NSString* requestUri = [request requestUri];
    
    HLRange* range = [response range];
    
    long long contentLength = 0;
    if( nil != [response entity] ) {
        
        contentLength = [[response entity] getContentLength];
        if( nil != range ) {
            contentLength = [range getContentLength:contentLength];
        }
    }
    
    float timeTaken = -[[request created] timeIntervalSinceNow];
    
    NSString* completed;
    {
        if( writeResponseSucceded ) {
            completed = @"true";
        } else {
            completed = @"false";
        }
    }
    
    NSString* rangeString;
    {
        if( nil == range ) {
            rangeString = @"bytes";
            
        } else {
            rangeString = [range toContentRange:[[response entity] getContentLength]];
        }
    }
    
    NSString* info = [NSString stringWithFormat:@"status:%d uri:%@ content-length:%lld time-taken:%f completed:%@ range:%@",
                      statusCode, requestUri, contentLength, timeTaken, completed, rangeString];
    Log_info( info );

}


#pragma mark - 
#pragma mark <ConnectionDelegate> implementation


-(id<HLConnectionDelegate>)processRequestOnSocket:(HLFileHandle*)socket inputStream:(NSInputStream*)inputStream  outputStream:(NSOutputStream*)outputStream {

    
    // get the request ...
    HLHttpRequest* request = [self readRequest:inputStream];
    
    if( nil == request )  {
        Log_debug(@"nil == request");
        return nil;
    }
    
    // process the request ...
    HLHttpResponse* response = [self processRequest:request];


    id<HLConnectionDelegate> answer = self;
    
    if( nil != [response connectionDelegate] ) {
        answer = [response connectionDelegate];
    }
    
    // vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
    if( [request isCloseConnectionIndicated] ) {
        answer = nil;
    }
    // ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
    
    uint32_t statusCode = [response status];
    if( statusCode > 399 ) {
        answer = nil;
    }
    
    if( self == answer ) {
        [response putHeader:@"Connection" value:@"keep-alive"];
    } else if( nil == answer ){
        [response putHeader:@"Connection" value:@"close"];
    }

    // write the response ...
    bool writeResponseSucceded = [self writeResponse:response to:outputStream];

    // do some logging ...
    [self logReqest:request response:response writeResponseSucceded:writeResponseSucceded];

    
    if( !writeResponseSucceded ) {
        answer = nil;
    }
    
    // if the processing completed, we will permit more requests on this socket
    return answer;

}



#pragma mark -
#pragma mark instance setup/teardown


-(id)initWithRequestHandler:(id<HLRequestHandler>)httpProcessor {
    
    HLHttpDelegate* answer = [super init];
    
    if( nil != answer ) { 
        
        
        [answer setHttpProcessor:httpProcessor];
    }

    
    return answer;
    
}

-(void)dealloc{ 
	
	
    [self setHttpProcessor:nil];

}

#pragma mark fields




// httpProcessor
//id<HttpProcessor> _httpProcessor;
//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
@synthesize httpProcessor = _httpProcessor;



@end
