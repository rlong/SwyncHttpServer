//
//  AVHostnameUtilities.m
//  av_amigo
//
//  Created by rlong on 8/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//



#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)

#else

#include <UIKit/UIKit.h> // for 'UIDevice' below

#endif

#import "XPHostnameUtilities.h"

#import "JBLog.h"

@implementation XPHostnameUtilities

// vvv scraped from [AboutService getHostName]


+(NSString*)getHostName {
    
    NSString* answer= nil;
    
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    
    // vvv http://stackoverflow.com/questions/4063129/get-computer-name-on-mac
    
    answer = [[NSHost currentHost] localizedName];
    
    // ^^^ http://stackoverflow.com/questions/4063129/get-computer-name-on-mac
    
#else
    
    answer = [[UIDevice currentDevice] name];
    
#endif
    
    Log_debugString( answer );
    
    return answer;
    
}

// ^^^ scraped from [AboutService getHostName]

@end
