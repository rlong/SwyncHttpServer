//
//  FileJobManager.m
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBBaseException.h"
#import "HLFileTransactionManager.h"
#import "HLFileServiceErrorCodes.h"
#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLFileTransactionManager () 

// activeTransactions
//NSMutableDictionary* _activeTransactions;
@property (nonatomic, retain) NSMutableDictionary* activeTransactions;
//@synthesize activeTransactions = _activeTransactions;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLFileTransactionManager


static int _BASE_ERROR_CODE; 
static int _PUSH_FILE_ALREADY_ACTIVE;



+(void)initialize {
    
    _BASE_ERROR_CODE = [HLFileServiceErrorCodes getFileJobManagerErrorCode];
    _PUSH_FILE_ALREADY_ACTIVE = _BASE_ERROR_CODE | 1;
    
}


-(NSString*)begin:(id<FileTransactionDelegate>)fileJobDelegate {
    
    NSString* transactionId;
    
    HLFileTransaction* newTransaction = [[HLFileTransaction alloc] initWithFileJobDelegate:fileJobDelegate];
    {
        transactionId = [newTransaction transactionId];
        [_activeTransactions setObject:newTransaction forKey:transactionId];
    }
    
    return transactionId;
    
}

-(void)resumeWithTransactionId:(NSString*)transactionId pushFile:(HLPushFile*)pushFile {
    
    // if transactionid is still active then continue
    {
        if( nil != [_activeTransactions objectForKey:transactionId] ) { 
            
            HLFileTransaction* activeJob = [_activeTransactions objectForKey:transactionId];
            
            id<FileTransactionDelegate> fileJobDelegate = [activeJob getDelegate];
            
            if( ![fileJobDelegate isKindOfClass:[HLPushFile class]] ) { 
                BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![fileJobDelegate isKindOfClass:[PushFile class]]; NSStringFromClass([fileJobDelegate class]) = '%@'", NSStringFromClass([fileJobDelegate class])];
                @throw e;
            }
            // not nil and, the type is right ... 
            return;
        }
    }
    
    // if another transactionid is active for the same file, then fail
    {
        HLFile* taHLet = [pushFile getTarget];
        NSString* taHLetAbsolutePath = [taHLet getAbsolutePath];
        
        for( NSString* activeTransactionId in _activeTransactions ) {
            
            HLFileTransaction* activeJob = [_activeTransactions objectForKey:activeTransactionId];
            HLFile* activeTarget = [[activeJob getDelegate] getTarget];
            if( [taHLetAbsolutePath isEqualToString:[activeTarget getAbsolutePath]] ) {
                BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[taHLetAbsolutePath isEqualToString:[activeTaHLet getAbsolutePath]]; taHLetAbsolutePath = '%@'", taHLetAbsolutePath];
                [e setFaultCode:_PUSH_FILE_ALREADY_ACTIVE];
                @throw e;
            }
            
        }
    }
    
    // transactionid is not active, recreate it 
    HLFileTransaction* resumedTransaction = [[HLFileTransaction alloc] initWithTransactionId:transactionId fileJobDelegate:pushFile];
    {
        [_activeTransactions setObject:resumedTransaction forKey:transactionId];
        
    }
    
}


-(HLFileTransaction*)getTransaction:(NSString*)transactionId {
  
    HLFileTransaction* answer = [_activeTransactions objectForKey:transactionId];
    
    if( nil == answer ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"nil == answer; transactionId = '%@'", transactionId];
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
    
    HLFileTransaction* transaction = [self getTransaction:transactionId];
    [transaction abort];
    [_activeTransactions removeObjectForKey:transactionId];
    
}

-(void)abortTransactions:(HLFile*)taHLet {
    
    
    NSMutableArray* transactionsToAbort = [[NSMutableArray alloc] init];
    
    NSString* taHLetAbsolutePath = [taHLet getAbsolutePath];
    
    
    for( NSString* activeTransactionId in _activeTransactions ) {
        
        HLFileTransaction* activeTransaction = [_activeTransactions objectForKey:activeTransactionId];
        HLFile* activeTransactionTaHLet = [[activeTransaction getDelegate] getTarget];
        
        if( [taHLetAbsolutePath isEqualToString:[activeTransactionTaHLet getAbsolutePath]] ) { 
            [transactionsToAbort addObject:activeTransactionId];
        }        
    }
    
    for( NSString* transactionIdToAbort in transactionsToAbort ) { 
        
        Log_debugString( transactionIdToAbort );
        [self abort:transactionIdToAbort];
    }
    
    
}


-(void)commit:(NSString*)transactionId {
    
    HLFileTransaction* transaction = [self getTransaction:transactionId];
    [transaction commit];
    [_activeTransactions removeObjectForKey:transactionId];

}


#pragma mark instance lifecycle

-(id)init { 
    
    HLFileTransactionManager* answer = [super init];
    
    if( nil != answer ) { 
        
        answer->_activeTransactions = [[NSMutableDictionary alloc] init];
        
    }
    
    return answer;
        
    
    
}

-(void)dealloc {
	
	[self setActiveTransactions:nil];
	
	
}


#pragma mark fields


// activeTransactions
//NSMutableDictionary* _activeTransactions;
//@property (nonatomic, retain) NSMutableDictionary* activeTransactions;
@synthesize activeTransactions = _activeTransactions;

@end
