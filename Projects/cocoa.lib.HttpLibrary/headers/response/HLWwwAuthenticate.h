// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLHttpHeader.h"

// see section 3.2.1 of RFC-2617
@interface HLWwwAuthenticate : NSObject <HLHttpHeader> {

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
	

}

-(NSString*)toString;

+(HLWwwAuthenticate*)buildFromString:(NSString*)challenge;

#pragma mark fields

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



@end
