//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CALog.h"
#import "CASecurityUtilities.h"


#import "HLAuthorization.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpSecurityManager.h"
#import "HLHttpSecuritySession.h"
#import "HLWwwAuthenticate.h"

@interface HLHttpSecurityManager () 

#pragma mark private fields 


// securityConfiguration
//id<ServerSecurityConfiguration> _securityConfiguration;
@property (nonatomic, retain) id<HLServerSecurityConfiguration> securityConfiguration;
//@synthesize securityConfiguration = _securityConfiguration;

//NSMutableDictionary* _unauthenticatedSessions;
@property (nonatomic, retain) NSMutableDictionary* unauthenticatedSessions;
//@synthesize unauthenticatedSessions = _unauthenticatedSessions;

//NSMutableDictionary* _authenticatedSessions;
@property (nonatomic, retain) NSMutableDictionary* authenticatedSessions;
//@synthesize authenticatedSessions = _authenticatedSessions;


@end 

@implementation HLHttpSecurityManager

-(id<HLServerSecurityConfiguration>)getSecurityConfiguration {
    
    return _securityConfiguration;
    
}


-(HLSubject*)registeredSubjectForAuthorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader {
    
    NSString* realm = [_securityConfiguration realm];
    NSString* authRealm = [authorizationRequestHeader realm];
    
    if( ![realm isEqualToString:authRealm] ) {
        Log_errorFormat(@"![realm isEqualToString:authRealm]; realm = '%@'; authRealm = '%@'", realm, authRealm);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
    }
    
    NSString* clientUsername = [authorizationRequestHeader username];
    HLSubject* client = [_securityConfiguration getClient:clientUsername];
    if( nil == client ) { 
        Log_errorFormat(@"nil == client; clientUsername = '%@'", clientUsername);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
    }
    return client;
    
}


//entity can be null, if it is not, it must be of type 'HLDataEntity'
-(void)authenticateRequest:(NSString*)method authorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader entity:(id<HLEntity>)entity {
	
	NSString* opaque = [authorizationRequestHeader opaque];
    
    Log_debugString( opaque );
	
	if( nil == opaque ) {
        Log_error(@"nil == opaque");
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	
	@try {
        
        if( nil != [_unauthenticatedSessions objectForKey:opaque] ) {
            
            HLHttpSecuritySession* securitySession = [_unauthenticatedSessions objectForKey:opaque];
			HLSubject* registeredSubject = [self registeredSubjectForAuthorizationRequestHeader:authorizationRequestHeader];
            
			[securitySession setRegisteredSubject:registeredSubject];
            [securitySession authorise:method authorization:authorizationRequestHeader entity:entity];
			[securitySession updateUsingAuthenticatedAuthorization:authorizationRequestHeader];
			[_authenticatedSessions setObject:securitySession forKey:opaque];
			[_unauthenticatedSessions removeObjectForKey:opaque];
            
            return;
            
        }
        
        
        if( nil != [_authenticatedSessions objectForKey:opaque] ) {
            
            HLHttpSecuritySession* securitySession = [_authenticatedSessions objectForKey:opaque];
            [securitySession authorise:method authorization:authorizationRequestHeader entity:entity];
			[securitySession updateUsingAuthenticatedAuthorization:authorizationRequestHeader];
            
            return;
        }
        
        Log_errorFormat( @"bad opaque; opaque = '%@'", opaque);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
	}
	@catch (BaseException* e) { // if we catch a 401 ... clean up sesssions associated with the opaque
        if( HttpStatus_UNAUTHORIZED_401 == [e faultCode] ) {
			[_unauthenticatedSessions removeObjectForKey:opaque];
			[_authenticatedSessions removeObjectForKey:opaque];            
        }
        // rethrow
		@throw e;
	}
}

-(void)authenticateRequest:(NSString*)method authorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader  {
    
    [self authenticateRequest:method authorizationRequestHeader:authorizationRequestHeader entity:nil];
}

-(id<HLHttpHeader>)getHeaderForResponse:(HLAuthorization*)authorization responseStatusCode:(int)responseStatusCode responseEntity:(id<HLEntity>)responseEntity {
    
    if( nil == authorization || HttpStatus_UNAUTHORIZED_401 == responseStatusCode ) { 
        
        // setup a new unauthenticated security session ...
        HLHttpSecuritySession* securitySession = [[HLHttpSecuritySession alloc] initWithUsersRealm:[_securityConfiguration realm]];
		[_unauthenticatedSessions setObject:securitySession forKey:[securitySession opaque]];
        
		HLWwwAuthenticate* answer = [securitySession buildWwwAuthenticate];
        return answer;
    } else {
        
		NSString* opaque = [authorization opaque];
        HLHttpSecuritySession* securitySession = [_authenticatedSessions objectForKey:opaque];
		HLAuthenticationInfo* answer = [securitySession buildAuthenticationInfo:authorization responseEntity:responseEntity];
        return answer;
    }
    
}




-(void)addUnregisteredSubject:(HLSubject*)unregisteredSubject {
	
    Log_enteredMethod();
    
	[_unregisteredSubjects addSubject:unregisteredSubject];
    
}

-(void)addRegisteredSubject:(HLSubject*)registeredSubject {
    
    Log_enteredMethod();
    
	[_securityConfiguration addClient:registeredSubject];
    
}



-(void)removeSubjectWithUsername:(NSString*)username {
    
    Log_infoString( username  );
	
	[_unregisteredSubjects removeSubjectWithUsername:username];
	[_securityConfiguration removeClient:username];
	
	NSMutableArray* sessionsForRemoval = [[NSMutableArray alloc] init];
    
	for( NSString* opaque in _authenticatedSessions ) {
		HLHttpSecuritySession* authenticatedSession = [_authenticatedSessions objectForKey:opaque];
		HLSubject* authenticatedSubject = [authenticatedSession registeredSubject];
		// authenticated session with the subject that we are removing 
		if( [[authenticatedSubject username] isEqualToString:username] ) {
			[sessionsForRemoval addObject:opaque];			
		}
	}
	
	for( NSString* opaque in sessionsForRemoval ) {
        Log_infoString(opaque );
		[_authenticatedSessions removeObjectForKey:opaque];
	}
    
}





-(void)runCleanup {
    
    Log_enteredMethod();
	
	NSMutableArray* stale = [[NSMutableArray alloc] init];
	
	/*
	 * unauthenticated sessions 
	 */
	for( NSString* opaque in _unauthenticatedSessions ) {
		HLHttpSecuritySession* unauthenticatedSession = [_unauthenticatedSessions objectForKey:opaque];
		NSTimeInterval idleTime = [unauthenticatedSession idleTime];
		if( ( 1 * 60 ) < idleTime ) {
            Log_debugFormat( @"removing stale unauthenticatedSession session '%@', age = %f", opaque, idleTime );
			[stale addObject:opaque];
		}
	}
	
	for( NSString* opaque in stale ) {				
		[_unauthenticatedSessions removeObjectForKey:opaque];
	}
	[stale removeAllObjects];
	
	/*
	 * authenticated sessions 
	 */
	for( NSString* opaque in _authenticatedSessions ) {
		HLHttpSecuritySession* authenticatedSession = [_authenticatedSessions objectForKey:opaque];
		NSTimeInterval idleTime = [authenticatedSession idleTime];
		if( ( 20 * 60 ) < idleTime ) {
            Log_debugFormat( @"removing stale authenticated session '%@', age = %f", opaque, idleTime );
			[stale addObject:opaque];
		}
	}
	for( NSString* opaque in stale ) {				
		[_authenticatedSessions removeObjectForKey:opaque];
	}
	[stale removeAllObjects];
	
	/*
	 * registration requests 
	 */
	NSEnumerator* subjectEnumerator = [_unregisteredSubjects subjectEnumerator];
	for( HLSubject* unregisteredSubject in subjectEnumerator ) {
		NSTimeInterval objectAge = - [[unregisteredSubject born] timeIntervalSinceNow];
		if( ( 5 * 60 ) < objectAge ) {
            Log_debugFormat( @"removing stale registration request for user '%@', age = %f", [unregisteredSubject username], objectAge );
			[stale addObject:unregisteredSubject];
		}
	}
	for( HLSubject* unregisteredSubject in stale ) {				
		[_unregisteredSubjects removeSubject:unregisteredSubject];
	}
    
}

-(BOOL)subjectHasAuthenticatedSession:(HLSubject*)target {
	
	for( NSString* opaque in _authenticatedSessions ) {
		HLHttpSecuritySession* authenticatedSession = [_authenticatedSessions objectForKey:opaque];
		HLSubject* candidate = [authenticatedSession registeredSubject];
		if( [[candidate username] isEqualToString:[target username]] ) {
			return YES;
		}
	}
	return NO;
    
}


-(HLSubject*)approveSubjectWithUsername:(NSString*)userName {
    
    HLSubject* approvedSubject = [_unregisteredSubjects subjectForUsername:userName];
    [_securityConfiguration addClient:approvedSubject];
    [_unregisteredSubjects removeSubject:approvedSubject];
    return approvedSubject;
    
}


#pragma mark instance setup/teardown 

-(id)initWithSecurityConfiguration:(id<HLServerSecurityConfiguration>)securityConfiguration {
	
	HLHttpSecurityManager* answer = [super init];
    
    [answer setSecurityConfiguration:securityConfiguration];
	
    
	answer->_unauthenticatedSessions = [[NSMutableDictionary alloc] init];
	answer->_authenticatedSessions = [[NSMutableDictionary alloc] init];
	answer->_unregisteredSubjects = [[HLSubjectGroup alloc] init];
	
	return answer;
}

-(void)dealloc {
	
	
    [self setSecurityConfiguration:nil];
	[self setUnauthenticatedSessions:nil];
	[self setAuthenticatedSessions:nil];
	[self setUnregisteredSubjects:nil];
	
}




#pragma mark fields 


// securityConfiguration
//id<ServerSecurityConfiguration> _securityConfiguration;
//@property (nonatomic, retain) id<ServerSecurityConfiguration> securityConfiguration;
@synthesize securityConfiguration = _securityConfiguration;


//NSMutableDictionary* _unauthenticatedSessions;
//@property (nonatomic, retain) NSMutableDictionary* unauthenticatedSessions;
@synthesize unauthenticatedSessions = _unauthenticatedSessions;

//NSMutableDictionary* _authenticatedSessions;
//@property (nonatomic, retain) NSMutableDictionary* authenticatedSessions;
@synthesize authenticatedSessions = _authenticatedSessions;

//SubjectGroup* _unregisteredSubjects;
//@property (nonatomic, retain) SubjectGroup* unregisteredSubjects;
@synthesize unregisteredSubjects = _unregisteredSubjects;


@end
