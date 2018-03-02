// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@class HLBrokerMessageType;
@class CAJsonArray;
@class CAJsonObject;

@interface HLBrokerMessage : NSObject {
	
	HLBrokerMessageType* _messageType;
	//@property (nonatomic, retain) BrokerMessageType* messageType;
	//@synthesize messageType = _messageType;
	
	CAJsonObject* _metaData;
	//@property (nonatomic, retain) JsonObject* metaData;
	//@synthesize metaData = _metaData;
	
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;
	
	NSString* _methodName;
	//@property (nonatomic, retain) NSString* methodName;
	//@synthesize methodName = _methodName;
	
	CAJsonObject* _associativeParamaters;
	//@property (nonatomic, retain) JSONObject* associativeParamaters;
	//@synthesize associativeParamaters = _associativeParamaters;
	
    // orderedParamaters
    CAJsonArray* _orderedParamaters;
    //@property (nonatomic, retain, getter=orderedParamaters) CAJsonArray* orderedParamaters;
    //@synthesize orderedParamaters = _orderedParamaters;
    
	
	

}


+(HLBrokerMessage*)buildRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName;
+(HLBrokerMessage*)buildMetaRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName;

+(HLBrokerMessage*)buildFault:(HLBrokerMessage*)request exception:(NSException*)exception;

+(HLBrokerMessage*)buildMetaResponse:(HLBrokerMessage*)request;
+(HLBrokerMessage*)buildResponse:(HLBrokerMessage*)request;

-(bool)hasOrderedParamaters;

//-(void)addJSONObjectParameter:(CAJsonObject*)parameter;

-(CAJsonArray*)toJsonArray;

-(NSString*)toString;
-(NSData*)toData;

#pragma mark -
#pragma mark instance lifecycle 


-(id)initWithValues:(CAJsonArray*)values;
	
#pragma mark -
#pragma mark fields

//BrokerMessageType* _messageType;
@property (nonatomic, retain) HLBrokerMessageType* messageType;
//@synthesize messageType = _messageType;

//JsonObject* _metaData;
@property (nonatomic, retain) CAJsonObject* metaData;
//@synthesize metaData = _metaData;


//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;

//NSString* _methodName;
@property (nonatomic, retain) NSString* methodName;
//@synthesize methodName = _methodName;


//JSONObject* _associativeParamaters;
@property (nonatomic, retain) CAJsonObject* associativeParamaters;
//@synthesize associativeParamaters = _associativeParamaters;

// orderedParamaters
//CAJsonArray* _orderedParamaters;
@property (nonatomic, retain, getter=orderedParamaters) CAJsonArray* orderedParamaters;
//@synthesize orderedParamaters = _orderedParamaters;

@end
