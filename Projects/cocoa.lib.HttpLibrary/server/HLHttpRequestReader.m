//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CAInputStreamHelper.h"
#import "CANumericUtilities.h"
#import "CAStringHelper.h"


#import "HLDataEntity.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpRequestReader.h"
#import "HLStreamEntity.h"



#define LINE_LENGTH_UPPER_BOUND 512
#define NUMBER_HEADERS_UPPER_BOUND 32

@implementation HLHttpRequestReader

static bool INVALID_CHARS[256];


+(void)initialize {
    
    // valid chars are 'cr', 'nl', and all the chars between 'space' and '~' 
    for( int i = 0; i < 256; i++ ) {
        INVALID_CHARS[i] = true;
    }
    
    INVALID_CHARS[0x0d] = false; // 0x0d = 'cr'
    INVALID_CHARS[0x0a] = false; // 0x0a = 'nl'
    
    for( int i = 0x20; i <= 0x7e; i++ ) { // 0x20 = 'space'; 0x7e = '~'
        INVALID_CHARS[i] = false;
    }
    
}

+(void)setOperationDetailsForRequest:(HLHttpRequest*)request withLine:(NSString*)line {
	
	
	NSScanner* scanner = [NSScanner scannerWithString:line];
	
	/*
	 * HTTP method ... 
	 */
	NSString* method = nil;

	if( ![scanner scanUpToString:@" " intoString:&method] ) {

        Log_errorFormat( @"![scanner scanUpToString:@\" \" intoString:&method]; line = '%@'", line);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
	}
    
    if( [[[HLHttpMethod GET] name] isEqualToString:method] ) {
        
        [request setMethod:[HLHttpMethod GET]];
        
    } else if( [[[HLHttpMethod POST] name] isEqualToString:method] ) {
        
        [request setMethod:[HLHttpMethod POST]];
        
    } else if( [[[HLHttpMethod OPTIONS] name] isEqualToString:method] ) {
        
        [request setMethod:[HLHttpMethod OPTIONS]];
        
    } else {
        
        Log_errorFormat( @"unknown HTTP method; method = '%@'; line = '%@'", method, line);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
	
	/*
	 * HTTP request-uri ... 
	 */
	NSString* requestUri = nil; 
	if( ![scanner scanUpToString:@" " intoString:&requestUri] ) { 

        Log_errorFormat( @"![scanner scanUpToString:@\" \" intoString:&requestUri]; line = '%@'", line );
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];        
    }
    

	[request setRequestUri:requestUri];
	
}


+(NSString*)readLine:(NSInputStream*)inputStream buffer:(NSMutableData*)buffer { 
    
    UInt8 b;
    long bytesRead = [inputStream read:&b maxLength:1];

    // connection closed (or something else ?)
    if( 1 != bytesRead ) {
        
        Log_debugInt( [inputStream streamStatus] );
        Log_debugError( [inputStream streamError] );
        return nil;
    }
    
    int i = 0;
    
    do {
        if( 0 != bytesRead ) { 
            if( INVALID_CHARS[b] ) { // unexpected character
                
                Log_errorFormat( @"INVALID_CHARS[b]; b = 0x%x", b);
                @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
            }
        }
        
        // end of stream or end of the line
        if( 0 == b || '\n' == b ) { 
            NSString* answer = [CAStringHelper getUtf8String:buffer];
            return answer;
        }
        
        // filter out '\r'
        if( '\r' != b ) { 
            [buffer appendBytes:&b length:1];            
        }
        
        bytesRead = [inputStream read:&b maxLength:1];
        
        i++;
        
    } while( i < LINE_LENGTH_UPPER_BOUND );
    
    // line is too long
    Log_errorFormat( @"line too long; i = %d", i);
    @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    
}


+(void)addHeader:(NSString*)header toRequest:(HLHttpRequest*)request {
    
	NSString* name; 
	NSString* value;
	
	NSScanner *scanner = [NSScanner scannerWithString:header];
	if( ! [scanner scanUpToString:@": " intoString:&name] ) {
        
        Log_errorFormat( @"! [scanner scanUpToString:@\": \" intoString:&name]; header = '%@'", header);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
	}
    
    
	name = [name lowercaseString]; // headers are case insensitive
    
	// scan over the ": " ... 
	[scanner scanString:@": " intoString:nil];
    
    NSUInteger scanLocation = [scanner scanLocation];
	if( scanLocation >= [header length] ) { // make sure there is a value to be extracted

        Log_errorFormat( @"scanLocation >= [header length]; scanLocation = %ld; header = '%@'", scanLocation, header);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
	}
	value = [header substringFromIndex:scanLocation];

    if( Log_isDebugEnabled() ) { 
        if( [@"authorization" isEqualToString:name] ) { 
            Log_debugString( value );
        }
    }
	
    [request setHttpHeader:name headerValue:value];
	
}


+(HLHttpRequest*)readRequest:(NSInputStream*)inputStream { 
    
    NSMutableData* buffer = [[NSMutableData alloc] init];
    
    NSString* firstLine = [self readLine:inputStream buffer:buffer];
    
    // null corresponds to the end of a stream
    if( nil == firstLine ) {
        return nil;
    }
    
    HLHttpRequest* answer = [[HLHttpRequest alloc] init];
    
    [self setOperationDetailsForRequest:answer withLine:firstLine];
    
    int i = 0;
    do {
        
        [buffer setLength:0]; // reset
        NSString* line = [self readLine:inputStream buffer:buffer];

        if( 0 == [line length] ) {
            break;
        } else {
            [self addHeader:line toRequest:answer];
        }
        
        i++;
        
        
    } while( i < NUMBER_HEADERS_UPPER_BOUND );
    
    if( i > NUMBER_HEADERS_UPPER_BOUND ) {

        Log_errorFormat( @"i > NUMBER_HEADERS_UPPER_BOUND; i = %d", i);
        @throw [HLHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    
    
    }
    
    
    NSString* contentLengthString = [answer getHttpHeader:@"content-length"];
    
    
    // no body ? 
    if( nil == contentLengthString ) { 

        return answer;
    }
    
    long contentLength = [CANumericUtilities parseLong:contentLengthString];
    
    
    HLStreamEntity* entity = [[HLStreamEntity alloc] initWithContent:inputStream contentLength:contentLength];
    {
        [answer setEntity:entity];
    }
    
    return answer;
}



@end
