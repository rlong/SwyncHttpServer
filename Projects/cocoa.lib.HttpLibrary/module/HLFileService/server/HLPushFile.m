//
//  PushFileJob.m
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "CABaseException.h"
#import "CAFile.h"
#import "CAInputStreamHelper.h"
#import "CALog.h"
#import "CAStreamHelper.h"

#import "HLFileServiceErrorCodes.h"
#import "HLFileTransaction.h"
#import "HLPushFile.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLPushFile () 

// target
//HLFile* _target;
@property (nonatomic, retain) CAFile* target;
//@synthesize target = _target;


// partialContent
//HLFile* _partialContent;
@property (nonatomic, retain) CAFile* partialContent;
//@synthesize partialContent = _partialContent;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLPushFile

static int _UNEHLECTED_FILE_LENGTH; 
static int _RENAME_ON_COMMIT_FAILED; 

+(void)initialize {
    
    int baseErrorCode = [HLFileServiceErrorCodes getPushFileJobErrorCode];
    _UNEHLECTED_FILE_LENGTH = baseErrorCode | 1;
	_RENAME_ON_COMMIT_FAILED = baseErrorCode | 2;
    
	
}


-(long long)getFileLength { 
    return [_partialContent length];
}


-(void)append:(long long)streamLength inputStream:(NSInputStream*)inputStream {
    
    NSOutputStream* output = [_partialContent toAppendingOutputStream];
    [output open];
    
    @try {
        
        [CAInputStreamHelper writeFrom:inputStream toOutputStream:output count:streamLength];
        
        
    }
    @finally {
        [CAStreamHelper closeStream:output swallowErrors:false caller:self];
    }
    
    
}

#pragma mark <FileJobDelegate> implementation 

-(CAFile*)getTarget {
    return _target;
}

-(void)abort:(HLFileTransaction*)fileJob {
    
    Log_enteredMethod();

    
    if( ![_partialContent exists] ) { 
        
        Log_infoFormat( @"![_partialContent exists]; [_partialContent getPath] = '%@'", [_partialContent getPath]);
        
    } else {
        
        if( ![_partialContent delete] ) {
            
            Log_warnFormat( @"![_partialContent deleteFile]; [_partialContent getPath] = '%@'", [_partialContent getPath]);
            
        } else {
            
            Log_infoFormat( @"[_partialContent deleteFile]; [_partialContent getPath] = '%@'", [_partialContent getPath]);
            
        }
    }
    
}

-(void)commit:(HLFileTransaction*)fileJob {
    
    if( [_partialContent length] != _fileLength ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[_partialContent getFileLength] != _fileLength; [_partialContent length] = %ld; _fileLength = %ld", [_partialContent length], _fileLength];
        [e setFaultCode:_UNEHLECTED_FILE_LENGTH];
        @throw e;
    }
    if( ![_partialContent renameTo:_target] ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![_partialContent renameTo:_target]; [_partialContent getPath] = '%@'; [_target getPath] = '%@'", [_partialContent getPath], [_target getPath]];
        [e setFaultCode:_RENAME_ON_COMMIT_FAILED];
        @throw e;
    }
    
}


#pragma mark instance lifecycle



-(id)initWithResume:(BOOL)resume filePath:(NSString*)filePath fileLength:(long)fileLength { 
    
    HLPushFile* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_target = [[CAFile alloc] initWithPathname:filePath];
        answer->_fileLength = fileLength;
        
        NSString* partialContentFilename = [filePath stringByAppendingString:@".partial_content"];
        answer->_partialContent = [[CAFile alloc] initWithPathname:partialContentFilename];
        
        if( resume ) { 
            if( ![answer->_partialContent exists] ) { 
                BaseException* e = [[BaseException alloc] initWithOriginator:answer line:__LINE__ faultStringFormat:@"![answer->_partialContent exists]; filePath = '%@'", filePath];
                @throw e;
            }
        } else { // just starting
            if( [answer->_partialContent exists] ) { 
                
                BaseException* e = [[BaseException alloc] initWithOriginator:answer line:__LINE__ faultStringFormat:@"[answer->_partialContent exists]; [[answer partialContent] getPath] = '%@'", [[answer partialContent] getPath]];
                @throw e;
            }
            if( ![answer->_partialContent createNewFile] ) { 
                BaseException* e = [[BaseException alloc] initWithOriginator:answer line:__LINE__ faultStringFormat:@"![answer->_partialContent createNewFile]; [[answer partialContent] getPath] = '%@'", [[answer partialContent] getPath]];
                @throw e;
            }
        }
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setTarget:nil];
	[self setPartialContent:nil];
    
	
}




#pragma mark fields


// target
//HLFile* _target;
//@property (nonatomic, retain) HLFile* target;
@synthesize target = _target;

// partialContent
//HLFile* _partialContent;
//@property (nonatomic, retain) HLFile* partialContent;
@synthesize partialContent = _partialContent;



@end
