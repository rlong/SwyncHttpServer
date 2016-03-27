// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@interface HLHttpCall : NSObject <NSURLConnectionDelegate> {
    
    
    // started
	NSDate* _started;
	//@property (nonatomic, retain) NSDate* started;
	//@synthesize started = _started;
    
	// url
	NSString* _url;
	//@property (nonatomic, retain) NSString* url;
	//@synthesize url = _url;

    
    // conditionLock
    NSConditionLock* _conditionLock;
	//@property (nonatomic, retain) NSConditionLock* conditionLock;
	//@synthesize conditionLock = _conditionLock;
    
	// urlConnection
	NSURLConnection* _urlConnection;
	//@property (nonatomic, retain) NSURLConnection* urlConnection;
	//@synthesize urlConnection = _urlConnection;
    
    // request
	NSURLRequest* _request;
	//@property (nonatomic, retain) NSURLRequest* request;
	//@synthesize request = _request;

    // response
	NSURLResponse* _response;
	//@property (nonatomic, retain) NSURLResponse* response;
	//@synthesize response = _response;

    
	// responseData
	NSMutableData* _responseData;
	//@property (nonatomic, retain) NSMutableData* responseData;
	//@synthesize responseData = _responseData;
    
    // error
	NSError* _error;
	//@property (nonatomic, retain) NSError* error;
	//@synthesize error = _error;


    
}


-(void)start:(NSRunLoop*)runLoop;


-(void)waitUntilCompleted;

#pragma mark instance lifecycle 

-(id)initWithRequest:(NSURLRequest*)request;


#pragma mark fields
    

// response
//NSURLResponse* _response;
@property (nonatomic, retain) NSURLResponse* response;
//@synthesize response = _response;

// responseData
//NSMutableData* _responseData;
@property (nonatomic, retain) NSMutableData* responseData;
//@synthesize responseData = _responseData;


// error
//NSError* _error;
@property (nonatomic, retain) NSError* error;
//@synthesize error = _error;



@end
