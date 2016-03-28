//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#include <arpa/inet.h> 


@class HLRequestHandler;

@interface HLWebServer : NSObject {

	int _port;
    
	int _serverSocketFileDescriptor;
    
	socklen_t length;
    
	struct sockaddr_in cli_addr; 
    
    // httpProcessor
	id<HLRequestHandler> _httpProcessor;
	//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
	//@synthesize httpProcessor = _httpProcessor;
    
    
	
}


-(void)start;
-(void)stop;

#pragma mark instance lifecycle

-(id)initWithPort:(int)port httpProcessor:(id<HLRequestHandler>)httpProcessor;
-(id)initWithHttpProcessor:(id<HLRequestHandler>)httpProcessor;


@end

