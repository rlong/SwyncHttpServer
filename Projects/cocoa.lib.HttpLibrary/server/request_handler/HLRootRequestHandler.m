//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "HLHttpErrorHelper.h"
#import "HLRootRequestHandler.h"
#import "HLHttpRequest.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLRootRequestHandler () 

// httpProcessors
//NSMutableArray* _httpProcessors;
@property (nonatomic, retain) NSMutableArray* httpProcessors;
//@synthesize httpProcessors = _httpProcessors;


// defaultProcessor
//id<HttpProcessor> _defaultProcessor;
@property (nonatomic, retain) id<HLRequestHandler> defaultProcessor;
//@synthesize defaultProcessor = _defaultProcessor;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLRootRequestHandler



-(void)addRequestHandler:(id<HLRequestHandler>)httpProcessor {
    
    Log_debugString( [httpProcessor getProcessorUri] );
    
    [_httpProcessors addObject:httpProcessor];
    
    
}

#pragma mark <HLRequestHandler> implementation


-(NSString*)getProcessorUri {
    return @"/";
}

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    NSString* requestUri = [request requestUri];
    for( id<HLRequestHandler> httpProcessor in _httpProcessors ) { 
        
        NSString* processorUri = [httpProcessor getProcessorUri];
        if( 0 == [requestUri rangeOfString:processorUri].location ) {
            return [httpProcessor processRequest:request];
        }
    }
    
    if( nil != _defaultProcessor ) { 
        return [_defaultProcessor processRequest:request];
    }
    
    Log_errorFormat( @"bad requestUri; requestUri = '%@'" , requestUri );
    @throw [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
}


#pragma mark instance lifecycle 

-(id)init { 
    
    HLRootRequestHandler* answer = [super init];
    
    if( nil != answer ) { 
        answer->_httpProcessors = [[NSMutableArray alloc] init];
        [answer setDefaultProcessor:nil]; // just to be explicit
    }
    
    return answer;
    
}


-(id)initWithDefaultProcessor:(id<HLRequestHandler>)defaultProcessor { 
    
    HLRootRequestHandler* answer = [super init];
    
    if( nil != answer ) { 
        answer->_httpProcessors = [[NSMutableArray alloc] init];
        [answer setDefaultProcessor:defaultProcessor];
    }
    
    return answer;

}

-(void)dealloc {
    
    [self setHttpProcessors:nil];
    [self setDefaultProcessor:nil];
    
}

#pragma mark fields

// httpProcessors
//NSMutableArray* _httpProcessors;
//@property (nonatomic, retain) NSMutableArray* httpProcessors;
@synthesize httpProcessors = _httpProcessors;

// defaultProcessor
//id<HttpProcessor> _defaultProcessor;
//@property (nonatomic, retain) id<HttpProcessor> defaultProcessor;
@synthesize defaultProcessor = _defaultProcessor;



@end
