//
//  AVFileDownloadRequestHandler2.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "CAFile.h"
#import "CALog.h"
#import "CAStringHelper.h"

#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLRequestHandler.h"
#import "HLFileMediaHandle.h"
#import "HLFileDownloadRequestHandler.h"
#import "HLCommonObjects.h"
#import "HLLocalStorage.h"
#import "HLMediaHandle.h"
#import "HLMediaHandleSet.h"
#import "HLStreamEntity.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLFileDownloadRequestHandler ()

// requestHandlerUrl
//NSString* _requestHandlerUrl;
@property (nonatomic, retain) NSString* requestHandlerUrl;
//@synthesize requestHandlerUrl = _requestHandlerUrl;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLFileDownloadRequestHandler


static NSString* _URI = @"/_dynamic_/HLFileDownloadRequestHandler/";


#pragma mark - instance lifecycle

-(id)init;
{
    
    return [self initWithRequestHandlerUrl:_URI];
    
}


-(id)initWithRequestHandlerUrl:(NSString*)requestHandlerUrl;
{
    
    HLFileDownloadRequestHandler* answer = [super init];
    
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
    
    id<HLEntity> entity;
    NSString* filename;
    {
        
        NSInteger fromIndex = [_URI length] -1;
        NSString* encodedPath = [uri substringFromIndex:fromIndex];
        NSString* path = [CAStringHelper decodeURIComponent:encodedPath];
        Log_debugString( path );
        
        CAFile* file = [[CAFile alloc] initWithPathname:path];
        
        if( ![file exists] ) {
            @throw [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
        }
        
        NSURL* contentSource = [[NSURL alloc] initFileURLWithPath:[file getAbsolutePath]];
        unsigned long long contentLength = [file length];
        NSString* mimeType = @"text/plain"; 
        
        entity = [[HLStreamEntity alloc] initWithContentSource:contentSource contentLength:contentLength mimeType:mimeType];
        filename = [file getName];

    }
    
    
    HLHttpResponse* answer;
    {
        HLRange* range = [request range];
        if( nil == range ) {
            
            answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:entity];
        } else {
            
            answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_PARTIAL_CONTENT_206 entity:entity];
            [answer setRange:range];
        }
        
    }

    
    
    // vvv http://stackoverflow.com/questions/3651093/link-to-download-image-instead-of-view-image
    {
        
        NSString* contentDisposition = [NSString stringWithFormat:@"attachment; filename=\"%@\"", filename];
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
