//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "CAJob.h"

#import "HLJavascriptCallbackAdapter.h"
#import "HLService.h"

@interface HLBrokerJob : NSObject <CAJob> {

    //private Data _jsonRequestData;
    NSData* _jsonRequestData;
    //@property (nonatomic, retain) NSData* jsonRequestData;
    //@synthesize jsonRequestData = _jsonRequestData;
    
    //private String _jsonRequestString;
    NSString* _jsonRequestString;
    //@property (nonatomic, retain) NSString* jsonRequestString;
    //@synthesize jsonRequestString = _jsonRequestString;

    
    // servicesRegistery
	id<HLService> _service;
	//@property (nonatomic, retain) id<Service> servicesRegistery;
	//@synthesize servicesRegistery = _servicesRegistery;

    //private CallbackAdapter _callbackAdapter;
    id<HLJavascriptCallbackAdapter> _callbackAdapter;
    //@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
    //@synthesize callbackAdapter = _callbackAdapter;
    

}


+(NSString*)JSON_BROKER_SCHEME;


#pragma mark instance lifecycle

// 'transientServices' can be nil
-(id)initWithJsonRequestString:(NSString*)jsonRequest service:(id<HLService>)service callbackAdapter:(id<HLJavascriptCallbackAdapter>)callbackAdapter;

// 'transientServices' can be nil
-(id)initWithJsonRequestData:(NSData*)jsonRequest service:(id<HLService>)service callbackAdapter:(id<HLJavascriptCallbackAdapter>)callbackAdapter;


#pragma mark fields

//private CallbackAdapter _callbackAdapter;
//id<CallbackAdapter> _callbackAdapter;
@property (nonatomic, retain) id<HLJavascriptCallbackAdapter> callbackAdapter;
//@synthesize callbackAdapter = _callbackAdapter;




@end
