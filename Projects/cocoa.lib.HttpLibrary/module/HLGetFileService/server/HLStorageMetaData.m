//
//  AVFileContentTypeHelper.m
//  av_amigo
//
//  Created by rlong on 15/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//


#import "CAFolderUtilities.h"
#import "CAJsonObject.h"
#import "CALog.h"

#import "HLConfigurationService.h"


#import "HLStorageMetaData.h"

@implementation HLStorageMetaData




static HLConfigurationService* _configService = nil;




+(HLConfigurationService*)getConfigService {
    
    if( nil == _configService ) {
        
        NSString* libraryDirectory = [CAFolderUtilities getLibraryDirectory];
        NSString* configServiceDirectory = [libraryDirectory stringByAppendingString:@"/HLStorageMetaData"];
        Log_debugString( configServiceDirectory );
        _configService = [[HLConfigurationService alloc ] initWithRootFolder:configServiceDirectory];
    }
    
    
    
    return _configService;
    
    
    
}



// will return nil, if not entry is found
+(NSString*)getContentTypeForFilename:(NSString*)filename {
    

    HLConfigurationService* configService = [self getConfigService];
    CAJsonObject* configBundle = [configService getBundle:@"HLStorageMetaData"];
    if( nil == configBundle ) {
        return nil;
    }
    
    NSString* answer = [configBundle stringForKey:filename defaultValue:nil];
    return answer;
    
    
}



+(void)saveContentType:(NSString*)contentType forFilename:(NSString*)filename {

    HLConfigurationService* configService = [self getConfigService];
    CAJsonObject* configBundle = [configService getBundle:@"HLStorageMetaData"];
    if( nil == configBundle ) {
        configBundle = [[CAJsonObject alloc] init];
        [configService set_bundle:@"HLStorageMetaData" bundle:configBundle];
    }
    
    [configBundle setObject:contentType forKey:filename];
    [configService saveAllBundles];

    
}


@end
