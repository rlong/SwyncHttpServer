//
//  AAFileUploadProcessor.m
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//




#import "JBHttpErrorHelper.h"

#import "HLBlueImpPostFileRequestHandler.h"
#import "HLHostnameUtilities.h"
#import "HLPostFileMultiPartHandler.h"
#import "HLPostFilePartHandler.h"

#import "JBBaseException.h"
#import "JBDataEntity.h"
#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBHttpStatus.h"
#import "JBJsonObject.h"
#import "JBJsonObjectHandler.h"
#import "JBJsonStringOutput.h"
#import "JBLog.h"
#import "JBMediaType.h"
#import "JBMultiPartReader.h"
#import "JBStringHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLBlueImpPostFileRequestHandler ()

// storageManager
//id<AVStorageManager> _storageManager;
@property (nonatomic, retain) id<HLStorageManager> storageManager;
//@synthesize storageManager = _storageManager;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLBlueImpPostFileRequestHandler



//-(void)setIsEnabled:(bool)isEnabled {
//    _isEnabled = isEnabled;
//}

#pragma mark -
#pragma mark <JBRequestHandler> implementation



-(NSString*)getProcessorUri {
    return @"/_dynamic_/av_amigo/BlueImpPostFile";
}



// see https://github.com/blueimp/jQuery-File-Upload/wiki/Setup
-(JBHttpResponse*)buildResponse:(HLPostFileMultiPartHandler*)fileUploadMultiPartHandler {
    
    
    id<JBEntity> entity;
    {
        JBJsonObject* jsonObject = [[JBJsonObject alloc] init];
        
        
        {
            JBJsonArray* files = [[JBJsonArray alloc] init];
            {
                [jsonObject setObject:files forKey:@"files"];
            }
            
            if( nil != fileUploadMultiPartHandler ) {
                NSArray* fileUploadPartHandlers = [fileUploadMultiPartHandler fileUploadPartHandlers];
                for( HLPostFilePartHandler* fileUploadPartHandler in fileUploadPartHandlers ) {
                    if( nil != [fileUploadPartHandler fileName] ) {
                        JBJsonObject* file = [[JBJsonObject alloc] init];
                        
                        {
                            [file setObject:[fileUploadPartHandler fileName] forKey:@"name"];
                            [file setLongLong:[fileUploadPartHandler fileSize] forKey:@"size"];
                            if( nil != [fileUploadPartHandler userError] ) {
                                [file setObject:[fileUploadPartHandler userError] forKey:@"error"];
                            }
                            [files add:file];
                        }
                        
                    }
                }
            }
            
            // BlueImp does not bahave well when `.meta.27579356-B35F-4342-BC7E-121ABE6FEA95` is the first object in the array and `showMetaInformation()` javascript method returns true
            {
                JBJsonObject* file = [[JBJsonObject alloc] init];
                {
                    [file setObject:@".meta.27579356-B35F-4342-BC7E-121ABE6FEA95" forKey:@"name"];
                    [file setLongLong:[_storageManager getFreeSpace] forKey:@"freeSpace"];
                    [file setObject:[HLHostnameUtilities getHostName] forKey:@"hostName"];
                    [files add:file];
                }
                
            }
        }
        
        // vvv derived from [Serializer serialize:]
        JBJsonStringOutput* writer = [[JBJsonStringOutput alloc] init];
        {
            JBJsonObjectHandler* jsonObjectHandler = [JBJsonObjectHandler getInstance];
            [jsonObjectHandler writeValue:jsonObject writer:writer];
            
            NSString* jsonString = [writer toString];
            Log_debugString(jsonString);
            
            NSData* data = [JBStringHelper toUtf8Data:jsonString];
            
            entity = [[JBDataEntity alloc] initWithData:data];
        }

        // ^^^ derived from [Serializer serialize:]

        
    }
    
    JBHttpResponse* answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_OK_200  entity:entity];

    return answer;
}


+(NSString*)getBoundaryFromRequest:(JBHttpRequest*)request {
    
    NSString* mediaTypeString = [request getHttpHeader:@"content-type"];
    
    if( nil == mediaTypeString ) {
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"nil == mediaTypeString"];
    }
    JBMediaType* mediaType = [JBMediaType buildFromString:mediaTypeString];
    
    NSString* answer = [mediaType getParameterValue:@"boundary" defaultValue:nil];
    
    if( nil == answer ) {
        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"nil == answer; mediaTypeString = '%@'", mediaTypeString];
    }
    
    return answer;
    
}

-(JBHttpResponse*)processPost:(JBHttpRequest*)request {
    
    NSString* boundary = [HLBlueImpPostFileRequestHandler getBoundaryFromRequest:request];

    HLPostFileMultiPartHandler* multiPartHandler = [[HLPostFileMultiPartHandler alloc] initWithStorageManager:_storageManager];
    JBMultiPartReader* multiPartReader = [[JBMultiPartReader alloc] initWithBoundary:boundary entity:[request entity]];
    
    [multiPartReader process:multiPartHandler skipFirstCrNl:true];

    return [self buildResponse:multiPartHandler];
    
}

-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    Log_enteredMethod();
    
//    if( !_isEnabled ) {
//        @throw  [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
//    }
    
    if( [JBHttpMethod POST] == [request method]) {
        return [self processPost:request];
    } else if( [JBHttpMethod GET] == [request method] ) {
        return [self buildResponse:nil];
    }
    
    @throw [JBHttpErrorHelper notImplemented501FromOriginator:self line:__LINE__];
    
}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStorageManager:(id<HLStorageManager>)storageManager  {

    HLBlueImpPostFileRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setStorageManager:storageManager];
    }
    
    return answer;
    
}

-(void)dealloc {
	
    [self setStorageManager:nil];

	
}

#pragma mark -
#pragma mark fields


// storageManager
//id<AVStorageManager> _storageManager;
//@property (nonatomic, retain) id<AVStorageManager> storageManager;
@synthesize storageManager = _storageManager;



@end
