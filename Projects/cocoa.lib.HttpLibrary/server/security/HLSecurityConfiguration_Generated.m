//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLSecurityConfiguration_Generated.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLSecurityConfiguration_Generated ()

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation HLSecurityConfiguration_Generated


-(CAJsonObject*)toJsonObject {
	CAJsonObject* answer = [[CAJsonObject alloc] init];
	[answer setObject:_localRealm forKey:@"localRealm"];
	return answer;
    
}


#pragma mark instance lifecycle

-(id)init {
	return [super init];
}


-(id)initWithJsonObject:(CAJsonObject*)jsonObject {
	
	HLSecurityConfiguration_Generated* answer = [super init];
	
	[answer setLocalRealm:[jsonObject stringForKey:@"localRealm" defaultValue:nil]];
	
	return answer;
	
}

-(void)dealloc {
    
    [self setLocalRealm:nil];
    
    
}



#pragma mark fields

// localRealm
//NSString* _localRealm;
//@property (nonatomic, retain) NSString* localRealm;
@synthesize localRealm = _localRealm;


@end
