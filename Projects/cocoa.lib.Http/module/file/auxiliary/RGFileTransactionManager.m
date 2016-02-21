//
//  FileJobManager.m
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBBaseException.h"
#import "RGFileTransactionManager.h"
#import "RGFileServiceErrorCodes.h"
#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface RGFileTransactionManager () 

// activeTransactions
//NSMutableDictionary* _activeTransactions;
@property (nonatomic, retain) NSMutableDictionary* activeTransactions;
//@synthesize activeTransactions = _activeTransactions;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation RGFileTransactionManager


static int _BASE_ERROR_CODE; 
static int _PUSH_FILE_ALREADY_ACTIVE;



+(void)initialize {
    
    _BASE_ERROR_CODE = [RGFileServiceErrorCodes getFileJobManagerErrorCode];
    _PUSH_FILE_ALREADY_ACTIVE = _BASE_ERROR_CODE | 1;
    
}


-(NSString*)begin:(id<FileTransactionDelegate>)fileJobDelegate {
    
    NSString* transactionId;
    
    RGFileTransaction* newTransaction = [[RGFileTransaction alloc] initWithFileJobDelegate:fileJobDelegate];
    {
        transactionId = [newTransaction transactionId];
        [_activeTransactions setObject:newTransaction forKey:transactionId];
    }
    [newTransaction release];
        
    return transactionId;
    
}

-(void)resumeWithTransactionId:(NSString*)transactionId pushFile:(RGPushFile*)pushFile {
    
    // if transactionid is still active then continue
    {
        if( nil != [_activeTransactions objectForKey:transactionId] ) { 
            
            RGFileTransaction* activeJob = [_activeTransactions objectForKey:transactionId];
            
            id<FileTransactionDelegate> fileJobDelegate = [activeJob getDelegate];
            
            if( ![fileJobDelegate isKindOfClass:[RGPushFile class]] ) { 
                BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![fileJobDelegate isKindOfClass:[PushFile class]]; NSStringFromClass([fileJobDelegate class]) = '%@'", NSStringFromClass([fileJobDelegate class])];
                [e autorelease];
                @throw e;
            }
            // not nil and, the type is right ... 
            return;
        }
    }
    
    // if another transactionid is active for the same file, then fail
    {
        RGFile* target = [pushFile getTarget];
        NSString* targetAbsolutePath = [target getAbsolutePath];
        
        for( NSString* activeTransactionId in _activeTransactions ) {
            
            RGFileTransaction* activeJob = [_activeTransactions objectForKey:activeTransactionId];
            RGFile* activeTarget = [[activeJob getDelegate] getTarget];
            if( [targetAbsolutePath isEqualToString:[activeTarget getAbsolutePath]] ) { 
                BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[targetAbsolutePath isEqualToString:[activeTarget getAbsolutePath]]; targetAbsolutePath = '%@'", targetAbsolutePath];
                [e autorelease];
                [e setFaultCode:_PUSH_FILE_ALREADY_ACTIVE];
                @throw e;
            }
            
        }
    }
    
    // transactionid is not active, recreate it 
    RGFileTransaction* resumedTransaction = [[RGFileTransaction alloc] initWithTransactionId:transactionId fileJobDelegate:pushFile];
    {
        [_activeTransactions setObject:resumedTransaction forKey:transactionId];
        
    }
    [resumedTransaction release];
    
}


-(RGFileTransaction*)getTransaction:(NSString*)transactionId {
  
    RGFileTransaction* answer = [_activeTransactions objectForKey:transactionId];
    
    if( nil == answer ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"nil == answer; transactionId = '%@'", transactionId];
        [e autorelease];
        @throw e;
    }
    
    
    
    return answer;
    
}

-(BOOL)hasTransaction:(NSString*)transactionId {
    
    if( nil != [_activeTransactions objectForKey:transactionId] ) { 
        
        return true;
        
    }
    
    return false;
    
}

-(void)abort:(NSString*)transactionId {
    
    RGFileTransaction* transaction = [self getTransaction:transactionId];
    [transaction abort];
    [_activeTransactions removeObjectForKey:transactionId];
    
}

-(void)abortTransactions:(RGFile*)target {
    
    
    NSMutableArray* transactionsToAbort = [[NSMutableArray alloc] init];
    [transactionsToAbort autorelease];
    
    NSString* targetAbsolutePath = [target getAbsolutePath];
    
    
    for( NSString* activeTransactionId in _activeTransactions ) {
        
        RGFileTransaction* activeTransaction = [_activeTransactions objectForKey:activeTransactionId];
        RGFile* activeTransactionTarget = [[activeTransaction getDelegate] getTarget];
        
        if( [targetAbsolutePath isEqualToString:[activeTransactionTarget getAbsolutePath]] ) { 
            [transactionsToAbort addObject:activeTransactionId];
        }        
    }
    
    for( NSString* transactionIdToAbort in transactionsToAbort ) { 
        
        Log_debugString( transactionIdToAbort );
        [self abort:transactionIdToAbort];
    }
    
    
}


-(void)commit:(NSString*)transactionId {
    
    RGFileTransaction* transaction = [self getTransaction:transactionId];
    [transaction commit];
    [_activeTransactions removeObjectForKey:transactionId];

}


#pragma mark instance lifecycle

-(id)init { 
    
    RGFileTransactionManager* answer = [super init];
    
    if( nil != answer ) { 
        
        answer->_activeTransactions = [[NSMutableDictionary alloc] init];
        
    }
    
    return answer;
        
    
    
}

-(void)dealloc {
	
	[self setActiveTransactions:nil];
	
	[super dealloc];
	
}


#pragma mark fields


// activeTransactions
//NSMutableDictionary* _activeTransactions;
//@property (nonatomic, retain) NSMutableDictionary* activeTransactions;
@synthesize activeTransactions = _activeTransactions;

@end
