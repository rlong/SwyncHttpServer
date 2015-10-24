//
//  FileJob.m
//  remote_gateway
//
//  Created by Richard Long on 04/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RGFileTransaction.h"
#import "JBSecurityUtilities.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface RGFileTransaction () 



// delegate
//id<FileJobDelegate> _delegate;
@property (nonatomic, retain) id<FileTransactionDelegate> delegate;
//@synthesize delegate = _delegate;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation RGFileTransaction


-(id<FileTransactionDelegate>)getDelegate {
    return _delegate;
}


-(void)abort {

    [_delegate abort:self];

}

-(void)commit {
    
    [_delegate commit:self];
    
}

#pragma mark instance lifecycle


-(id)initWithFileJobDelegate:(id<FileTransactionDelegate>)fileJobDelegate {
    
    RGFileTransaction* answer = [super init];
    
    if( nil != answer ) { 
        
        answer->_transactionId = [JBSecurityUtilities generateNonce];
        [answer->_transactionId retain];
        
        [answer setDelegate:fileJobDelegate];
        
    }
    return answer;
    
}


-(id)initWithTransactionId:(NSString*)transactionId fileJobDelegate:(id<FileTransactionDelegate>)fileJobDelegate {


    RGFileTransaction* answer = [super init];

    if( nil != answer ) { 
        
        answer->_transactionId = [transactionId retain];
        
        [answer setDelegate:fileJobDelegate];
    }
    
    return answer;

}

-(void)dealloc { 

    if( nil != _transactionId ) { 
        [_transactionId release];        
        _transactionId = nil;
    }
    
    [self setDelegate:nil];
    
    [super dealloc];
}

#pragma mark fields

// transactionId
//NSString* _transactionId;
//@property (nonatomic, readonly) NSString* transactionId;
//@property (nonatomic, retain) NSString* transactionId;
@synthesize transactionId = _transactionId;

// delegate
//id<FileJobDelegate> _delegate;
//@property (nonatomic, retain) id<FileJobDelegate> delegate;
@synthesize delegate = _delegate;

@end
