//
//  AVFileContentTypeHelper.m
//  av_amigo
//
//  Created by rlong on 15/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//


#import "JBConfigurationService.h"
#import "JBFolderUtilities.h"
#import "JBJsonObject.h"
#import "JBLog.h"
#import "JBMemoryModel.h"


#import "HLStorageMetaData.h"

@implementation HLStorageMetaData




static JBConfigurationService* _configService = nil;




+(JBConfigurationService*)getConfigService {
    
    if( nil == _configService ) {
        
        NSString* libraryDirectory = [JBFolderUtilities getLibraryDirectory];
        NSString* configServiceDirectory = [libraryDirectory stringByAppendingString:@"/HLStorageMetaData"];
        Log_debugString( configServiceDirectory );
        _configService = [[JBConfigurationService alloc ] initWithRootFolder:configServiceDirectory];
    }
    
    
    
    return _configService;
    
    
    
}



// will return nil, if not entry is found
+(NSString*)getContentTypeForFilename:(NSString*)filename {
    

    JBConfigurationService* configService = [self getConfigService];
    JBJsonObject* configBundle = [configService getBundle:@"HLStorageMetaData"];
    if( nil == configBundle ) {
        return nil;
    }
    
    NSString* answer = [configBundle stringForKey:filename defaultValue:nil];
    return answer;
    
    
}



+(void)saveContentType:(NSString*)contentType forFilename:(NSString*)filename {

    JBConfigurationService* configService = [self getConfigService];
    JBJsonObject* configBundle = [configService getBundle:@"HLStorageMetaData"];
    if( nil == configBundle ) {
        configBundle = [[JBJsonObject alloc] init];
        [configService set_bundle:@"HLStorageMetaData" bundle:configBundle];
        JBRelease( configBundle );
    }
    
    [configBundle setObject:contentType forKey:filename];
    [configService saveAllBundles];

    
}


@end
