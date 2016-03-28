//
//  ApplicationObjects.h
//  vlc_amigo
//
//  Created by Richard Long on 15/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CASimpleLogConsumer.h"

#import "HLConfigurationService.h"
#import "HLSecurityConfiguration.h"
#import "HLLocalStorage.h"


@interface HLCommonObjects : NSObject {
    
}


+(HLLocalStorage*)localStorage;


+(CASimpleLogConsumer*)getLogConsumer;
+(void)setLogConsumer:(CASimpleLogConsumer*)logConsumer;


+(HLSecurityConfiguration*)securityConfiguration;
+(void)setSecurityConfiguration:(HLSecurityConfiguration*)securityConfiguration;



+(void)setup;


@end
