//
//  ApplicationObjects.m
//  vlc_amigo
//
//  Created by Richard Long on 15/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "CALog.h"
#import "CALogHelper.h"
#import "CAJsonStringHandler.h"


#import "HLCommonObjects.h"


@implementation HLCommonObjects  {
    
}


static HLLocalStorage* _localStorage = nil;
static CASimpleLogConsumer* _logConsumer= nil;
static HLSecurityConfiguration* _securityConfiguration = nil;



+(void)initialize {
}




+(HLLocalStorage*)localStorage {
    
    return _localStorage;
    
}


+(CASimpleLogConsumer*)getLogConsumer {
    return _logConsumer;
}

+(void)setLogConsumer:(CASimpleLogConsumer*)logConsumer {
    
    _logConsumer = logConsumer;
    
}





+(HLSecurityConfiguration*)securityConfiguration {
    
    return _securityConfiguration;
    
}

+(void)setSecurityConfiguration:(HLSecurityConfiguration*)securityConfiguration {
    
    
    _securityConfiguration = securityConfiguration;
    
    
    
}



+(void)setup {
    
    Log_enteredMethod();

    {
        
        CASimpleLogConsumer* logConsumer = [CALogHelper setupSimpleLogConsumer];
        [self setLogConsumer:logConsumer];
    }
    
    
    _localStorage = [[HLLocalStorage alloc] init];
//    [_localStorage setup];
}



@end
