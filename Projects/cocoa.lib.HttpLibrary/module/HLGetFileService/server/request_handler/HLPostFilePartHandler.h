//
//  AAFileUploadPartHandler.h
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "HLContentDisposition.h"
#import "HLMediaType.h"
#import "HLPartHandler.h"
#import "HLStorageManager.h"


@interface HLPostFilePartHandler : NSObject <HLPartHandler> {

    
    // storageManager
    id<HLStorageManager> _storageManager;
    //@property (nonatomic, retain) id<AVStorageManager> storageManager;
    //@synthesize storageManager = _storageManager;
    
    // contentType
    HLMediaType* _contentType;
    //@property (nonatomic, retain) HLMediaType* contentType;
    //@synthesize contentType = _contentType;

    // fileStream
    NSOutputStream* _fileStream;
    //@property (nonatomic, retain) NSOutputStream* fileStream;
    //@synthesize fileStream = _fileStream;
    
    // timeAtLastHeader
    NSDate* _timeAtLastHeader;
    //@property (nonatomic, retain) NSDate* timeAtLastHeader;
    //@synthesize timeAtLastHeader = _timeAtLastHeader;


    // fileName
    NSString* _fileName;
    //@property (nonatomic, retain) NSString* fileName;
    //@synthesize fileName = _fileName;

    long long _fileSize;
    
    bool _hasPartCompleted;
    

    // userError
    NSString* _userError;
    //@property (nonatomic, retain) NSString* userError;
    //@synthesize userError = _userError;

    
    
}


-(long long)fileSize;

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStorageManager:(id<HLStorageManager>)storageManager;


#pragma mark -
#pragma mark fields


// fileName
//NSString* _fileName;
@property (nonatomic, retain) NSString* fileName;
//@synthesize fileName = _fileName;


// userError
//NSString* _userError;
@property (nonatomic, retain) NSString* userError;
//@synthesize userError = _userError;


@end
