// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "HLHttpAsyncResponseHandler.h"

@interface HLHttpAsyncCall : NSObject {
    

    
    // delegate
    __unsafe_unretained id<HLHttpAsyncResponseHandler> _delegate;
    //@property (nonatomic, assign) id<HLHttpAsyncResponseHandler> delegate;
    //@synthesize delegate = _delegate;
    

    // urlConnection
	NSURLConnection* _urlConnection;
	//@property (nonatomic, retain) NSURLConnection* urlConnection;
	//@synthesize urlConnection = _urlConnection;
    
    // conditionLock
    NSConditionLock* _conditionLock;
	//@property (nonatomic, retain) NSConditionLock* conditionLock;
	//@synthesize conditionLock = _conditionLock;
    
    
    // error
	NSError* _error;
	//@property (nonatomic, retain) NSError* error;
	//@synthesize error = _error;

    
    bool _onResponseEntityStartedCalled;
    
    
}


-(void)start:(NSRunLoop*)runLoop;


-(void)cancel;

-(void)waitUntilCompleted;

#pragma mark -
#pragma mark instance lifecycle 

-(id)initWithRequest:(NSURLRequest*)request delegate:(id<HLHttpAsyncResponseHandler>)delegate;


#pragma mark fields
    



@end
