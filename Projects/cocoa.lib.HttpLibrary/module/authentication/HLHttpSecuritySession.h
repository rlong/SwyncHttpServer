//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "HLAuthenticationInfo.h"
#import "HLWwwAuthenticate.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLSubject.h"


@interface HLHttpSecuritySession : NSObject {

    
	// usersRealm
	NSString* _usersRealm;
	//@property (nonatomic, retain) NSString* usersRealm;
	//@synthesize usersRealm = _usersRealm;

	
	NSString* _cnonce;
	//@property (nonatomic, retain) NSString* cnonce;
	//@synthesize cnonce = _cnonce;

	NSMutableDictionary* _cnoncesUsed;
	//@property (nonatomic, retain) NSMutableDictionary* cnoncesUsed;
	//@synthesize cnoncesUsed = _cnoncesUsed;
	
	UInt32 _nc;
	//@property (nonatomic) UInt32 nc;
	//@synthesize nc = _nc;
	
	NSString* _nonce;
	//@property (nonatomic, retain) NSString* nonce;
	//@synthesize nonce = _nonce;
	
	NSString* _opaque;
	//@property (nonatomic, retain) NSString* opaque;
	//@synthesize opaque = _opaque;
		
	HLSubject* _registeredSubject;
	//@property (nonatomic, retain) Subject* registeredSubject;
	//@synthesize registeredSubject = _registeredSubject;
	
	NSDate* _idleSince;
	//@property (nonatomic, retain) NSDate* idleSince;
	//@synthesize idleSince = _idleSince;
	
	
}


-(void)authorise:(NSString*)method authorization:(HLAuthorization*)authorization entity:(id<HLEntity>)entity;
-(void)authorise:(NSString*)method authorization:(HLAuthorization*)authorization;
-(void)updateUsingAuthenticatedAuthorization:(HLAuthorization*)authorization;
-(HLWwwAuthenticate*)buildWwwAuthenticate;
-(HLAuthenticationInfo*)buildAuthenticationInfo:(HLAuthorization*)authorization responseEntity:(id<HLEntity>)responseEntity;
-(NSTimeInterval)idleTime;




#pragma mark instance setup/teardown 

-(id)initWithUsersRealm:(NSString*)usersReam;


#pragma mark fields

//NSString* _cnonce;
@property (nonatomic, retain) NSString* cnonce;
//@synthesize cnonce = _cnonce;

//NSMutableDictionary* _cnoncesUsed;
@property (nonatomic, retain) NSMutableDictionary* cnoncesUsed;
//@synthesize cnoncesUsed = _cnoncesUsed;


//UInt32 _nc;
@property (nonatomic) UInt32 nc;
//@synthesize nc = _nc;

//NSString* _nonce;
@property (nonatomic, retain) NSString* nonce;
//@synthesize nonce = _nonce;

//NSString* _opaque;
@property (nonatomic, retain) NSString* opaque;
//@synthesize opaque = _opaque;

//Subject* _registeredSubject;
@property (nonatomic, retain) HLSubject* registeredSubject;
//@synthesize registeredSubject = _registeredSubject;



@end
