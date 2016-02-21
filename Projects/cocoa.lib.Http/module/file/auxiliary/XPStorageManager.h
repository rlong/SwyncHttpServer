//
//  AVStorageManager.h
//  av_amigo
//
//  Created by rlong on 8/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPStorageManager <NSObject>



-(BOOL)fileExistsWithName:(NSString*)filename;


-(uint64_t)getFreeSpace;

-(NSInputStream*)inputStreamWithFilename:(NSString*)filename;

-(NSOutputStream*)outputStreamWithFilename:(NSString*)filename append:(BOOL)append;

-(BOOL)removeFileWithName:(NSString*)filename swallowErrors:(BOOL)swallowErrors;

// throws an exception if the file does not exist
-(uint64_t)sizeOfFileWithName:(NSString*)filename;




@end
