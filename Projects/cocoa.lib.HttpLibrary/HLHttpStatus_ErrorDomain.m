// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLHttpStatus_ErrorDomain.h"

@implementation HLHttpStatus_ErrorDomain

-(NSString*)BAD_REQUEST_400 {
    return @"cocoa.lib.HttpLibrary.HttpStatus.BAD_REQUEST_400";
}


-(NSString*)UNAUTHORIZED_401 {
    return @"cocoa.lib.HttpLibrary.HttpStatus.UNAUTHORIZED_401";
}


-(NSString*)NOT_FOUND_404 {
    return @"cocoa.lib.HttpLibrary.HttpStatus.NOT_FOUND_404";
}



@end
