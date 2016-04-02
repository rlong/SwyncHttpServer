//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CAKeychainUtilities.h"
#import "CALog.h"
#import "CASecurityUtilities.h"


#import "HLKeychainSecurityAdapter.h"

@implementation HLKeychainSecurityAdapter

#pragma mark <SecurityAdapter> implementation 


-(NSString*)getIdentifier {
    
    // can return nil
    NSString* savedUsername = [CAKeychainUtilities getSavedUsername];
    Log_debugString( savedUsername );
    
    if( nil != savedUsername ) {
        
        // vvv pairing in production is setting up the user as 'test' (ref: 477550FB-3656-4014-B4D7-DC49821E0BA6)
        // fixed in "VLC Pal" 4.2.0
        // see SecurityConfiguration, KeychainSecurityAdapter
        
        if( [@"test" isEqualToString:savedUsername] ) {
            
            Log_warnString( savedUsername );
            
            NSString* answer = [CASecurityUtilities generateNonce];
            Log_debugString( answer );
            
            return answer;
        }
        
        // ^^^ pairing in production is setting up the user as 'test' (ref: 477550FB-3656-4014-B4D7-DC49821E0BA6)

        return savedUsername;
    }
    
    NSString* answer = [CASecurityUtilities generateNonce];
    Log_debugString( answer );
    return answer;
    
}


-(void)setIdentifier:(NSString*)identifier subjectIdentifier:(NSString*)subjectIdentifier password:(NSString*)password label:(NSString*)subjectLabel {
    
    Log_enteredMethod();
    
    
}

@end
