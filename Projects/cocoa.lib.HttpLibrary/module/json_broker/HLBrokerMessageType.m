// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"

#import "HLBrokerMessageType.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLBrokerMessageType () 

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithIdentifer:(NSString*)identifer;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLBrokerMessageType


static HLBrokerMessageType* _fault = nil; 

static HLBrokerMessageType* _metaRequest = nil;

static HLBrokerMessageType* _metaResponse = nil;

static HLBrokerMessageType* _notification = nil;

static HLBrokerMessageType* _oneway = nil; 

static HLBrokerMessageType* _request = nil; 

static HLBrokerMessageType* _response = nil; 



+(void)initialize {
	
	_fault = [[HLBrokerMessageType alloc] initWithIdentifer:@"fault"];
    _metaRequest = [[HLBrokerMessageType alloc] initWithIdentifer:@"meta-request"];
    _metaResponse = [[HLBrokerMessageType alloc] initWithIdentifer:@"meta-response"];
	_notification = [[HLBrokerMessageType alloc] initWithIdentifer:@"notification"];	
	_oneway = [[HLBrokerMessageType alloc] initWithIdentifer:@"oneway"];
	_request = [[HLBrokerMessageType alloc] initWithIdentifer:@"request"];
	_response = [[HLBrokerMessageType alloc] initWithIdentifer:@"response"];
	
}




+(HLBrokerMessageType*)fault {
	return _fault;
}

+(HLBrokerMessageType*)metaRequest {
	return _metaRequest;
}

+(HLBrokerMessageType*)metaResponse {
	return _metaResponse;
}

+(HLBrokerMessageType*)notification {
	return _notification;
}

+(HLBrokerMessageType*)oneway {
	return _oneway;
}

+(HLBrokerMessageType*)request {
	return _request;
}


+(HLBrokerMessageType*)response {
	return _response;
}

+(HLBrokerMessageType*)lookup:(NSString*)identifier {
	
	if( [[_fault identifier] isEqualToString:identifier] ) {
		return _fault;
	}

    if( [[_metaRequest identifier] isEqualToString:identifier] ) {
		return _metaRequest;
	}

    if( [[_metaResponse identifier] isEqualToString:identifier] ) {
		return _metaResponse;
	}

	if( [[_notification identifier] isEqualToString:identifier] ) {
		return _notification;
	}
	
	if( [[_oneway identifier] isEqualToString:identifier] ) {
		return _oneway;
	}
	
	if( [[_request identifier] isEqualToString:identifier] ) {
		return _request;
	}

	if( [[_response identifier] isEqualToString:identifier] ) {
		return _response;
	}
	
	NSString*  technicalError = [NSString stringWithFormat:@"unexpected identifier; identifier =  '%@'", identifier];
	BaseException* e = [[BaseException alloc] initWithOriginator:[HLBrokerMessageType class] line:__LINE__ faultMessage:technicalError];
	
	@throw e;
	
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithIdentifer:(NSString*)identifer {
	
	HLBrokerMessageType* answer = [super init];
	
	[answer setIdentifier:identifer];
	
	return answer;
	
}


#pragma mark -
#pragma mark fields


//NSString* _identifier;
//@property (nonatomic, retain) NSString* identifier;
@synthesize identifier = _identifier;


@end
