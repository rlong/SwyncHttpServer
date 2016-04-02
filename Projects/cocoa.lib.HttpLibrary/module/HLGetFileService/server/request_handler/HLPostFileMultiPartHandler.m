//
//  AAFileUploadMultiPartHandler.m
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "HLPostFileMultiPartHandler.h"
#import "HLPostFilePartHandler.h"


#import "CALog.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLPostFileMultiPartHandler ()

// storageManager
//id<AVStorageManager> _storageManager;
@property (nonatomic, retain) id<HLStorageManager> storageManager;
//@synthesize storageManager = _storageManager;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLPostFileMultiPartHandler


#pragma mark -
#pragma mark <HLMultiPartHandler> implementation


-(id<HLPartHandler>)foundPartDelimiter {
    
    HLPostFilePartHandler* answer = [[HLPostFilePartHandler alloc] initWithStorageManager:_storageManager];
    {
        [_fileUploadPartHandlers addObject:answer];
    }
    
    return answer;
}

-(void)handleExceptionZZZ:(BaseException*)e {
    
    Log_errorException(e);
    
}

-(void)foundCloseDelimiter {
    Log_enteredMethod();
    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStorageManager:(id<HLStorageManager>)storageManager{
    
    HLPostFileMultiPartHandler* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setStorageManager:storageManager];
        answer->_fileUploadPartHandlers = [[NSMutableArray alloc] init];
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setStorageManager:nil];
    [self setFileUploadPartHandlers:nil];

	
}

#pragma mark -
#pragma mark fields

// storageManager
//id<AVStorageManager> _storageManager;
//@property (nonatomic, retain) id<AVStorageManager> storageManager;
@synthesize storageManager = _storageManager;

// fileUploadPartHandlers
//NSMutableArray* _fileUploadPartHandlers;
//@property (nonatomic, retain) NSMutableArray* fileUploadPartHandlers;
@synthesize fileUploadPartHandlers = _fileUploadPartHandlers;



@end
