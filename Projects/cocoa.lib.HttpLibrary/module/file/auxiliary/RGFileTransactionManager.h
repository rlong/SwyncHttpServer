//
//  FileJobManager.h
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RGFileTransaction.h"
#import "FileTransactionDelegate.h"
#import "RGPushFile.h"

@interface RGFileTransactionManager : NSObject {
    
    
	// activeTransactions
	NSMutableDictionary* _activeTransactions;
	//@property (nonatomic, retain) NSMutableDictionary* activeTransactions;
	//@synthesize activeTransactions = _activeTransactions;
    
}


-(NSString*)begin:(id<FileTransactionDelegate>)fileJobDelegate;
-(void)resumeWithTransactionId:(NSString*)transactionId pushFile:(RGPushFile*)pushFile;

-(RGFileTransaction*)getTransaction:(NSString*)transactionId;
-(BOOL)hasTransaction:(NSString*)transactionId;

-(void)abort:(NSString*)transactionId;
-(void)abortTransactions:(HLFile*)target;

-(void)commit:(NSString*)transactionId;

@end
