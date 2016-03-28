// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@interface HLBrokerMessageType : NSObject {
	
	
	NSString* _identifier;
	//@property (nonatomic, retain) NSString* identifier;
	//@synthesize identifier = _identifier;
	
	
}


+(HLBrokerMessageType*)fault;
+(HLBrokerMessageType*)metaRequest;
+(HLBrokerMessageType*)metaResponse;
+(HLBrokerMessageType*)notification;
+(HLBrokerMessageType*)oneway;
+(HLBrokerMessageType*)request;
+(HLBrokerMessageType*)response;

+(HLBrokerMessageType*)lookup:(NSString*)identifier;

#pragma mark -
#pragma mark fields

//NSString* _identifier;
@property (nonatomic, retain) NSString* identifier;
//@synthesize identifier = _identifier;


@end


