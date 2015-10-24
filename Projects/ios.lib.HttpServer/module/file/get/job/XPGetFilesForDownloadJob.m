//
//  AVGetFilesForDownloadJob.m
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "XPGetFilesForDownloadJob.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface XPGetFilesForDownloadJob ()

// getFileProxy
//AVGetFileProxy* _getFileProxy;
@property (nonatomic, retain) XPGetFileProxy* getFileProxy;
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

@implementation XPGetFilesForDownloadJob



-(void)execute {
    
    NSArray* remoteFileReferences = [_getFileProxy getFilesForDownload];
    [self setRemoteFileReferences:remoteFileReferences];
    
}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithGetFileProxy:(XPGetFileProxy*)getFileProxy {
    
    XPGetFilesForDownloadJob* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setGetFileProxy:getFileProxy];
        
    }
    
    return answer;
}

-(void)dealloc {
	
	[self setGetFileProxy:nil];
    [self setRemoteFileReferences:nil];

	
	[super dealloc];
	
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
