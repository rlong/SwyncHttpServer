// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@class HLHttpStatus_ErrorDomain;

@interface HLHttpStatus : NSObject {
	
}


+(HLHttpStatus_ErrorDomain*)errorDomain;


+(NSString*)getReason:(int)statusCode;


@end

extern int const HttpStatus_SWITCHING_PROTOCOLS_101;

extern int const HttpStatus_OK_200;
extern int const HttpStatus_NO_CONTENT_204;
extern int const HttpStatus_PARTIAL_CONTENT_206;

extern int const HttpStatus_NOT_MODIFIED_304;

extern int const HttpStatus_BAD_REQUEST_400;
extern int const HttpStatus_UNAUTHORIZED_401;
extern int const HttpStatus_FORBIDDEN_403;
extern int const HttpStatus_NOT_FOUND_404;
extern int const HttpStatus_REQUEST_ENTITY_TOO_LARGE_413;

extern int const HttpStatus_INTERNAL_SERVER_ERROR_500;
extern int const HttpStatus_NOT_IMPLEMENTED_501;

