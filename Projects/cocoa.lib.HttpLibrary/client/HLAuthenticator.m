// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CAKeychainUtilities.h"
#import "CALog.h"
#import "CASecurityUtilities.h"

#import "HLAuthenticationInfo.h"
#import "HLAuthenticator.h"
#import "HLDataEntity.h"
#import "HLSubject.h"
#import "HLWwwAuthenticate.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLAuthenticator () 


// ha1
//NSString* _ha1;
@property (nonatomic, retain) NSString* ha1;
//@synthesize ha1 = _ha1;


// authorization
//Authorization* _authorization;
@property (nonatomic, retain) HLAuthorization* authorization;
//@synthesize authorization = _authorization;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLAuthenticator



// can return nil
-(NSString*)getHa2:(NSString*)method requestUri:(NSString*)requestUri requestEntity:(id<HLEntity>)requestEntity {
    
    // RFC-2617 3.2.2.3 A2
    NSString* a2; 
    
    if( _authInt ) { 
        
        if( ![requestEntity isKindOfClass:[HLDataEntity class]] ) {
            Log_warnFormat( @"!([requestEntity isKindOfClass:[DataEntity class]]; NSStringFromClass([requestEntity class]) = '%@'", NSStringFromClass([requestEntity class]) );
            return nil;
        }
        HLDataEntity* dataEntity = (HLDataEntity*)requestEntity;
        NSData* data = [dataEntity data];
        NSString* entityBodyHash = [CASecurityUtilities md5HashOfData:data];
        Log_debugString( entityBodyHash);
        
        a2 = [NSString stringWithFormat:@"%@:%@:%@", method, requestUri, entityBodyHash ];
        
    } else {
        a2 = [NSString stringWithFormat:@"%@:%@", method, requestUri];
        
    }
    
    NSString* ha2 = [CASecurityUtilities md5HashOfString:a2];
    //Log_debugString( ha2);
    NSString* answer = ha2;
    
    return answer;

    
}

// can return nil
-(NSString*)getRequestAuthorizationForMethod:(NSString*)method requestUri:(NSString*)requestUri entity:(id<HLEntity>)entity {
    
    if( nil == _authorization ) { 
        Log_warn(@"nil == _authorization" );
        return nil;
    }
    
    if( nil == _ha1 ) { 
        Log_warn(@"nil == _ha1" );
        return nil;
    }
    
    
    NSString* ha2 = [self getHa2:method requestUri:requestUri requestEntity:entity];
    if( nil == ha2 ) { 
        Log_warn(@"nil == ha2" );
        return nil;
        
    }

    [_authorization setUri:requestUri];

    if( _authInt ) { 
        
        [_authorization setQop:@"auth-int"];
        
    } else {
        [_authorization setQop:@"auth"];
        
    }
    
    NSString* response;
    {
        NSString* unhashedResponse = [NSString stringWithFormat:@"%@:%@:%08x:%@:%@:%@", 
                                     _ha1, [_authorization nonce], (int)[_authorization nc], [_authorization cnonce], [_authorization qop], ha2];
        
        response = [CASecurityUtilities md5HashOfString:unhashedResponse];
    }
    
    [_authorization setResponse:response];
    
    return [_authorization toString];
    
}

-(HLSubject*)getSubjectForRealm:(NSString*)serverRealm {

    HLSubject* answer = [_securityConfiguration getServer:serverRealm];
    if( nil != answer ) { 
        return answer;
    }
    
    // getting a bit desperate now ... see if it's in the KeyChainUtilities
    NSString* username = [_securityConfiguration username];
    
    NSString* password = [CAKeychainUtilities passwordForUsername:username service:serverRealm];
    
    if( nil == password ) {
        Log_infoFormat( @"did *NOT* find password in the keychain; serverRealm = '%@'", serverRealm );
        return nil;
    }
    
    Log_infoFormat( @"found password in the keychain; serverRealm = '%@'", serverRealm );
    NSString* label = serverRealm;
    Log_infoString( label );
    
    answer = [[HLSubject alloc] initWithUsername:username realm:serverRealm password:password label:label];
    
    [_securityConfiguration addServer:answer];
    
    return answer;

}


// 'handleResponseHeaders:' is part of a private Apple API
-(void)handleHttpResponseHeaders:(NSDictionary*)headers {
    
    NSString* wwwAuthenticate = [headers objectForKey:@"www-authenticate"];
    if( nil != wwwAuthenticate ) { 
        
        HLWwwAuthenticate* authenticateResponseHeader = [HLWwwAuthenticate buildFromString:wwwAuthenticate];
        
        NSString* serverRealm = [authenticateResponseHeader realm];
        
        HLSubject* server = [self getSubjectForRealm:serverRealm];
        if( nil == server ) { 
            Log_warnFormat( @"nil == server; serverRealm = '%@'", serverRealm);
            [self setAuthorization:nil];
            [self setHa1:nil];
            return;
        }
        
        [self setHa1:[server ha1]];
        
        _authorization = [[HLAuthorization alloc] init];
        
        [_authorization setNc:1];
        [_authorization setCnonce:[CASecurityUtilities generateNonce]];
        [_authorization setNonce:[authenticateResponseHeader nonce]];
        [_authorization setOpaque:[authenticateResponseHeader opaque]];
        
        [_authorization setRealm:[server realm]];
        
        [_authorization setUsername:[server username]];
        
        return; // our work here is done 
    }
    
    NSString* authenticationInfo = [headers objectForKey:@"authentication-info"];
    if( nil != authenticationInfo ) { 
        
        HLAuthenticationInfo* authenticationInfoHeader = [HLAuthenticationInfo buildFromString:authenticationInfo];
        
        uint nc = [_authorization nc] + 1;
        [_authorization setNc:nc];
        [_authorization setNonce:[authenticationInfoHeader nextnonce]];
        
        return;
    }
    
    Log_warn( @"did not find a 'WWW-Authenticate' or a 'Authentication-Info'" );
    
}


// can return nil
-(NSString*)realm {
    if( nil == _authorization ) {
        return nil;
    }
    return [_authorization realm];
}


#pragma mark instance lifecycle 

-(id)initWithAuthInt:(bool)authInt securityConfiguration:(id<HLClientSecurityConfiguration>)securityConfiguration {
    
    HLAuthenticator* answer = [super init];
    
    [answer setAuthInt:authInt];
    [answer setSecurityConfiguration:securityConfiguration];
    
    return answer;
}


-(void)dealloc{
	
    [self setHa1:nil];
    [self setSecurityConfiguration:nil];
    [self setAuthorization:nil];
    
	
}

#pragma mark fields


// ha1
//NSString* _ha1;
//@property (nonatomic, retain) NSString* ha1;
@synthesize ha1 = _ha1;

// securityConfiguration
//id<ClientSecurityConfiguration> _securityConfiguration;
//@property (nonatomic, retain) id<ClientSecurityConfiguration> securityConfiguration;
@synthesize securityConfiguration = _securityConfiguration;

// authInt
//bool _authInt;
//@property (nonatomic) bool authInt;
@synthesize authInt = _authInt;


// authorization
//Authorization* _authorization;
//@property (nonatomic, retain) Authorization* authorization;
@synthesize authorization = _authorization;



@end
