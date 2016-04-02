//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "CAJsonObject.h"


@interface HLSecurityConfiguration_Generated : NSObject {
    
    //////////////////////////////////////////////////////
	// localRealm
	NSString* _localRealm;
	//@property (nonatomic, retain) NSString* localRealm;
	//@synthesize localRealm = _localRealm;

}


-(CAJsonObject*)toJsonObject;

#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithJsonObject:(CAJsonObject*)jsonObject;


#pragma mark -
#pragma mark fields

//////////////////////////////////////////////////////
// localRealm
//NSString* _localRealm;
@property (nonatomic, retain) NSString* localRealm;
//@synthesize localRealm = _localRealm;


@end
