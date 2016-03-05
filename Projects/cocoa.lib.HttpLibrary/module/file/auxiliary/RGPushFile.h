//
//  PushFileJob.h
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FileTransactionDelegate.h"
#import "HLFile.h"

@interface RGPushFile : NSObject <FileTransactionDelegate> {
    
    
    // target
	HLFile* _target;
	//@property (nonatomic, retain) RGFile* target;
	//@synthesize target = _target;
    
    // partialContent
	HLFile* _partialContent;
	//@property (nonatomic, retain) RGFile* partialContent;
	//@synthesize partialContent = _partialContent;
    
    
    long long _fileLength;


}


-(long long)getFileLength;

-(void)append:(long long)streamLength inputStream:(NSInputStream*)inputStream;

#pragma mark instance lifecycle

-(id)initWithResume:(BOOL)resume filePath:(NSString*)filePath fileLength:(long)fileLength;

@end
