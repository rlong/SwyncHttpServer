// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLHttpHeader.h"

// see section 3.2.2 of RFC-2617
@interface HLAuthorization : NSObject <HLHttpHeader> {

	NSString* _cnonce;
	//@property (nonatomic, retain) NSString* cnonce;
	//@synthesize cnonce = _cnonce;
		
	UInt32 _nc;
	//@property (nonatomic) UInt32 nc;
	//@synthesize nc = _nc;
	
	
	NSString* _nonce;
	//@property (nonatomic, retain) NSString* nonce;
	//@synthesize nonce = _nonce;
	
	NSString* _opaque;
	//@property (nonatomic, retain) NSString* opaque;
	//@synthesize opaque = _opaque;
	
	NSString* _qop;
	//@property (nonatomic, retain) NSString* qop;
	//@synthesize qop = _qop;
	

	NSString* _realm;
	//@property (nonatomic, retain) NSString* realm;
	//@synthesize realm = _realm;

	NSString* _response;
	//@property (nonatomic, retain) NSString* response;
	//@synthesize response = _response;
	
	
	NSString* _uri;
	//@property (nonatomic, retain) NSString* uri;
	//@synthesize uri = _uri;
	
	NSString* _username;
	//@property (nonatomic, retain) NSString* username;
	//@synthesize username = _username;
	
}

+(HLAuthorization*)buildFromString:(NSString*)credentials;

-(NSString*)toString;


#pragma mark fields

//NSString* _cnonce;
@property (nonatomic, retain) NSString* cnonce;
//@synthesize cnonce = _cnonce;

//UInt32 _nc;
@property (nonatomic) UInt32 nc;
//@synthesize nc = _nc;

//NSString* _nonce;
@property (nonatomic, retain) NSString* nonce;
//@synthesize nonce = _nonce;

//NSString* _opaque;
@property (nonatomic, retain) NSString* opaque;
//@synthesize opaque = _opaque;

//NSString* _qop;
@property (nonatomic, retain) NSString* qop;
//@synthesize qop = _qop;

//NSString* _realm;
@property (nonatomic, retain) NSString* realm;
//@synthesize realm = _realm;

//NSString* _response;
@property (nonatomic, retain) NSString* response;
//@synthesize response = _response;


//NSString* _uri;
@property (nonatomic, retain) NSString* uri;
//@synthesize uri = _uri;


//NSString* _username;
@property (nonatomic, retain) NSString* username;
//@synthesize username = _username;


@end
