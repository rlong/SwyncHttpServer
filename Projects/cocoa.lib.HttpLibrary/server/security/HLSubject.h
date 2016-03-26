//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLAuthorization.h"

@interface HLSubject : NSObject {

    
    //////////////////////////////////////////////////////
	// username
	NSString* _username;
	//@property (nonatomic, readonly) NSString* username;
	//@synthesize username = _username;

    // realm
	NSString* _realm;
	//@property (nonatomic, readonly) NSString* realm;
	//@synthesize realm = _realm;
    
    
    //////////////////////////////////////////////////////
	// password
	NSString* _password;
	//@property (nonatomic, retain) NSString* password;
	//@synthesize password = _password;

	//////////////////////////////////////////////////////
	// label
	NSString* _label;
	//@property (nonatomic, retain) NSString* label;
	//@synthesize label = _label;

    
	NSString* _ha1;
	
	NSDate* _born;
	//@property (nonatomic, readonly) NSDate* born;
	//@synthesize born = _born;
	
	

}


+(NSString*)TEST_USER;
+(NSString*)TEST_REALM;
+(NSString*)TEST_PASSWORD;

+(HLSubject*)TEST;



// sections 3.2.2.1-3.2.2.3 of RFC-2617
-(NSString*)ha1;



#pragma mark instance setup/teardown


-(id)initWithUsername:(NSString*)username realm:(NSString*)realm password:(NSString*)password label:(NSString*)label;

-(void)validateAuthorizationRequestHeader:(HLAuthorization*)authorizationRequestHeader;

#pragma mark fields

//////////////////////////////////////////////////////
// username
//NSString* _username;
@property (nonatomic, readonly) NSString* username;
//@synthesize username = _username;

//////////////////////////////////////////////////////
// realm
//NSString* realm;
@property (nonatomic, readonly) NSString* realm;
//@synthesize realm = _realm;


//////////////////////////////////////////////////////
// password
//NSString* _password;
@property (nonatomic, readonly) NSString* password;
//@synthesize password = _password;


//////////////////////////////////////////////////////
// label
//NSString* _label;
@property (nonatomic, readonly) NSString* label;
//@synthesize label = _label;


//NSDate* _born;
@property (nonatomic, readonly) NSDate* born;
//@synthesize born = _born;


@end
