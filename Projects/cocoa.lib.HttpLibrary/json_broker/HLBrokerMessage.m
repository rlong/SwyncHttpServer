// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CAJsonArray.h"
#import "CAJsonArrayHandler.h"
#import "CAJsonObject.h"
#import "CAJsonStringOutput.h"

#import "HLBrokerMessage.h"
#import "HLBrokerMessageType.h"
#import "HLFaultSerializer.h"

@implementation HLBrokerMessage


+(HLBrokerMessage*)buildRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName {

    HLBrokerMessage* answer = [[HLBrokerMessage alloc] init];
    
    [answer setMessageType:[HLBrokerMessageType request]];
    
    // metaInformation is setup in the init
    [answer setServiceName:serviceName];
    [answer setMethodName:methodName];
    
    return answer;

}

+(HLBrokerMessage*)buildMetaRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName {
    
    HLBrokerMessage* answer = [[HLBrokerMessage alloc] init];
    
    [answer setMessageType:[HLBrokerMessageType metaRequest]];
    
    // metaInformation is setup in the init
    [answer setServiceName:serviceName];
    [answer setMethodName:methodName];
    
    return answer;
    
}

+(HLBrokerMessage*)buildFault:(HLBrokerMessage*)request exception:(NSException*)exception {

    HLBrokerMessage* answer = [[HLBrokerMessage alloc] init];

    [answer setMessageType:[HLBrokerMessageType fault]];
    [answer setMetaData:[request metaData]];

    // metaInformation is setup in the init
    [answer setServiceName:[request serviceName]];
    [answer setMethodName:[request methodName]];
    [answer setAssociativeParamaters:[HLFaultSerializer toJSONObject:exception]];
    // parameters are set in the init 
    
    
    return answer;

}

+(HLBrokerMessage*)buildMetaResponse:(HLBrokerMessage*)request {
	
	HLBrokerMessage* answer = [[HLBrokerMessage alloc] init];
	
	[answer setMessageType:[HLBrokerMessageType metaResponse]];
    [answer setMetaData:[request metaData]];
	[answer setServiceName:[request serviceName]];
	[answer setMethodName:[request methodName]];
	
    
	return answer;
	
}

+(HLBrokerMessage*)buildResponse:(HLBrokerMessage*)request {
	
	HLBrokerMessage* answer = [[HLBrokerMessage alloc] init];
	
	[answer setMessageType:[HLBrokerMessageType response]];
    [answer setMetaData:[request metaData]];
	[answer setServiceName:[request serviceName]];
	[answer setMethodName:[request methodName]];
	
	 
	return answer;
	
}

-(bool)hasOrderedParamaters {
    if( nil != _orderedParamaters ) {
        return false;
    }
    return true;

}

-(CAJsonArray*)orderedParamaters {
    if( nil != _orderedParamaters ) {
        return _orderedParamaters;
    }
    
    _orderedParamaters = [[CAJsonArray alloc] init];
    return _orderedParamaters;
    
}



-(NSString*)toString {
    
    NSString* answer;
    
    
    
    CAJsonStringOutput* writer = [[CAJsonStringOutput alloc] init];
    {
        CAJsonArray* messageComponents = [self toJsonArray];
        
        
        CAJsonArrayHandler* jsonArrayHandler = [CAJsonArrayHandler getInstance];
        [jsonArrayHandler writeValue:messageComponents writer:writer];
        
        answer = [writer toString];
        
    }
    
    return answer;

    
}

-(NSData*)toData;
{
    
    CAJsonArray* jsonArray = [self toJsonArray];
    
    NSJSONWritingOptions options = 0;
    NSError *error = nil;
    
    NSData* answer = [NSJSONSerialization dataWithJSONObject:[jsonArray values] options:options error:&error];
    if( nil != error ) {
        
        @throw exceptionWithMethodNameAndError(@"[NSJSONSerialization JSONObjectWithData:options:error:]", error);
    }
    
    return answer;
}


-(CAJsonArray*)toJsonArray {
    
    CAJsonArray* answer = [[CAJsonArray alloc] initWithCapacity:8];
    
    [answer add:[_messageType identifier]];
    [answer add:_metaData];
    [answer add:_serviceName];
    [answer addInteger:1]; // majorVersion
    [answer addInteger:0]; // minorVersion
    [answer add:_methodName];
    [answer add:_associativeParamaters];
    
    if( nil != _orderedParamaters ) {
        
        [answer add:_orderedParamaters];
    }
    
    return answer;
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
	
	
	HLBrokerMessage* answer = [super init];

	
	answer->_metaData = [[CAJsonObject alloc] init];
	answer->_associativeParamaters = [[CAJsonObject alloc] init];
	answer->_orderedParamaters = nil;
	
	
	return answer;
	 
}



-(id)initWithValues:(CAJsonArray*)values {
	
	HLBrokerMessage* answer = [self init];	
	
	NSString* messageTypeIdentifer = [values getString:0];
	
	[answer setMessageType:[HLBrokerMessageType lookup:messageTypeIdentifer]];
	[answer setMetaData:[values jsonObjectAtIndex:1]];
	[answer setServiceName:[values getString:2]];
    
	[answer setMethodName:[values getString:5]];

    [answer setAssociativeParamaters:[values objectAtIndex:6]];

    if( 8 == [values count] ) {
        
        [answer setOrderedParamaters:[values jsonArrayAtIndex:7]];
    }
    
	return answer;
}



-(void)dealloc {
	
	
	[self setMessageType:nil];
	[self setMetaData:nil];
	[self setServiceName:nil];
	[self setMethodName:nil];
	[self setAssociativeParamaters:nil];
	[self setOrderedParamaters:nil];
	
	
}

#pragma mark -
#pragma mark fields


//BrokerMessageType* _messageType;
//@property (nonatomic, retain) BrokerMessageType* messageType;
@synthesize messageType = _messageType;

//JsonObject* _metaData;
//@property (nonatomic, retain) JsonObject* metaData;
@synthesize metaData = _metaData;


//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;

//NSString* _methodName;
//@property (nonatomic, retain) NSString* methodName;
@synthesize methodName = _methodName;


//JSONObject* _associativeParamaters;
//@property (nonatomic, retain) JSONObject* associativeParamaters;
@synthesize associativeParamaters = _associativeParamaters;


// orderedParamaters
//CAJsonArray* _orderedParamaters;
//@property (nonatomic, retain, getter=orderedParamaters) CAJsonArray* orderedParamaters;
@synthesize orderedParamaters = _orderedParamaters;



@end
