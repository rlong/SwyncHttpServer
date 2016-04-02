//
//  AAFileUploadProcessor.h
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLRequestHandler.h"
#import "HLStorageManager.h"


@interface HLBlueImpPostFileRequestHandler : NSObject <HLRequestHandler> {
    
    // storageManager
    id<HLStorageManager> _storageManager;
    //@property (nonatomic, retain) id<AVStorageManager> storageManager;
    //@synthesize storageManager = _storageManager;

    
    


}


//-(void)setIsEnabled:(bool)isEnabled;

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStorageManager:(id<HLStorageManager>)storageManager;

@end
