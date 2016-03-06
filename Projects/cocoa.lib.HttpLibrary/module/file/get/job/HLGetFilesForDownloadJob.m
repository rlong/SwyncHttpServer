//
//  AVGetFilesForDownloadJob.m
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "HLGetFilesForDownloadJob.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLGetFilesForDownloadJob ()

// getFileProxy
//AVGetFileProxy* _getFileProxy;
@property (nonatomic, retain) HLGetFileProxy* getFileProxy;
//@synthesize getFileProxy = _getFileProxy;


// remoteFileReferences
//NSArray* _remoteFileReferences;
//@property (nonatomic, readonly) NSArray* remoteFileReferences;
@property (nonatomic, retain, readwrite) NSArray* remoteFileReferences;
//@synthesize remoteFileReferences = _remoteFileReferences;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLGetFilesForDownloadJob



-(void)execute {
    
    NSArray* remoteFileReferences = [_getFileProxy getFilesForDownload];
    [self setRemoteFileReferences:remoteFileReferences];
    
}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithGetFileProxy:(HLGetFileProxy*)getFileProxy {
    
    HLGetFilesForDownloadJob* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setGetFileProxy:getFileProxy];
        
    }
    
    return answer;
}

-(void)dealloc {
	
	[self setGetFileProxy:nil];
    [self setRemoteFileReferences:nil];

	
}


#pragma mark -
#pragma mark fields

// getFileProxy
//AVGetFileProxy* _getFileProxy;
//@property (nonatomic, retain) AVGetFileProxy* getFileProxy;
@synthesize getFileProxy = _getFileProxy;



// remoteFileReferences
//NSArray* _remoteFileReferences;
//@property (nonatomic, readonly) NSArray* remoteFileReferences;
//@property (nonatomic, retain, readwrite) NSArray* remoteFileReferences;
@synthesize remoteFileReferences = _remoteFileReferences;


@end
