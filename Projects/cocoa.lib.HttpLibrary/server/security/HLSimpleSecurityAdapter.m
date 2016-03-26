//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"
#import "CASecurityUtilities.h"

#import "HLSimpleSecurityAdapter.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLSimpleSecurityAdapter () 


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation HLSimpleSecurityAdapter


+(NSString*)BUNDLE_NAME {
    
    return @"jsonbroker.SecurityConfiguration";
    
}


#pragma mark <IdentifierProvider> implementation 

-(NSString*)getIdentifier {
    
    NSString* answer = [CASecurityUtilities generateNonce];
    Log_debugString( answer );
    return answer;
    
}

#pragma mark instance lifecycle


#pragma mark fields


@end
