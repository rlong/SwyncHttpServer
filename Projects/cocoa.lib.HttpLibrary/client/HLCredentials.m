// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CASecurityUtilities.h"

#import "HLCredentials.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLCredentials () 


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -




@implementation HLCredentials




-(NSString*)ha1 {

	if( nil != _ha1 ) {
		return _ha1;
	}
	
	if( nil == _username ) {
		return nil;
	}
	
	if( nil == _realm ) {
		return nil;
	}
	
	if( nil == _password ) {
		return nil;
	}
	
	NSString* a1 = [NSString stringWithFormat:@"%@:%@:%@", _username, _realm, _password];
	
	_ha1 = [CASecurityUtilities md5HashOfString:a1];
	return _ha1;
	
}

-(void)unsetHa1 {
	if( nil != _ha1 ) {
		_ha1 = nil;
	}
}

-(void)setUsername:(NSString*)username {
	
	[self unsetHa1];
	
	if( nil != _username ) {
	}
	
	_username = username;

	if( nil != _username ) {
	}
	
}

-(void)setRealm:(NSString *)realm {
	[self unsetHa1];
	
	if( nil != _realm ) {
	}
	
	_realm = realm;
	
	if( nil != _realm ) {
	}
}

-(void)setPassword:(NSString *)password {
	[self unsetHa1];
	
	if( nil != _password ) {
	}
	
	_password = password;
	
	if( nil != _password ) {
	}
	
}

#pragma mark instance lifecycle



-(id)initWithUsername:(NSString*)username realm:(NSString*)realm password:(NSString*)password {
	
	HLCredentials* answer = [super init];
	
	[self setUsername:username];
	[self setRealm:realm];
	[self setPassword:password];

	return answer;
	
}

-(id)init {
	
	HLCredentials* answer = [super init];
	
	return answer;
	
}

-(void)dealloc {
	
	if( nil != _username ) {
		_username = nil;
	}

	if( nil != _realm ) {
		_realm = nil;
	}
	
	if( nil != _password ) {
		_password = nil;
	}
	
	if( nil != _ha1 ) {
		_ha1 = nil;
	}
	
}

#pragma mark fields


//NSString* _username;
//@property (nonatomic, retain, setter=setUsername) NSString* username;
@synthesize username = _username;

//NSString* _realm;
//@property (nonatomic, retain, setter=setRealm) NSString* realm;
@synthesize realm = _realm;

//NSString* _password;
//@property (nonatomic, retain, setter=setPassword) NSString* password;
@synthesize password = _password;


//NSString* _ha1;
//@property (nonatomic, readonly, getter=ha1) NSString* ha1;
@synthesize ha1 = _ha1;

@end
