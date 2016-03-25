//
//  AVFileDownloadRequestHandler2.h
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "JBRequestHandler.h"

@interface HLSimpleGetFileRequestHandler : NSObject <JBRequestHandler> {
    
    
    // requestHandlerUrl
    NSString* _requestHandlerUrl;
    //@property (nonatomic, retain) NSString* requestHandlerUrl;
    //@synthesize requestHandlerUrl = _requestHandlerUrl;
    


    
}



+(NSString*)REQUEST_HANDLER_URI;


#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithRequestHandlerUrl:(NSString*)requestHandlerUrl;


#pragma mark -
#pragma mark fields

//
//// mediaHandles
////AVMediaHandleSet* _mediaHandles;
//@property (nonatomic, retain) HLMediaHandleSet* mediaHandles;
////@synthesize mediaHandles = _mediaHandles;
//
//
//// getFileListener
////id<AVGetFileListener> _getFileListener;
//@property (nonatomic, retain) id<HLGetFileListener> getFileListener;
////@synthesize getFileListener = _getFileListener;
//


@end
