// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "HLBrokerMessageResponseHandler.h"
#import "HLHttpDispatcher.h"
#import "HLService.h"

@interface HLServiceHttpProxy : NSObject <HLService> {
    
    // httpDispatcher
	HLHttpDispatcher* _httpDispatcher;
	//@property (nonatomic, retain) HttpDispatcher* httpDispatcher;
	//@synthesize httpDispatcher = _httpDispatcher;
    
    // authenticator
	HLAuthenticator* _authenticator;
	//@property (nonatomic, retain) Authenticator* authenticator;
	//@synthesize authenticator = _authenticator;

    // responseHandler
	HLBrokerMessageResponseHandler* _responseHandler;
	//@property (nonatomic, retain) BrokerMessageResponseHandler* responseHandler;
	//@synthesize responseHandler = _responseHandler;


}

// can return nil
-(NSString*)realm;


#pragma mark instance lifecycle

-(id)initWithHttpDispatcher:(HLHttpDispatcher*)httpDispatcher;

-(id)initWithHttpDispatcher:(HLHttpDispatcher*)httpDispatcher authenticator:(HLAuthenticator*)authenticator;

#pragma mark fields


// authenticator
//Authenticator* _authenticator;
@property (nonatomic, retain) HLAuthenticator* authenticator;
//@synthesize authenticator = _authenticator;


@end
