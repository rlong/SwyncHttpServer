//
//  PullFile.h
//  remote_gateway
//
//  Created by Richard Long on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAFile.h"

#import "FileTransactionDelegate.h"

@interface HLPullFile : NSObject <FileTransactionDelegate> {

    // target
    CAFile* _target;
    //@property (nonatomic, retain) HLFile* target;
    //@synthesize target = _target;

}


-(long long)getFileLength;


#pragma mark instance lifecycle

-(id)initWithTarget:(CAFile*)target;

@end
