//
//  AVFileDownloadService2.h
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JBDescribedService.h"

@interface HLGetFileService : NSObject <JBDescribedService> {
    
//    // mediaHandles
//    HLMediaHandleSet* _mediaHandles;
//    //@property (nonatomic, retain) AVMediaHandleSet* mediaHandles;
//    //@synthesize mediaHandles = _mediaHandles;

}

+(NSString*)SERVICE_NAME;

#pragma mark -
#pragma mark fields

//// mediaHandles
////AVMediaHandleSet* _mediaHandles;
//@property (nonatomic, retain) HLMediaHandleSet* mediaHandles;
////@synthesize mediaHandles = _mediaHandles;

@end
