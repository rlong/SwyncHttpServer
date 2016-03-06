//
//  UriUtilities.m
//  remote_gateway
//
//  Created by Richard Long on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HLFilePathUtilities.h"
#import "HLUriUtilities.h"


@implementation HLUriUtilities

static NSString* _URI = @"uri"; 


+(NSString*)URI {
    return _URI;
}


+(NSString*)convertPathToUri:(NSString*)path {
    
    
    // vvv http://stackoverflow.com/questions/5695344/how-to-convert-a-path-in-nsstring-to-cfurlref-and-to-fsref
    
    NSURL* url = [NSURL fileURLWithPath:path];
    
    // ^^^ http://stackoverflow.com/questions/5695344/how-to-convert-a-path-in-nsstring-to-cfurlref-and-to-fsref
    
    // vvv http://stackoverflow.com/questions/8867554/how-to-convert-nsurl-to-nsstring
    
    NSString* answer = [url absoluteString];
    
    // ^^^ http://stackoverflow.com/questions/8867554/how-to-convert-nsurl-to-nsstring

    return answer;
    
}

+(NSString*)getFileUri:(JBJsonObject*)jsonObject {
    
    NSString* answer = [jsonObject stringForKey:_URI defaultValue:nil];
    
    if( nil != answer ) { 
        return answer;
    }
    
    NSString* filePath = [jsonObject stringForKey:[HLFilePathUtilities FILE_PATH] defaultValue:nil];
    if( nil != filePath ) { 
        
        return [self convertPathToUri:filePath];
        
    }
    
    NSString* parentFolderPath = [jsonObject stringForKey:[HLFilePathUtilities PARENT_FOLDER_PATH]];
    NSString* fileName = [jsonObject stringForKey:[HLFilePathUtilities FILE_NAME]];
    
    filePath = [NSString stringWithFormat:@"%@/%@", parentFolderPath, fileName];
    return [self convertPathToUri:filePath];
    
    
    
}

@end
