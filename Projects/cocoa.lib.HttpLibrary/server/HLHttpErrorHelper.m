//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"

#import "HLDataEntity.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpStatus.h"
#import "HLEntity.h"
#import "HLHttpStatus.h"
#import "HLHttpStatus_ErrorDomain.h"

#import "HLHttpResponse.h"

@implementation HLHttpErrorHelper

+(CABaseException*)buildException:(id)originator line:(int)line statusCode:(int)statusCode {
    
    NSString* reason = [HLHttpStatus getReason:statusCode];
    
    CABaseException* answer = [[CABaseException alloc] initWithOriginator:originator line:line faultMessage:reason];
    [answer setFaultCode:statusCode];
    
    return answer;
}

+(CABaseException*)badRequest400FromOriginator:(id)originator line:(int)line {
  
    CABaseException* answer = [self buildException:originator line:line statusCode:HttpStatus_BAD_REQUEST_400];
    [answer setErrorDomain:[[HLHttpStatus errorDomain] BAD_REQUEST_400]];
    return answer;
}

+(CABaseException*)unauthorized401FromOriginator:(id)originator line:(int)line {
    CABaseException* answer = [self buildException:originator line:line statusCode:HttpStatus_UNAUTHORIZED_401];
    [answer setErrorDomain:[[HLHttpStatus errorDomain] UNAUTHORIZED_401]];
    return answer;
}

+(CABaseException*)forbidden403FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_FORBIDDEN_403];
}

+(CABaseException*)notFound404FromOriginator:(id)originator line:(int)line {
    CABaseException* answer =  [self buildException:originator line:line statusCode:HttpStatus_NOT_FOUND_404];
    [answer setErrorDomain:[[HLHttpStatus errorDomain] NOT_FOUND_404]];
    return answer;
}


+(CABaseException*)requestEntityTooLarge413FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_REQUEST_ENTITY_TOO_LARGE_413];
}


+(CABaseException*)internalServerError500FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_INTERNAL_SERVER_ERROR_500];
}

+(CABaseException*)notImplemented501FromOriginator:(id)originator line:(int)line {
    return [self buildException:originator line:line statusCode:HttpStatus_NOT_IMPLEMENTED_501];
}

+(id<HLEntity>)toEntity:(int)statusCode { 
    NSString* statusString = [HLHttpStatus getReason:statusCode];
    
    NSString* responseTemplate = @"<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\"><html><head><title>%d %@</title></head><body><h1>%@</h1></body></html>";
    NSString* messageBody = [NSString stringWithFormat:responseTemplate, statusCode, statusString,statusString];
    
    NSData* data=[messageBody dataUsingEncoding:NSUTF8StringEncoding];
    
    HLDataEntity* answer = [[HLDataEntity alloc] initWithData:data];
    return answer;
    
}


+(HLHttpResponse*)toHttpResponse:(NSException*)e { // 8E1FF9FF-AE84-4E44-B088-6426FF0C30E7
    
    int statusCode = HttpStatus_INTERNAL_SERVER_ERROR_500;
    
    if( [e isKindOfClass:[BaseException class]] ){ 
        
        BaseException* baseException = (BaseException*)e;
        
        int faultCode = [baseException faultCode];
        
        // does BaseException have what looks like a HTTP CODE ?
        if( 0 < faultCode &&  faultCode < 1000 ) {
            statusCode = faultCode;
        }
    }
  
    id<HLEntity> entity = [self toEntity:statusCode];
    HLHttpResponse* answer = [[HLHttpResponse alloc] initWithStatus:statusCode entity:entity];
    return answer;
    
    
}



@end
