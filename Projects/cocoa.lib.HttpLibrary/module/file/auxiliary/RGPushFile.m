//
//  PushFileJob.m
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "RGFileServiceErrorCodes.h"
#import "RGPushFile.h"

#import "JBBaseException.h"
#import "JBInputStreamHelper.h"
#import "JBLog.h"
#import "JBStreamHelper.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface RGPushFile () 

// target
//RGFile* _target;
@property (nonatomic, retain) RGFile* target;
//@synthesize target = _target;


// partialContent
//RGFile* _partialContent;
@property (nonatomic, retain) RGFile* partialContent;
//@synthesize partialContent = _partialContent;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation RGPushFile

static int _UNEXPECTED_FILE_LENGTH; 
static int _RENAME_ON_COMMIT_FAILED; 

+(void)initialize {
    
    int baseErrorCode = [RGFileServiceErrorCodes getPushFileJobErrorCode];
    _UNEXPECTED_FILE_LENGTH = baseErrorCode | 1;
	_RENAME_ON_COMMIT_FAILED = baseErrorCode | 2;
    
	
}


-(long long)getFileLength { 
    return [_partialContent length];
}


-(void)append:(long long)streamLength inputStream:(NSInputStream*)inputStream {
    
    NSOutputStream* output = [_partialContent toAppendingOutputStream];
    [output open];
    
    @try {
        
        [JBInputStreamHelper writeFrom:inputStream toOutputStream:output count:streamLength];
        
        
    }
    @finally {
        [JBStreamHelper closeStream:output swallowErrors:false caller:self];
    }
    
    
}

#pragma mark <FileJobDelegate> implementation 

-(RGFile*)getTarget {
    return _target;
}

-(void)abort:(RGFileTransaction*)fileJob {
    
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

-(void)commit:(RGFileTransaction*)fileJob {
    
    if( [_partialContent length] != _fileLength ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[_partialContent getFileLength] != _fileLength; [_partialContent length] = %ld; _fileLength = %ld", [_partialContent length], _fileLength];
        [e setFaultCode:_UNEXPECTED_FILE_LENGTH];
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
    
    RGPushFile* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_target = [[RGFile alloc] initWithPathname:filePath];
        answer->_fileLength = fileLength;
        
        NSString* partialContentFilename = [filePath stringByAppendingString:@".partial_content"];
        answer->_partialContent = [[RGFile alloc] initWithPathname:partialContentFilename];
        
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
//RGFile* _target;
//@property (nonatomic, retain) RGFile* target;
@synthesize target = _target;

// partialContent
//RGFile* _partialContent;
//@property (nonatomic, retain) RGFile* partialContent;
@synthesize partialContent = _partialContent;



@end
