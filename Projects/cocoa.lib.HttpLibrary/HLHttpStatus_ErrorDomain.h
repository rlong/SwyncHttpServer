// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@interface HLHttpStatus_ErrorDomain : NSObject {
    
}

-(NSString*)BAD_REQUEST_400;
-(NSString*)UNAUTHORIZED_401;
-(NSString*)NOT_FOUND_404;

@end
