//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLServerSecurityConfiguration.h"
#import "HLSubject.h"
#import "HLSubjectGroup.h"

@interface HLHttpSecurityManager : NSObject {
	
	// securityConfiguration
	id<HLServerSecurityConfiguration> _securityConfiguration;
	//@property (nonatomic, retain) id<ServerSecurityConfiguration> securityConfiguration;
	//@synthesize securityConfiguration = _securityConfiguration;
    
	NSMutableDictionary* _unauthenticatedSessions;
	//@property (nonatomic, retain) NSMutableDictionary* unauthenticatedSessions;
	//@synthesize unauthenticatedSessions = _unauthenticatedSessions;
	
	NSMutableDictionary* _authenticatedSessions;
	//@property (nonatomic, retain) NSMutableDictionary* authenticatedSessions;
	//@synthesize authenticatedSessions = _authenticatedSessions;
	
	HLSubjectGroup* _unregisteredSubjects;
	//@property (nonatomic, retain) SubjectGroup* unregisteredSubjects;
	//@synthesize unregisteredSubjects = _unregisteredSubjects;
	
}

-(id<HLServerSecurityConfiguration>)getSecurityConfiguration;

//entity can be null, if it is not, it must be of type 'HLDataEntity'
-(void)authenticateRequest:(NSString*)method authorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader entity:(id<HLEntity>)entity;
-(void)authenticateRequest:(NSString*)method authorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader;
-(id<HLHttpHeader>)getHeaderForResponse:(HLAuthorization*)authorization responseStatusCode:(int)responseStatusCode responseEntity:(id<HLEntity>)responseEntity;
-(void)addUnregisteredSubject:(HLSubject*)unregisteredSubject;
-(void)addRegisteredSubject:(HLSubject*)registeredSubject;
-(void)removeSubjectWithUsername:(NSString*)username;
-(void)runCleanup;
-(BOOL)subjectHasAuthenticatedSession:(HLSubject*)target;
-(HLSubject*)approveSubjectWithUsername:(NSString*)userName;



#pragma mark instance setup/teardown 

-(id)initWithSecurityConfiguration:(id<HLServerSecurityConfiguration>)securityConfiguration;

#pragma mark public fields

//SubjectGroup* _unregisteredSubjects;
@property (nonatomic, retain) HLSubjectGroup* unregisteredSubjects;
//@synthesize unregisteredSubjects = _unregisteredSubjects;


@end
