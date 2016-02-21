//
//  AAFileUploadMultiPartHandler.m
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "XPPostFileMultiPartHandler.h"
#import "XPPostFilePartHandler.h"


#import "JBLog.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface XPPostFileMultiPartHandler ()

// storageManager
//id<AVStorageManager> _storageManager;
@property (nonatomic, retain) id<XPStorageManager> storageManager;
//@synthesize storageManager = _storageManager;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation XPPostFileMultiPartHandler


#pragma mark -
#pragma mark <JBMultiPartHandler> implementation


-(id<JBPartHandler>)foundPartDelimiter {
    
    XPPostFilePartHandler* answer = [[XPPostFilePartHandler alloc] initWithStorageManager:_storageManager];
    {
        [_fileUploadPartHandlers addObject:answer];
    }
    [answer release];
    
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

-(id)initWithStorageManager:(id<XPStorageManager>)storageManager{
    
    XPPostFileMultiPartHandler* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setStorageManager:storageManager];
        answer->_fileUploadPartHandlers = [[NSMutableArray alloc] init];
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setStorageManager:nil];
    [self setFileUploadPartHandlers:nil];

	[super dealloc];
	
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
