//
//  ApplicationObjects.h
//  vlc_amigo
//
//  Created by Richard Long on 15/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XPRootViewController.h"
#import "XPScreenStack.h"

#import "JBConfigurationService.h"
#import "JBSecurityConfiguration.h"
#import "JBSimpleLogConsumer.h"

#import "VPLocalStorage.h"


@interface VACommonObjects : NSObject {
    
}


+(VPLocalStorage*)localStorage;


+(JBSimpleLogConsumer*)getLogConsumer;
+(void)setLogConsumer:(JBSimpleLogConsumer*)logConsumer;


+(JBSecurityConfiguration*)securityConfiguration;
+(void)setSecurityConfiguration:(JBSecurityConfiguration*)securityConfiguration;



+(void)setup;


@end
