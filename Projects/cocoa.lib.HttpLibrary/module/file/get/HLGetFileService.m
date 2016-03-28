//
//  AVFileDownloadService2.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//





#import "CALog.h"
#import "CAJsonArray.h"
#import "CAJsonObject.h"

#import "HLServiceHelper.h"
#import "HLGetFileRequestHandler.h"
#import "HLGetFileService.h"
#import "HLLocalStorage.h"
#import "HLCommonObjects.h"
#import "HLMediaHandle.h"
#import "HLMediaHandleSet.h"
#import "HLHostnameUtilities.h"

@implementation HLGetFileService


static NSString* _SERVICE_NAME = @"av_amigo.GetFileService";
static HLServiceDescription* _SERVICE_DESCRIPTION = nil;


+(void)initialize {
    
    _SERVICE_DESCRIPTION = [[HLServiceDescription alloc] initWithServiceName:_SERVICE_NAME];
    
}




+(NSString*)SERVICE_NAME {
    return _SERVICE_NAME;
}


-(CAJsonArray*)getFilesForDownload {
    
    
    Log_enteredMethod();
    
    CAJsonArray* answer = [[CAJsonArray alloc] init];
    
    
    HLLocalStorage* localStorage = [HLCommonObjects localStorage];
    HLMediaHandleSet* mediaHandles = [localStorage toMediaHandleSet];
    
    for( NSUInteger i = 0, count = [mediaHandles getHandleCount]; i < count; i++ ) {
        
        id<HLMediaHandle> mediaHandle = [mediaHandles getHandleAtIndex:i];
        
        NSString* filename = [mediaHandle getFilename];
        unsigned long long filesize = [mediaHandle getContentLength];
        NSString* uri = [NSString stringWithFormat:@"%@%@", [HLGetFileRequestHandler REQUEST_HANDLER_URI], [mediaHandle uriSuffix]];
        Log_debugString( uri );
        
        CAJsonObject* file = [[CAJsonObject alloc] init];
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


-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
    
    NSString* methodName = [request methodName];
    
    if( [@"getFilesForDownload" isEqualToString:methodName] ) {
        
        
        HLBrokerMessage* response = [HLBrokerMessage buildResponse:request];
        CAJsonObject* associativeParamaters = [response associativeParamaters];
        
        [associativeParamaters setObject:[HLHostnameUtilities getHostName] forKey:@"hostName"];
        
        CAJsonArray* files = [self getFilesForDownload];
        [associativeParamaters setObject:files forKey:@"files"];
        
        
        return response;
        
        
    }
    
    @throw [HLServiceHelper methodNotFound:self request:request];
    
}


-(HLServiceDescription*)serviceDescription {
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
