//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CADataHelper.h"
#import "CAInputStreamHelper.h"
#import "CALog.h"
#import "CAOutputStreamHelper.h"
#import "CAStreamHelper.h"



#import "HLDataEntity.h"
#import "HLHttpResponse.h"
#import "HLHttpResponseWriter.h"
#import "HLHttpStatus.h"




@implementation HLHttpResponseWriter





+(void)tryWriteResponse:(HLHttpResponse*)response outputStream:(NSOutputStream*)outputStream {
    
    
    int statusCode = [response status];
    NSString* statusString = [HLHttpStatus getReason:statusCode];
    
    NSMutableString* statusLineAndHeaders = [NSMutableString stringWithFormat:@"HTTP/1.1 %d %@\r\n", statusCode, statusString];
    
    
    NSDictionary* headers = [response headers];
	for( NSString* key in headers ) {
        
		NSString* value = [headers objectForKey:key];
		[statusLineAndHeaders appendFormat:@"%@: %@\r\n", key, value];
	}

    
    id<HLEntity> entity = [response entity];

    
    ////////////////////////////////////////////////////////////////////////
    // no entity 
    
    if( nil == entity ) { 
        
        if( 101 == statusCode ) {
            
            // 'Switching Protocols'
            [statusLineAndHeaders appendString:@"\r\n"];
            
        } else {
            
            if( 204 == statusCode ) {
                
                // from ...
                // http://stackoverflow.com/questions/912863/is-an-http-application-that-sends-a-content-length-or-transfer-encoding-with-a-2
                // ... it would 'appear' safest to not include 'Content-Length' on a 204
                
            } else if( 304 == statusCode ) {
                
                // http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.3.5
                // http://www.w3.org/Protocols/rfc2616/rfc2616-sec4.html#sec4.3
                
            } else {
                Log_warnFormat( @"nil == entity; statusCode = %d", statusCode );
                [statusLineAndHeaders appendString:@"Content-Length: 0\r\n"];
            }
            [statusLineAndHeaders appendString:@"Accept-Ranges: bytes\r\n\r\n"];
        }
        
        NSData* data = [CADataHelper getUtf8Data:statusLineAndHeaders];
        long maxLength = [statusLineAndHeaders lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        [outputStream write:[data bytes] maxLength:maxLength];
        
        return; // our work is done
        
    }
    
    ////////////////////////////////////////////////////////////////////////
    // has entity 

    unsigned long long entityContentLength = [entity getContentLength];
    unsigned long long seekPosition = 0;
    unsigned long long amountToWrite = entityContentLength;
    
    ////////////////////////////////////////////////////////////////////////
    // headers relevant to range support
    HLRange* range = [response range];
    
    if( nil == range ) {
        
        [statusLineAndHeaders appendString:@"Accept-Ranges: bytes\r\n"];
        
        if( HttpStatus_PARTIAL_CONTENT_206 == statusCode ) {
            Log_warn( @"nil == range && HttpStatus_PARTIAL_CONTENT_206 == statusCode" );
        }
    } else {
        
        NSString* contentRangeHeader = [NSString stringWithFormat:@"Content-Range: %@\r\n", [range toContentRange:entityContentLength]];
        [statusLineAndHeaders appendString:contentRangeHeader];
        
        amountToWrite = [range getContentLength:entityContentLength];
        seekPosition = [range getSeekPosition:entityContentLength];
        
        if( HttpStatus_PARTIAL_CONTENT_206 != statusCode ) {
            Log_warn( @"nil != range && HttpStatus_PARTIAL_CONTENT_206 != statusCode" );
        }
    }
    
    ////////////////////////////////////////////////////////////////////////
    // content-length and final newline
    [statusLineAndHeaders appendFormat:@"Content-Length: %llu\r\n\r\n", amountToWrite];
    
    ////////////////////////////////////////////////////////////////////////
    // write the headers
    
    NSData* headersUtf8Data = [CADataHelper getUtf8Data:statusLineAndHeaders];
    long maxLength = [statusLineAndHeaders lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [outputStream write:[headersUtf8Data bytes] maxLength:maxLength];


    ////////////////////////////////////////////////////////////////////////
    // write the entity

    [entity writeTo:outputStream offset:seekPosition length:amountToWrite];

}


+(void)writeResponse:(HLHttpResponse*)response outputStream:(NSOutputStream*)outputStream {

    
    @try {
        
        [self tryWriteResponse:response outputStream:outputStream ];
        
    }
    @finally {
        
        
        id<HLEntity> entity = [response entity];
        if( nil != entity ) {
            [entity teardownForCaller:self swallowErrors:false];

        }
    }
}

@end
