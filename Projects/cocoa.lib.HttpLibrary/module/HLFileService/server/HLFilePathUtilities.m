//
//  FilePathUtilities.m
//  remote_gateway
//
//  Created by Richard Long on 19/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CALog.h"

#import "HLFilePathUtilities.h"
#import "HLUriUtilities.h"

@implementation HLFilePathUtilities

static NSString* _PARENT_FOLDER_PATH = @"parentFolderPath"; 
static NSString* _FILE_NAME = @"fileName"; 
static NSString* _FOLDER_NAME = @"folderName"; 

static NSString* _FILE_PATH = @"filePath"; 
static NSString* _FOLDER_PATH = @"folderPath"; 


+(NSString*)PARENT_FOLDER_PATH {
    return _PARENT_FOLDER_PATH;
}


+(NSString*)FILE_NAME {
    return _FILE_NAME;
}

+(NSString*)FOLDER_NAME {
    return _FOLDER_NAME;
}


+(NSString*)FILE_PATH {
    return _FILE_PATH;
}


// can return nil	
+(NSString*)convertUriToLocalPath:(NSString*)uriString {
    
    NSURL* url = [NSURL URLWithString:uriString];
    return [url path];
    
}


// 'filePath' || ('parentFolderPath' && 'fileName')
+(NSString*)getFilePath:(CAJsonObject*)jsonObject {
    
    NSString* answer = [jsonObject stringForKey:_FILE_PATH defaultValue:nil];
    if( nil != answer ) { 
        Log_debugString( answer );
        return answer;
    }
    
    NSString* fileUri = [jsonObject stringForKey:[HLUriUtilities URI] defaultValue:nil];
    if( nil != fileUri ) { 
        return [self convertUriToLocalPath:fileUri];
    }
    
    
    NSString* parentFolderPath = [jsonObject stringForKey:_PARENT_FOLDER_PATH];
    NSString* fileName = [jsonObject stringForKey:_FILE_NAME];
    
    answer = [NSString stringWithFormat:@"%@/%@", parentFolderPath, fileName];
    Log_debugString( answer );
    return answer;
    
}


// 'folderPath' || ('parentFolderPath' && 'folderName')
+(NSString*)getFolderPath:(CAJsonObject*)jsonObject {

    NSString* answer = [jsonObject stringForKey:_FOLDER_PATH defaultValue:nil];
    if( nil != answer ) { 
        Log_debugString( answer );
        return answer;
    }
    
    NSString* fileUri = [jsonObject stringForKey:[HLUriUtilities URI] defaultValue:nil];
    if( nil != fileUri ) { 
        return [self convertUriToLocalPath:fileUri];
    }

    NSString* parentFolderPath = [jsonObject stringForKey:_PARENT_FOLDER_PATH];
    NSString* folderName = [jsonObject stringForKey:_FOLDER_NAME];
    
    answer = [NSString stringWithFormat:@"%@/%@", parentFolderPath, folderName];
    Log_debugString( answer );
    return answer;

    
}

@end
