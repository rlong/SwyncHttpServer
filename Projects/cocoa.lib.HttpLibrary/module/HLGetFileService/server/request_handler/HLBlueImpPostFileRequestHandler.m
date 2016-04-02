//
//  AAFileUploadProcessor.m
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//



#import "CABaseException.h"
#import "CALog.h"
#import "CAStringHelper.h"
#import "CAJsonObject.h"
#import "CAJsonObjectHandler.h"
#import "CAJsonStringOutput.h"



#import "HLHttpErrorHelper.h"
#import "HLBlueImpPostFileRequestHandler.h"
#import "HLHostnameUtilities.h"
#import "HLPostFileMultiPartHandler.h"
#import "HLPostFilePartHandler.h"
#import "HLDataEntity.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLHttpStatus.h"
#import "HLMediaType.h"
#import "HLMultiPartReader.h"

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
#pragma mark <HLRequestHandler> implementation



-(NSString*)getProcessorUri {
    return @"/_dynamic_/av_amigo/BlueImpPostFile";
}



// see https://github.com/blueimp/jQuery-File-Upload/wiki/Setup
-(HLHttpResponse*)buildResponse:(HLPostFileMultiPartHandler*)fileUploadMultiPartHandler {
    
    
    id<HLEntity> entity;
    {
        CAJsonObject* jsonObject = [[CAJsonObject alloc] init];
        
        
        {
            CAJsonArray* files = [[CAJsonArray alloc] init];
            {
                [jsonObject setObject:files forKey:@"files"];
            }
            
            if( nil != fileUploadMultiPartHandler ) {
                NSArray* fileUploadPartHandlers = [fileUploadMultiPartHandler fileUploadPartHandlers];
                for( HLPostFilePartHandler* fileUploadPartHandler in fileUploadPartHandlers ) {
                    if( nil != [fileUploadPartHandler fileName] ) {
                        CAJsonObject* file = [[CAJsonObject alloc] init];
                        
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
                CAJsonObject* file = [[CAJsonObject alloc] init];
                {
                    [file setObject:@".meta.27579356-B35F-4342-BC7E-121ABE6FEA95" forKey:@"name"];
                    [file setLongLong:[_storageManager getFreeSpace] forKey:@"freeSpace"];
                    [file setObject:[HLHostnameUtilities getHostName] forKey:@"hostName"];
                    [files add:file];
                }
                
            }
        }
        
        // vvv derived from [Serializer serialize:]
        CAJsonStringOutput* writer = [[CAJsonStringOutput alloc] init];
        {
            CAJsonObjectHandler* jsonObjectHandler = [CAJsonObjectHandler getInstance];
            [jsonObjectHandler writeValue:jsonObject writer:writer];
            
            NSString* jsonString = [writer toString];
            Log_debugString(jsonString);
            
            NSData* data = [CAStringHelper toUtf8Data:jsonString];
            
            entity = [[HLDataEntity alloc] initWithData:data];
        }

        // ^^^ derived from [Serializer serialize:]

        
    }
    
    HLHttpResponse* answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200  entity:entity];

    return answer;
}


+(NSString*)getBoundaryFromRequest:(HLHttpRequest*)request {
    
    NSString* mediaTypeString = [request getHttpHeader:@"content-type"];
    
    if( nil == mediaTypeString ) {
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"nil == mediaTypeString"];
    }
    HLMediaType* mediaType = [HLMediaType buildFromString:mediaTypeString];
    
    NSString* answer = [mediaType getParameterValue:@"boundary" defaultValue:nil];
    
    if( nil == answer ) {
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"nil == answer; mediaTypeString = '%@'", mediaTypeString];
    }
    
    return answer;
    
}

-(HLHttpResponse*)processPost:(HLHttpRequest*)request {
    
    NSString* boundary = [HLBlueImpPostFileRequestHandler getBoundaryFromRequest:request];

    HLPostFileMultiPartHandler* multiPartHandler = [[HLPostFileMultiPartHandler alloc] initWithStorageManager:_storageManager];
    HLMultiPartReader* multiPartReader = [[HLMultiPartReader alloc] initWithBoundary:boundary entity:[request entity]];
    
    [multiPartReader process:multiPartHandler skipFirstCrNl:true];

    return [self buildResponse:multiPartHandler];
    
}

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    Log_enteredMethod();
    
//    if( !_isEnabled ) {
//        @throw  [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
//    }
    
    if( [HLHttpMethod POST] == [request method]) {
        return [self processPost:request];
    } else if( [HLHttpMethod GET] == [request method] ) {
        return [self buildResponse:nil];
    }
    
    @throw [HLHttpErrorHelper notImplemented501FromOriginator:self line:__LINE__];
    
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
