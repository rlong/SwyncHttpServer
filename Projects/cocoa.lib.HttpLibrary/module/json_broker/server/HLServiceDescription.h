//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface HLServiceDescription : NSObject {
    
    // serviceName
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;
    
}


-(int)majorVersion;
-(int)minorVersion;

#pragma mark instance lifecycle

-(id)initWithServiceName:(NSString*)serviceName;

#pragma mark fields 


// serviceName
//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;



@end
