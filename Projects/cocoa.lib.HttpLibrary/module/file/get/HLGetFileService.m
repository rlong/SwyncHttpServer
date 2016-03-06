//
//  AVFileDownloadService2.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//





#import "JBLog.h"
#import "JBServiceHelper.h"


#import "HLGetFileRequestHandler.h"
#import "HLGetFileService.h"
#import "VPLocalStorage.h"
#import "HLCommonObjects.h"
#import "VPMediaHandle.h"
#import "VPMediaHandleSet.h"
#import "HLHostnameUtilities.h"

@implementation HLGetFileService


static NSString* _SERVICE_NAME = @"av_amigo.GetFileService";
static JBServiceDescription* _SERVICE_DESCRIPTION = nil;


+(void)initialize {
    
    _SERVICE_DESCRIPTION = [[JBServiceDescription alloc] initWithServiceName:_SERVICE_NAME];
    
}




+(NSString*)SERVICE_NAME {
    return _SERVICE_NAME;
}


-(JBJsonArray*)getFilesForDownload {
    
    
    Log_enteredMethod();
    
    JBJsonArray* answer = [[JBJsonArray alloc] init];
    
    
    VPLocalStorage* localStorage = [HLCommonObjects localStorage];
    VPMediaHandleSet* mediaHandles = [localStorage toMediaHandleSet];
    
    for( NSUInteger i = 0, count = [mediaHandles getHandleCount]; i < count; i++ ) {
        
        id<VPMediaHandle> mediaHandle = [mediaHandles getHandleAtIndex:i];
        
        NSString* filename = [mediaHandle getFilename];
        unsigned long long filesize = [mediaHandle getContentLength];
        NSString* uri = [NSString stringWithFormat:@"%@%@", [HLGetFileRequestHandler REQUEST_HANDLER_URI], [mediaHandle uriSuffix]];
        Log_debugString( uri );
        
        JBJsonObject* file = [[JBJsonObject alloc] init];
        {
            [file setObject:filename forKey:@"filename"];
            [file setUnsignedLongLong:filesize forKey:@"filesize"];
            [file setObject:[mediaHandle getMimeType] forKey:@"mimeType"];
            
            [file setObject:uri forKey:@"uri"];
            [answer add:file];
        }
        
    }
    
    return answer;
    
}

#pragma mark -
#pragma mark <DescribedService> implementation


-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
    
    NSString* methodName = [request methodName];
    
    if( [@"getFilesForDownload" isEqualToString:methodName] ) {
        
        
        JBBrokerMessage* response = [JBBrokerMessage buildResponse:request];
        JBJsonObject* associativeParamaters = [response associativeParamaters];
        
        [associativeParamaters setObject:[HLHostnameUtilities getHostName] forKey:@"hostName"];
        
        JBJsonArray* files = [self getFilesForDownload];
        [associativeParamaters setObject:files forKey:@"files"];
        
        
        return response;
        
        
    }
    
    @throw [JBServiceHelper methodNotFound:self request:request];
    
}


-(JBServiceDescription*)serviceDescription {
    return _SERVICE_DESCRIPTION;
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    HLGetFileService* answer = [super init];
    
//    if( nil != answer ) {
//        
//        answer->_mediaHandles = [[HLMediaHandleSet alloc] init];
//        
//    }
    
    return answer;
    
}


-(void)dealloc {
	
	
}

#pragma mark -
#pragma mark fields

//
//// mediaHandles
////AVMediaHandleSet* _mediaHandles;
////@property (nonatomic, retain) AVMediaHandleSet* mediaHandles;
//@synthesize mediaHandles = _mediaHandles;


@end
