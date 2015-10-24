//
//  AVGetFilesForDownloadJob.h
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XPGetFileProxy.h"
#import "JBJob.h"

@interface XPGetFilesForDownloadJob : NSObject <JBJob> {
    
    
    // getFileProxy
    XPGetFileProxy* _getFileProxy;
    //@property (nonatomic, retain) AVGetFileProxy* getFileProxy;
    //@synthesize getFileProxy = _getFileProxy;
    
    
    
    // remoteFileReferences
    NSArray* _remoteFileReferences;
    //@property (nonatomic, readonly) NSArray* remoteFileReferences;
    //@property (nonatomic, retain, readwrite) NSArray* remoteFileReferences;
    //@synthesize remoteFileReferences = _remoteFileReferences;


}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithGetFileProxy:(XPGetFileProxy*)getFileProxy;



#pragma mark -
#pragma mark fields

// remoteFileReferences
//NSArray* _remoteFileReferences;
@property (nonatomic, readonly) NSArray* remoteFileReferences;
//@property (nonatomic, retain, readwrite) NSArray* remoteFileReferences;
//@synthesize remoteFileReferences = _remoteFileReferences;

@end
