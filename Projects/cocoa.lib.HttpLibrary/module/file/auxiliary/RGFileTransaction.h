//
//  FileJob.h
//  remote_gateway
//
//  Created by Richard Long on 04/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileTransactionDelegate.h"

@interface RGFileTransaction : NSObject {
    
    // transactionId
	NSString* _transactionId;
	//@property (nonatomic, readonly) NSString* transactionId;
    //@property (nonatomic, retain) NSString* transactionId;
	//@synthesize transactionId = _transactionId;
    
    // delegate
	id<FileTransactionDelegate> _delegate;
	//@property (nonatomic, retain) id<FileJobDelegate> delegate;
	//@synthesize delegate = _delegate;


}

-(id<FileTransactionDelegate>)getDelegate;

-(void)abort;
-(void)commit;

#pragma mark instance lifecycle


-(id)initWithFileJobDelegate:(id<FileTransactionDelegate>)fileJobDelegate;
-(id)initWithTransactionId:(NSString*)transactionId fileJobDelegate:(id<FileTransactionDelegate>)fileJobDelegate;


#pragma mark fields

// transactionId
//NSString* _transactionId;
@property (nonatomic, readonly) NSString* transactionId;
//@property (nonatomic, retain) id<FileJobDelegate> delegate;
//@synthesize transactionId = _transactionId;

@end
