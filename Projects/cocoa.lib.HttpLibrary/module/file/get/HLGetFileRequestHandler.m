//
//  AVFileDownloadRequestHandler2.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//


#import "JBHttpErrorHelper.h"
#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBLog.h"


#import "HLGetFileRequestHandler.h"
#import "VPLocalStorage.h"
#import "HLCommonObjects.h"
#import "VPMediaHandle.h"
#import "VPMediaHandleSet.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLGetFileRequestHandler ()

// requestHandlerUrl
//NSString* _requestHandlerUrl;
@property (nonatomic, retain) NSString* requestHandlerUrl;
//@synthesize requestHandlerUrl = _requestHandlerUrl;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLGetFileRequestHandler


static NSString* _URI = @"/_dynamic_/av_amigo/GetFile";

+(NSString*)REQUEST_HANDLER_URI {
    
    return _URI;
    
}

#pragma mark -
#pragma mark <JBRequestHandler> implementation


-(JBHttpResponse*)processGet:(JBHttpRequest*)request {
    
    
    NSString* uri = [request requestUri];
    Log_debugString( uri );
    
    
    
    VPLocalStorage* localStorage = [HLCommonObjects localStorage];
    VPMediaHandleSet* mediaHandles = [localStorage toMediaHandleSet];

    
    id<VPMediaHandle> mediaHandle = [mediaHandles getHandleWithUri:uri];
    if( nil == mediaHandle ) {
        Log_errorFormat(@"nil == mediaHandle; uri = '%@'", uri);
        @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
    }

    id<JBEntity> entity = [mediaHandle toEntity];
    
//    if( nil != _getFileListener ) {
//        
//        HLGetFileEntityWrapper* entityWrapper = [[HLGetFileEntityWrapper alloc] initWithDelegate:entity getFileListener:_getFileListener];
//        [entityWrapper autorelease];
//        entity = entityWrapper;
//        
//    }
    
    JBHttpResponse* answer;

    JBRange* range = [request range];
    if( nil == range ) {
        
        answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:entity];
    } else {
        
        answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_PARTIAL_CONTENT_206 entity:entity];
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

-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    Log_enteredMethod();
    
    
    if( [JBHttpMethod GET] == [request method] ) {
        return [self processGet:request];
    }
    
    @throw [JBHttpErrorHelper notImplemented501FromOriginator:self line:__LINE__];
    
}


-(NSString*)getProcessorUri {
    
    return _requestHandlerUrl;
    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    return [self initWithRequestHandlerUrl:_URI];
    
}


-(id)initWithRequestHandlerUrl:(NSString*)requestHandlerUrl {

    HLGetFileRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        
//        answer->_mediaHandles = [[HLMediaHandleSet alloc] init];
        [answer setRequestHandlerUrl:requestHandlerUrl];
        
    }
    
    return answer;

}


-(void)dealloc {
	
//	[self setMediaHandles:nil];
    [self setRequestHandlerUrl:nil];
//	[self setGetFileListener:nil];

	
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
