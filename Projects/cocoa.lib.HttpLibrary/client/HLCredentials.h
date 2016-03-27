// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@interface HLCredentials : NSObject {

	NSString* _username;
	//@property (nonatomic, retain, setter=setUsername) NSString* username;
	//@synthesize username = _username;
	
	NSString* _realm;
	//@property (nonatomic, retain, setter=setRealm) NSString* realm;
	//@synthesize realm = _realm;
	
	NSString* _password;
	//@property (nonatomic, retain, setter=setPassword) NSString* password;
	//@synthesize password = _password;

	NSString* _ha1;
	//@property (nonatomic, readonly, getter=ha1) NSString* ha1;
	//@synthesize ha1 = _ha1;
	
	
}


#pragma mark instance lifecycle

	

-(id)initWithUsername:(NSString*)username realm:(NSString*)realm password:(NSString*)password;


#pragma mark fields

//NSString* _username;
@property (nonatomic, retain, setter=setUsername:) NSString* username;
//@synthesize username = _username;

//NSString* _realm;
@property (nonatomic, retain, setter=setRealm:) NSString* realm;
//@synthesize realm = _realm;

//NSString* _password;
@property (nonatomic, retain, setter=setPassword:) NSString* password;
//@synthesize password = _password;

//NSString* _ha1;
@property (nonatomic, readonly, getter=ha1) NSString* ha1;
//@synthesize ha1 = _ha1;


@end
