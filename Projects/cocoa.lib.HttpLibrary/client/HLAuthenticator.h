// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "HLAuthorization.h"
#import "HLClientSecurityConfiguration.h"
#import "HLEntity.h"


@interface HLAuthenticator : NSObject {

    
    // ha1
	NSString* _ha1;
	//@property (nonatomic, retain) NSString* ha1;
	//@synthesize ha1 = _ha1;

    // securityConfiguration
	id<HLClientSecurityConfiguration> _securityConfiguration;
	//@property (nonatomic, retain) id<ClientSecurityConfiguration> securityConfiguration;
	//@synthesize securityConfiguration = _securityConfiguration;

    // authInt
    bool _authInt;
    //@property (nonatomic) bool authInt;
    //@synthesize authInt = _authInt;

    // authorization
    HLAuthorization* _authorization;
    //@property (nonatomic, retain) Authorization* authorization;
    //@synthesize authorization = _authorization;
    

}

-(NSString*)getRequestAuthorizationForMethod:(NSString*)method requestUri:(NSString*)requestUri entity:(id<HLEntity>)entity;

// 'handleResponseHeaders:' is part of a private Apple API
-(void)handleHttpResponseHeaders:(NSDictionary*)headers;

// can return nil
-(NSString*)realm;


#pragma mark instance lifecycle 


-(id)initWithAuthInt:(bool)authInt securityConfiguration:(id<HLClientSecurityConfiguration>)securityConfiguration;


#pragma mark fields

// securityConfiguration
//id<ClientSecurityConfiguration> _securityConfiguration;
@property (nonatomic, retain) id<HLClientSecurityConfiguration> securityConfiguration;
//@synthesize securityConfiguration = _securityConfiguration;

// authInt
//bool _authInt;
@property (nonatomic) bool authInt;
//@synthesize authInt = _authInt;



@end
