//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CALog.h"
#import "CASecurityUtilities.h"


#import "HLDataEntity.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpSecuritySession.h"


// .m protected methods ...
@interface HLHttpSecuritySession () 


// usersRealm
//NSString* _usersRealm;
@property (nonatomic, retain) NSString* usersRealm;
//@synthesize usersRealm = _usersRealm;


//NSDate* _idleSince;
@property (nonatomic, retain) NSDate* idleSince;
//@synthesize idleSince = _idleSince;


@end 


@implementation HLHttpSecuritySession



// section 3.2.2.3 of RFC-2671
// entity can be null
+(NSString*)getHa2:(NSString*)method requestUri:(NSString*)requestUri entity:(id<HLEntity>)entity {
    
	// sections 3.2.2.1-3.2.2.3 of RFC-2617
    NSString* entityBodyHash;
    if( nil == entity ) { 
        entityBodyHash = [CASecurityUtilities md5HashOfString:@""];
    } else {
        if( !([entity isKindOfClass:[HLDataEntity class]]) ) {
            
            NSString* faultMessage = [NSString stringWithFormat:@"!([entity isKindOfClass:[DataEntity class]]); NSStringFromClass([entity class]) = '%@'", NSStringFromClass([entity class])];
            Log_error(faultMessage);
            
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:faultMessage];
            @throw  e;
        }
        HLDataEntity* dataEntity = (HLDataEntity*)entity;
        NSData* data = [dataEntity data];
        entityBodyHash = [CASecurityUtilities md5HashOfData:data];
    }
    Log_debugString( entityBodyHash );

	NSString* a2 = [NSString stringWithFormat:@"%@:%@:%@", method, requestUri, entityBodyHash];
	NSString* ha2 = [CASecurityUtilities md5HashOfString:a2];
    Log_debugString( ha2 );
    return ha2;
    
}

// section 3.2.2.3 of RFC-2671
+(NSString*)getHa2:(NSString*)method requestUri:(NSString*)requestUri  {
    
    NSString* a2 = [NSString stringWithFormat:@"%@:%@", method, requestUri];
    Log_debugString( a2 );
    
	NSString* ha2 = [CASecurityUtilities md5HashOfString:a2];
    Log_debugString( ha2 );
    
    return ha2;
    
}


// entity can be null
+(NSString*)getHa2:(NSString*)method qop:(NSString*)qop requestUri:(NSString*)requestUri entity:(id<HLEntity>)entity {
    
    NSString* ha2; 
    
    if( [@"auth" isEqualToString:qop] ) { 
        ha2 = [self getHa2:method requestUri:requestUri];
    } else if( [@"auth-int"isEqualToString:qop] ) { 
        ha2 = [self getHa2:method requestUri:requestUri entity:entity];
    } else {
        Log_errorFormat( @"unhandled qop; qop = '%@'", qop);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
    }
    
    return ha2;
    
}


-(void)validateAuthorization:(HLAuthorization*)authorization {

    if( nil == authorization ) { 
        Log_error( @"nil == authorization" );
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
    }
    
    if( nil == _registeredSubject ) { // should not happen, but ... 
        Log_error(@"nil == _registeredSubject");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	
	// username & realm ... 
	[_registeredSubject validateAuthorizationRequestHeader:authorization];

    
    // cnonce ... 
	NSString* submittedCnonce = [authorization cnonce];
	if( nil == submittedCnonce ) {
        Log_error(@"nil == submittedCnonce");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}

    // cnonce & nc ... 
	if( [submittedCnonce isEqualToString:_cnonce] ) { // client is re-using cnonce
		if( (_nc + 1) != [authorization nc] ) {
            
            Log_errorFormat( @"(_nc + 1) != [authorization nc]; _nc = %d; [authorization nc] = %d", _nc, [authorization nc]);
            @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
		}
	} else { // client has a new cnonce
		
		if( 1 != [authorization nc] ) {
            Log_errorFormat( @"1 != [authorization nc]; [authorization nc] = %d", [authorization nc]);
            @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
		}
		// try detect a replay attack ... 
		if( nil != [_cnoncesUsed objectForKey:submittedCnonce] ) {
            Log_errorFormat( @"nil != [_cnoncesUsed objectForKey:submittedCnonce]; submittedCnonce = '%@'", submittedCnonce);
            @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
		}
	}
    
    
    // nonce ... 	
	if( nil == [authorization nonce] ) {
        Log_error(@"nil == [authorization nonce]");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	if( ![_nonce isEqualToString:[authorization nonce]] ) { 
        Log_errorFormat( @"![_nonce isEqualToString:[authorization nonce]]; _nonce = %d; [authorization nonce] = %d", _nonce, [authorization nonce]);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}


    // opaque ... 	
	if( ![_opaque isEqualToString:[authorization opaque]] ) { // should not happen but ... 
        
        Log_errorFormat( @"![_opaque isEqualToString:[authorization opaque]]; _opaque = '%@'; [authorization opaque] = '%@'", _opaque, [authorization opaque]);
        
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}	

    // qop ... 
	// from section 3.1.2 of RFC-2617 ... in relation to qop-options ... 
	// "Unrecognized options MUST be ignored."
	if( nil == [authorization qop] ) {
        
        Log_error(@"nil == [authorization qop]");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}

    if( [@"auth" isEqualToString:[authorization qop]]||[@"auth-int" isEqualToString:[authorization qop]] ) { 
        // ok
    } else {
        Log_errorFormat( @"unsupported qop; [authorization qop] = '%@'", [authorization qop] );
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
    }
    
    // response 
	if( nil == [authorization response] ) {
        Log_error(@"nil == [authorization response]");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
    
    // uri 
	if( nil == [authorization uri] ) {
        
        Log_error(@"nil == [authorization uri]");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
    
}


// this method has no effect on the state of 'self' ...
// sections 3.2.2.1-3.2.2.3 of RFC-2617
// entity can be null
-(void)authorise:(NSString*)method authorization:(HLAuthorization*)authorization entity:(id<HLEntity>)entity { 
    
    [self validateAuthorization:authorization];
    
    {
        NSString* ha1 = [_registeredSubject ha1];
        Log_debugString( ha1 );
        
        NSString* ha2 = [HLHttpSecuritySession getHa2:method qop:[authorization qop] requestUri:[authorization uri] entity:entity];
        
        NSString* unhashedResponse = [NSString stringWithFormat:@"%@:%@:%08x:%@:%@:%@", 
                                      ha1, [authorization nonce], (int)[authorization nc],
                                      [authorization cnonce], [authorization qop], ha2];
        
        
        NSString* expectedResponse = [CASecurityUtilities md5HashOfString:unhashedResponse];

        if( ![expectedResponse isEqualToString:[authorization response]] ) {
            
            Log_errorFormat( @"![expectedResponse isEqualToString:[authorization response]]; expectedResponse = '%@'; [authorization response] = '%@'", expectedResponse, [authorization response]);
            @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
            
        } 
        
        Log_debugString( expectedResponse );

    }
    
    [self setIdleSince:[NSDate date]];

}


-(void)authorise:(NSString*)method authorization:(HLAuthorization*)authorization  { 
    
    [self authorise:method authorization:authorization entity:nil];
}


//pre: authoriseRequest returned without an exception being thrown
// this is the method that updates our state
-(void)updateUsingAuthenticatedAuthorization:(HLAuthorization*)authorization {
	
	NSString* cnonce = [authorization cnonce];
	[self setCnonce:[authorization cnonce]];
	
	[_cnoncesUsed setObject:cnonce forKey:cnonce];
	
	[self setNc:[authorization nc]];
	
	[self setNonce:[CASecurityUtilities generateNonce]];	
	
}


-(HLWwwAuthenticate*)buildWwwAuthenticate {
	HLWwwAuthenticate* answer = [[HLWwwAuthenticate alloc] init];
	
	[answer setNonce:_nonce];
	[answer setOpaque:_opaque];
	[answer setRealm:_usersRealm];
	
	return answer;
    
}

-(HLAuthenticationInfo*)buildAuthenticationInfo:(HLAuthorization*)authorization responseEntity:(id<HLEntity>)responseEntity {
    
    Log_enteredMethod();
    
	HLAuthenticationInfo* answer = [[HLAuthenticationInfo alloc] init];
	
	[answer setCnonce:_cnonce];
	[answer setNc:_nc];
	[answer setNextnonce:_nonce];
    [answer setQop:[authorization qop]];
	
    
	/*
	 * rspauth field
	 */
	NSString* ha1 = [_registeredSubject ha1];
    
    // from RFC-2617, section 3.2.3, we leave the method out ...   
    NSString* ha2 = [HLHttpSecuritySession getHa2:@"" qop:[authorization qop] requestUri:[authorization uri] entity:responseEntity];
    
	NSString* unhashedRspauth = [NSString stringWithFormat:@"%@:%@:%08x:%@:%@:%@", 
                                 ha1, [authorization nonce], (int)[authorization nc],
                                 [authorization cnonce], [authorization qop], ha2];
    
	NSString* rspauth = [CASecurityUtilities md5HashOfString:unhashedRspauth];
	[answer setRspauth:rspauth];
	
	return answer;
}



-(NSTimeInterval)idleTime {
	return - [_idleSince timeIntervalSinceNow];
}


#pragma mark instance setup/teardown 

-(id)initWithUsersRealm:(NSString*)usersReam {
	
	HLHttpSecuritySession* answer = [super init];
	
    
    [answer setUsersRealm:usersReam];
	[answer setIdleSince:[NSDate date]];

	[answer setNonce:[CASecurityUtilities generateNonce]];
	answer->_cnoncesUsed = [[NSMutableDictionary alloc] init];
	[answer setOpaque:[CASecurityUtilities generateNonce]];
	
	return answer;
}

-(void)dealloc {
	
	
    [self setUsersRealm:nil];
	[self setIdleSince:nil];
	[self setCnonce:nil];
	[self setCnoncesUsed:nil];
	// nc 
	[self setNonce:nil];
	[self setOpaque:nil];
	[self setRegisteredSubject:nil];
	
	
}

#pragma mark fields

// usersRealm
//NSString* _usersRealm;
//@property (nonatomic, retain) NSString* usersRealm;
@synthesize usersRealm = _usersRealm;


//NSDate* _idleSince;
//@property (nonatomic, retain) NSDate* idleSince;
@synthesize idleSince = _idleSince;


//NSString* _cnonce;
//@property (nonatomic, retain) NSString* cnonce;
@synthesize cnonce = _cnonce;

//NSMutableDictionary* _cnoncesUsed;
//@property (nonatomic, retain) NSMutableDictionary* cnoncesUsed;
@synthesize cnoncesUsed = _cnoncesUsed;

//UInt32 _nc;
//@property (nonatomic) UInt32 nc;
@synthesize nc = _nc;

//NSString* _nonce;
//@property (nonatomic, retain) NSString* nonce;
@synthesize nonce = _nonce;

//NSString* _opaque;
//@property (nonatomic, retain) NSString* opaque;
@synthesize opaque = _opaque;

//RegisteredSubject* _registeredSubject;
//@property (nonatomic, retain) RegisteredSubject* registeredSubject;
@synthesize registeredSubject = _registeredSubject;

@end
