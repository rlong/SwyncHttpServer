//
//  PushFileJob.h
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "FileTransactionDelegate.h"
#import "CAFile.h"

@interface HLPushFile : NSObject <FileTransactionDelegate> {
    
    
    // target
	CAFile* _target;
	//@property (nonatomic, retain) HLFile* target;
	//@synthesize target = _target;
    
    // partialContent
	CAFile* _partialContent;
	//@property (nonatomic, retain) HLFile* partialContent;
	//@synthesize partialContent = _partialContent;
    
    
    long long _fileLength;


}


-(long long)getFileLength;

-(void)append:(long long)streamLength inputStream:(NSInputStream*)inputStream;

#pragma mark instance lifecycle

-(id)initWithResume:(BOOL)resume filePath:(NSString*)filePath fileLength:(long)fileLength;

@end
