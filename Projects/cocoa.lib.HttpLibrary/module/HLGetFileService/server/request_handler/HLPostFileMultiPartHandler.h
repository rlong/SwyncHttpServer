//
//  AAFileUploadMultiPartHandler.h
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLStorageManager.h"


#import "HLMultiPartHandler.h"

@interface HLPostFileMultiPartHandler : NSObject <HLMultiPartHandler>{
    
    
    // storageManager
    id<HLStorageManager> _storageManager;
    //@property (nonatomic, retain) id<AVStorageManager> storageManager;
    //@synthesize storageManager = _storageManager;
    
    // fileUploadPartHandlers
    NSMutableArray* _fileUploadPartHandlers;
    //@property (nonatomic, retain) NSMutableArray* fileUploadPartHandlers;
    //@synthesize fileUploadPartHandlers = _fileUploadPartHandlers;
    


}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStorageManager:(id<HLStorageManager>)storageManager;


// fileUploadPartHandlers
//NSMutableArray* _fileUploadPartHandlers;
@property (nonatomic, retain) NSArray* fileUploadPartHandlers;
//@synthesize fileUploadPartHandlers = _fileUploadPartHandlers;


@end
