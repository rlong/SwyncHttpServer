//
//  AVFileDownloadRequestHandler2.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "CAFile.h"
#import "CALog.h"

#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLRequestHandler.h"
#import "HLFileMediaHandle.h"
#import "HLSimpleGetFileRequestHandler.h"
#import "HLCommonObjects.h"
#import "HLLocalStorage.h"
#import "HLMediaHandle.h"
#import "HLMediaHandleSet.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLSimpleGetFileRequestHandler ()

// requestHandlerUrl
//NSString* _requestHandlerUrl;
@property (nonatomic, retain) NSString* requestHandlerUrl;
//@synthesize requestHandlerUrl = _requestHandlerUrl;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLSimpleGetFileRequestHandler


static NSString* _URI = @"/_dynamic_/HLSimpleGetFileRequestHandler/";


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    return [self initWithRequestHandlerUrl:_URI];
    
}


-(id)initWithRequestHandlerUrl:(NSString*)requestHandlerUrl {
    
    HLSimpleGetFileRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setRequestHandlerUrl:requestHandlerUrl];
        
    }
    
    return answer;
    
}


-(void)dealloc {
    
    [self setRequestHandlerUrl:nil];
    
    
}


#pragma mark -



+(NSString*)REQUEST_HANDLER_URI {
    
    return _URI;
    
}

#pragma mark - <HLRequestHandler> implementation


-(HLHttpResponse*)processGet:(HLHttpRequest*)request {
    
    
    NSString* uri = [request requestUri];
    Log_debugString( uri );
    
    HLFileMediaHandle* mediaHandle;
    {
        
        NSInteger fromIndex = [_URI length] -1;
        NSString* applescriptPath = [uri substringFromIndex:fromIndex];
        Log_debugString( applescriptPath );
        
        
        NSString* posixPath = [applescriptPath stringByReplacingOccurrencesOfString:@":" withString:@"/"];
        Log_debugString( posixPath );

        CAFile* file = [[CAFile alloc] initWithPathname:posixPath];
        
        //-(id)initWithContentSource:(NSURL*)contentSource contentLength:(unsigned long long)contentLength mimeType:(NSString*)mimeType filename:(NSString*)filename;
        
        NSURL* contentSource = [[NSURL alloc] initFileURLWithPath:[file getAbsolutePath]];
        unsigned long long contentLength = [file length];
        NSString* mimeType = @"text/plain";
        NSString* filename = [file getName];
            
        mediaHandle = [[HLFileMediaHandle alloc] initWithContentSource:contentSource contentLength:contentLength mimeType:mimeType filename:filename];

    }
    

//    Log_errorFormat(@"nil == mediaHandle; uri = '%@'", uri);
//    @throw [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];

    id<HLEntity> entity = [mediaHandle toEntity];
    
    
    
//    if( nil != _getFileListener ) {
//        
//        HLGetFileEntityWrapper* entityWrapper = [[HLGetFileEntityWrapper alloc] initWithDelegate:entity getFileListener:_getFileListener];
//        [entityWrapper autorelease];
//        entity = entityWrapper;
//        
//    }
    
    HLHttpResponse* answer;

    HLRange* range = [request range];
    if( nil == range ) {
        
        answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:entity];
    } else {
        
        answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_PARTIAL_CONTENT_206 entity:entity];
        [answer setRange:range];
    }
    
    
    // vvv http://stackoverflow.com/questions/3651093/link-to-download-image-instead-of-view-image
    {
        
        NSString* contentDisposition = [NSString stringWithFormat:@"attachment; filename=\"%@\"", [mediaHandle getFilename]];
        [[answer headers] setObject:contentDisposition forKey:@"Content-Disposition"];
        
    }
    // ^^^ http://stackoverflow.com/questions/3651093/link-to-download-image-instead-of-view-image
    
    NSString* contentType = [entity mimeType];
    if( nil != contentType ) {
        [answer setContentType:contentType];
    }
    
    return answer;
}

-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
    
    Log_enteredMethod();
    
    
    if( [HLHttpMethod GET] == [request method] ) {
        return [self processGet:request];
    }
    
    @throw [HLHttpErrorHelper notImplemented501FromOriginator:self line:__LINE__];
    
}


-(NSString*)getProcessorUri {
    
    return _requestHandlerUrl;
    
}



#pragma mark -
#pragma mark fields

//
//// mediaHandles
////AVMediaHandleSet* _mediaHandles;
////@property (nonatomic, retain) AVMediaHandleSet* mediaHandles;
//@synthesize mediaHandles = _mediaHandles;

// requestHandlerUrl
//NSString* _requestHandlerUrl;
//@property (nonatomic, retain) NSString* requestHandlerUrl;
@synthesize requestHandlerUrl = _requestHandlerUrl;

//
//// getFileListener
////id<AVGetFileListener> _getFileListener;
////@property (nonatomic, retain) id<AVGetFileListener> getFileListener;
//@synthesize getFileListener = _getFileListener;

@end
