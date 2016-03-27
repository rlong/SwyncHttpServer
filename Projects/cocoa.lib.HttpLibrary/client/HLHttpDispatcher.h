// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CANetworkAddress.h"

#import "HLAuthenticator.h"
#import "HLHttpRequestAdapter.h"
#import "HLHttpResponseHandler.h"




@interface HLHttpDispatcher : NSObject {
	
	CANetworkAddress* _networkAddress;
	//@property (nonatomic, retain) NetworkAddress* networkAddress;
	//@synthesize networkAddress = _networkAddress;

	
}



-(void)get:(HLHttpRequestAdapter*)requestAdapter authenticator:(HLAuthenticator*)authenticator responseHandler:(id<HLHttpResponseHandler>)responseHandler;
-(void)get:(HLHttpRequestAdapter*)requestAdapter responseHandler:(id<HLHttpResponseHandler>)responseHandler;

-(void)post:(HLHttpRequestAdapter*)requestAdapter authenticator:(HLAuthenticator*)authenticator responseHandler:(id<HLHttpResponseHandler>)responseHandler;
-(void)post:(HLHttpRequestAdapter*)requestAdapter responseHandler:(id<HLHttpResponseHandler>)responseHandler;


#pragma mark instance lifecycle


-(id)initWithNetworkAddress:(CANetworkAddress*)networkAddress;



#pragma mark fields

//NetworkAddress* _networkAddress;
@property (nonatomic, retain) CANetworkAddress* networkAddress;
//@synthesize networkAddress = _networkAddress;





@end


