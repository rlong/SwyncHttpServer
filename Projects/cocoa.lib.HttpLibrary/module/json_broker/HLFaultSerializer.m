// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CAExceptionHelper.h"
#import "HLFaultSerializer.h"

@implementation HLFaultSerializer




+(CAJsonObject*)baseExceptionToJSONObject:(BaseException*)baseException {
    
    
    CAJsonObject* answer = [[CAJsonObject alloc] init];
    
    [answer setObject:[baseException errorDomain] forKey:@"errorDomain"]; // nil is OK
    
    int fault_code = [baseException faultCode];
    [answer setInt:fault_code forKey:@"faultCode"];
    
    [answer setObject:[baseException reason] forKey:@"faultMessage"];
    [answer setObject:[baseException underlyingFaultMessage] forKey:@"underlyingFaultMessage"];
    
    [answer setObject:[baseException originator] forKey:@"originator"];
    
    CAJsonArray* stackTrace = [CAExceptionHelper getStackTrace:baseException];
    [answer setObject:stackTrace forKey:@"stackTrace"];
    
    CAJsonObject* faultContext = [[CAJsonObject alloc] init];
    [faultContext setObject:[CAExceptionHelper getAtosCommand:baseException] forKey:@"atos"];
    [answer setObject:faultContext forKey:@"faultContext"];
    
    return answer;
    
}


+(CAJsonObject*)toJSONObject:(NSException*)exception {
    
    if( [exception isKindOfClass:[BaseException class]] ) { 
        return [self baseExceptionToJSONObject:(BaseException*)exception];
    }
    
    CAJsonObject* answer = [[CAJsonObject alloc] init];

    [answer setObject:nil forKey:@"errorDomain"];

    [answer setInt:[BaseException defaultFaultCode] forKey:@"faultCode"];
    [answer setObject:[exception reason] forKey:@"faultMessage"];
    [answer setObject:[exception reason] forKey:@"underlyingFaultMessage"];

    
    CAJsonArray* stackTrace = [CAExceptionHelper getStackTrace:exception];
    [answer setObject:stackTrace forKey:@"stackTrace"];
    
    [answer setObject:@"?" forKey:@"originator"];
    
    CAJsonObject* faultContext = [[CAJsonObject alloc] init];
    [faultContext setObject:[CAExceptionHelper getAtosCommand:exception] forKey:@"atos"];
    [answer setObject:faultContext forKey:@"faultContext"];
    
    return answer;

}

+(CABaseException*)toBaseException:(CAJsonObject*)jsonObject {
    
    NSString* originator = [jsonObject stringForKey:@"originator" defaultValue:@"NULL"];
    NSString* fault_string = [jsonObject stringForKey:@"faultMessage" defaultValue:@"NULL"];
    
    CABaseException* answer = [[CABaseException alloc] initWithOriginator:originator faultMessage:fault_string];
    

    {
        NSString* errorDomain = [jsonObject stringForKey:@"errorDomain" defaultValue:nil];
        [answer setErrorDomain:errorDomain];
    }

    int fault_code = [jsonObject intForKey:@"faultCode" defaultValue:[BaseException defaultFaultCode]];
    [answer setFaultCode:fault_code];
    
    NSString* underlyingFaultMessage = [jsonObject stringForKey:@"underlyingFaultMessage" defaultValue:nil];
    [answer setUnderlyingFaultMessage:underlyingFaultMessage];
    
    CAJsonArray* stack_trace = [jsonObject jsonArrayForKey:@"stackTrace" defaultValue:nil];
    if( nil != stack_trace ) {
        for( int i  = 0, count = [stack_trace count]; i < count; i++ ) { 
            NSString* key = [NSString stringWithFormat:@"cause[%d]", i];
            NSString* value = [stack_trace getString:i defaultValue:@"NULL"];
            [answer addStringContext:value withName:key];
        }
    }
    
    CAJsonObject* fault_context = [jsonObject jsonObjectForKey:@"faultContext" defaultValue:nil];
    if( nil != fault_context ) {
        
        NSArray* allKeys = [fault_context allKeys];
        
        for( long i = 0, count = [allKeys count]; i < count; i++ ) {
            NSString* key = [allKeys objectAtIndex:i];
            id value = [fault_context objectForKey:key];
            if( nil != value && [value isKindOfClass:[NSString class]] ) {
                [answer addStringContext:(NSString*)value withName:key];
            }
        }
    }
    return answer;
    
}






         

@end
