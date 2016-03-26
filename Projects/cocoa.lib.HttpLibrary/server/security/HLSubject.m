//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CASecurityUtilities.h"
#import "CAObjectTracker.h"

#import "HLAuthorization.h"
#import "HLHttpErrorHelper.h"
#import "HLSubject.h"



@interface HLSubject () 

#pragma mark private fields 





@end


@implementation HLSubject


static HLSubject* _test = nil; 

+(void)initialize {
    
    _test = [[HLSubject alloc] initWithUsername:[HLSubject TEST_USER] realm:[HLSubject TEST_REALM] password:[HLSubject TEST_PASSWORD] label:@"Test User"];
	
}


+(NSString*)TEST_USER {
    return @"test";
    
}

+(NSString*)TEST_REALM {
    return @"test";
    
}

+(NSString*)TEST_PASSWORD {
    return @"12345678";
    
}


+(HLSubject*)TEST {

    return _test;
}




// sections 3.2.2.1-3.2.2.3 of RFC-2617
-(NSString*)ha1 {
	
	if( nil == _ha1 ) {
		
		NSString* a1 = [NSString stringWithFormat:@"%@:%@:%@", _username, _realm, _password];
		_ha1 = [CASecurityUtilities md5HashOfString:a1];
		Log_debugString( _ha1 );
		
	}
	
	return _ha1;
	
}


-(void)validateAuthorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader {
	
	// realm ... 
	NSString* realm = [authorizationRequestHeader realm];
	if( nil == realm ) {
        Log_error( @"nil == realm" );
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
    
	if( ! [_realm isEqualToString:realm] ) {
        Log_errorFormat( @"! [_realm isEqualToString:realm]; _realm = '%@'; realm = '%@'", _realm, realm);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	
	// username ...
	NSString* username = [authorizationRequestHeader username];
	if( nil == username ) {
        Log_error( @"nil == username" );
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
        
	} else if( ![_username isEqualToString:username] ) { // someone is switching user names 
        Log_errorFormat( @"![_username isEqualToString:username]; _username = '%@'; username = '%@'", _username, username);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
         
	}
	
}

#pragma mark instance setup/teardown


-(id)initWithUsername:(NSString*)username realm:(NSString*)realm password:(NSString*)password label:(NSString*)label {
	
	HLSubject* answer = [super init];
	
	
	answer->_born = [NSDate date];
    
    answer->_username = username;
    answer->_realm = realm;
	answer->_password = password;
	answer->_label = label;
	
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
    
    if( nil != _label ) {
        _label = nil;
    }
	
	_born = nil;
	
	if( nil != _ha1 ) {
		_ha1 = nil;
	}
	
	
}

#pragma mark fields 

//////////////////////////////////////////////////////
// username
//NSString* _username;
//@property (nonatomic, readonly) NSString* username;
@synthesize username = _username;


// realm
//NSString* realm;
//@property (nonatomic, readonly) NSString* realm;
@synthesize realm = _realm;

//////////////////////////////////////////////////////
// password
//NSString* _password;
//@property (nonatomic, retain) NSString* password;
@synthesize password = _password;

//////////////////////////////////////////////////////
// label
//NSString* _label;
//@property (nonatomic, retain) NSString* label;
@synthesize label = _label;


//NSDate* _born;
//@property (nonatomic, readonly) NSDate* born;
@synthesize born = _born;

@end
