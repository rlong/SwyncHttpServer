//
//  AAFileUploadPartHandler.m
//  av_amigo
//
//  Created by rlong on 24/01/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "HLPostFilePartHandler.h"
#import "HLStorageMetaData.h"

#import "JBBaseException.h"
#import "JBLog.h"
#import "JBPartHandlerHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLPostFilePartHandler ()

// storageManager
//id<AVStorageManager> _storageManager;
@property (nonatomic, retain) id<HLStorageManager> storageManager;
//@synthesize storageManager = _storageManager;


// contentType
//JBMediaType* _contentType;
@property (nonatomic, retain) JBMediaType* contentType;
//@synthesize contentType = _contentType;

// fileStream
//NSOutputStream* _fileStream;
@property (nonatomic, retain) NSOutputStream* fileStream;
//@synthesize fileStream = _fileStream;



// timeAtLastHeader
//NSDate* _timeAtLastHeader;
@property (nonatomic, retain) NSDate* timeAtLastHeader;
//@synthesize timeAtLastHeader = _timeAtLastHeader;




@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation HLPostFilePartHandler

-(long long)fileSize {
    return _fileSize;
}

#pragma mark -
#pragma mark <JBPartHandler> implementation



+(NSString*)removePathElementsFromFilename:(NSString*)filename {
    
    // certain versions of IE will send the full path as the filename (seen in IE 8)
    NSRange lastBackslash = [filename rangeOfString:@"\\" options:NSBackwardsSearch];
    if( NSNotFound != lastBackslash.location ) {
        Log_warnFormat(@"NSNotFound != lastBackslash.location; filename = '%@'", filename);
        filename = [filename substringFromIndex:lastBackslash.location+1];
    }
    
    NSRange lastSlash = [filename rangeOfString:@"/" options:NSBackwardsSearch];
    if( NSNotFound != lastSlash.location ) {
        Log_warnFormat(@"NSNotFound != lastSlash.location; filename = '%@'", filename);
        filename = [filename substringFromIndex:lastSlash.location+1];
    }
    
    return filename;
    
}

// returns nil if the filename is considered valid
+(NSString*)validateFilename:(NSString*)filename {
    
    
    if( 0 == [filename length] ) {

        NSString* userError = [NSString stringWithFormat:@"invalid filename '%@' (filename is empty)", filename];
        Log_warn( userError );
        return userError;
    }
    
    if( '.' == [filename characterAtIndex:0] ) {
        NSString* userError = [NSString stringWithFormat:@"invalid filename '%@' (filename starts with '.')", filename];
        Log_warn( userError );
        return userError;
    
    }
    
    if( NSNotFound != [filename rangeOfString:@".."].location ) {
        
        NSString* userError = [NSString stringWithFormat:@"invalid filename '%@' (contains '..')", filename];
        Log_warn( userError );
        return userError;
    }
    
    return nil;
}

-(void)handleHeaderWithName:(NSString*)name value:(NSString*)value  {
    
    Log_debugString(name);
    Log_debugString(value);
    
    JBContentDisposition* contentDisposition = [JBPartHandlerHelper getContentDispositionWithName:name value:value];
    if( nil != contentDisposition ) {
        
        NSString* filename = [contentDisposition getDispositionParameter:@"filename" defaultValue:nil];
        
        if( nil == filename ) {
            Log_debugString(value);
        } else {
            
            filename = [HLPostFilePartHandler removePathElementsFromFilename:filename];
            [self setFileName:filename];
            Log_debugString(filename);
            
            [self setUserError:[HLPostFilePartHandler validateFilename:filename]];
            if( nil == _userError ) { // filename considered valid

                if( [_storageManager fileExistsWithName:_fileName] ) {
                    
                    NSString* userError = [NSString stringWithFormat:@"'%@' already exists", filename];
                    Log_warn(userError);
                    [self setUserError:userError];
                    
                    
                } else { // happy path
                    
                    
                    NSOutputStream* outputStream = [_storageManager outputStreamWithFilename:filename append:false];
                    [outputStream open];
                    [self setFileStream:outputStream];
                    
                }

            }
        }
    }
    
    JBMediaType* contentType = [JBPartHandlerHelper getContentTypeWithName:name value:value];
    
    if( nil != contentType ) {
        
        [self setContentType:contentType];
        
    }
    
    [self setTimeAtLastHeader:[NSDate date]];
    
    
}


-(void)handleBytes:(const UInt8*)bytes offset:(NSUInteger)offset length:(NSUInteger)length  {
    
    if( nil == _fileStream ) {
        
        return; // no-op
        
    }
    
    const void* start = &bytes[offset];
    [_fileStream write:start maxLength:length];
    
    _fileSize += length;
    
}

-(void)handleFailure:(BaseException*)e {
    
    Log_errorException(e);


    {
        if( nil != _fileStream ) {
            [_fileStream close];
        }
        [self setFileStream:nil];
    }

    if( nil != _fileName ) {
        [_storageManager removeFileWithName:_fileName swallowErrors:true];
    }

}


-(void)saveContentType  {
    
    
    if( nil == _fileName ) {
        Log_warn(@"nil == _fileName");
        return;
    }
    Log_debugString(_fileName);
    
    if( nil == _contentType )  {
        Log_warn(@"nil == _contentType");
        return;
    }
    
    NSString* contentType = [_contentType toString];
    Log_debugString(contentType);
    
    [HLStorageMetaData saveContentType:contentType forFilename:_fileName];

}


-(void)partCompleted {
    
    if( nil == _fileStream ) {
        Log_warn(@"nil == _fileStream");
        return;
    }
    
    [self saveContentType];
    
    [_fileStream close];
    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStorageManager:(id<HLStorageManager>)storageManager{
    
    HLPostFilePartHandler* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setStorageManager:storageManager];
        [answer setFileName:nil];
        answer->_fileSize = 0;
        [answer setUserError:nil];
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setStorageManager:nil];
    [self setContentType:nil];
	[self setFileStream:nil];
	[self setTimeAtLastHeader:nil];
	[self setFileName:nil];
	[self setUserError:nil];

	
}

#pragma mark -
#pragma mark fields

// storageManager
//id<AVStorageManager> _storageManager;
//@property (nonatomic, retain) id<AVStorageManager> storageManager;
@synthesize storageManager = _storageManager;


// contentType
//JBMediaType* _contentType;
//@property (nonatomic, retain) JBMediaType* contentType;
@synthesize contentType = _contentType;

// fileStream
//NSOutputStream* _fileStream;
//@property (nonatomic, retain) NSOutputStream* fileStream;
@synthesize fileStream = _fileStream;

// timeAtLastHeader
//NSDate* _timeAtLastHeader;
//@property (nonatomic, retain) NSDate* timeAtLastHeader;
@synthesize timeAtLastHeader = _timeAtLastHeader;


// fileName
//NSString* _fileName;
//@property (nonatomic, retain) NSString* fileName;
@synthesize fileName = _fileName;

// userError
//NSString* _userError;
//@property (nonatomic, retain) NSString* userError;
@synthesize userError = _userError;


@end
