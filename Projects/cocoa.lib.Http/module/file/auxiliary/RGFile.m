//
//  RGFile.m
//  remote_gateway
//
//  Created by Richard Long on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBBaseException.h"
#import "JBFileUtilities.h"
#import "JBFolderUtilities.h"
#import "JBLog.h"
#import "JBMemoryModel.h"

#import "RGFile.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface RGFile () 

// fileManager
//NSFileManager* _fileManager;
@property (nonatomic, retain) NSFileManager* fileManager;
//@synthesize fileManager = _fileManager;

// pathname
//NSString* _pathname;
@property (nonatomic, retain) NSString* pathname;
//@synthesize pathname = _pathname;


// isExecutableFile
//NSNumber* _isExecutableFile;
@property (nonatomic, retain) NSNumber* isExecutableFile;
//@synthesize isExecutableFile = _isExecutableFile;

// isReadableFile
//NSNumber* _isReadableFile;
@property (nonatomic, retain) NSNumber* isReadableFile;
//@synthesize isReadableFile = _isReadableFile;


// isWritableFile
//NSNumber* _isWritableFile;
@property (nonatomic, retain) NSNumber* isWritableFile;
//@synthesize isWritableFile = _isWritableFile;

//
//// fileExists
////NSNumber* _fileExists;
//@property (nonatomic, retain) NSNumber* fileExists;
////@synthesize fileExists = _fileExists;


// absolutePathname
//NSString* _absolutePathname;
@property (nonatomic, retain) NSString* absolutePathname;
//@synthesize absolutePathname = _absolutePathname;

// fileName
//NSString* _fileName;
@property (nonatomic, retain) NSString* fileName;
//@synthesize fileName = _fileName;


// modificationDate
//NSDate* _modificationDate;
@property (nonatomic, retain) NSDate* modificationDate;
//@synthesize modificationDate = _modificationDate;

//
//// size
////NSNumber* _size;
//@property (nonatomic, retain) NSNumber* size;
////@synthesize size = _size;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation RGFile

static NSData* _emptyFile = nil;


+(void)initialize {
	
	_emptyFile = [[NSData data] retain];
	
}


+(NSString*)combineParentPath:(NSString*)parentPath childPath:(NSString*)childPath { 
    
    NSString* seperator = @"/";
    
    if( [parentPath hasSuffix:@"/"] ) {
        seperator = @"";
    } else if( [childPath hasPrefix:@"/"] ) { 
        seperator = @"";            
    }
    
    NSString* answer = [NSString stringWithFormat:@"%@%@%@", parentPath, seperator, childPath];
    return answer;
    
}


-(BOOL)canExecute {
    
    if( nil != _isExecutableFile ) { 
        return [_isExecutableFile boolValue];
    }
    
    BOOL isExecutableFile = [_fileManager isExecutableFileAtPath:_pathname];
    _isExecutableFile = [[NSNumber alloc] initWithBool:isExecutableFile];
    
    return [_isExecutableFile boolValue];
    

}

-(BOOL)canRead {
    
    if( nil != _isReadableFile ) { 
        return [_isReadableFile boolValue];
    }
    
    BOOL isReadableFile = [_fileManager isReadableFileAtPath:_pathname];
    _isReadableFile = [[NSNumber alloc] initWithBool:isReadableFile];
    
    return [_isReadableFile boolValue];
    
}

-(BOOL)canWrite { 
    
    if( nil != _isWritableFile ) {
        return [_isWritableFile boolValue];    
    }
    
    BOOL isWritableFile = [_fileManager isWritableFileAtPath:_pathname]; 
    _isWritableFile = [[NSNumber alloc] initWithBool:isWritableFile];
    
    return [_isWritableFile boolValue];
}

-(BOOL)createNewFile { 
    
    BOOL answer = [_fileManager createFileAtPath:_pathname contents:_emptyFile attributes:nil];
    return answer;
    
}

-(BOOL)exists { 
    
    return [_fileManager fileExistsAtPath:_pathname];
//    if( nil != _fileExists ) { 
//        return [_fileExists boolValue];
//    }
//    
//    BOOL fileExists = [_fileManager fileExistsAtPath:_pathname];
//    _fileExists = [[NSNumber alloc] initWithBool:fileExists];
//
//    return [_fileExists boolValue];
    
}

-(long long)getFreeSpace {
    
    NSError* error = nil;
    
    NSDictionary* attributesOfFileSystem = [_fileManager attributesOfFileSystemForPath:_pathname error:&error]; 
    if( nil != error ) { 
        
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"[ NSFileManager attributesOfFileSystemForPath:error:]" failedWithError:error];
        [e autorelease];
        @throw  e;

    }
    
    NSNumber* fileSystemFreeSize = [attributesOfFileSystem objectForKey:NSFileSystemFreeSize];
    
    if( nil == fileSystemFreeSize ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"nil == fileSystemFreeSize"];
        [e autorelease];
        @throw  e;
    }

    return [fileSystemFreeSize longLongValue];
    
}

-(NSFileHandle*)toFileHandleForReading {
    
    NSFileHandle* answer = [NSFileHandle fileHandleForReadingAtPath:_pathname];
    return answer;
}

-(NSInputStream*)toInputStream {

  
    NSInputStream* answer = [NSInputStream inputStreamWithFileAtPath:_pathname];
    return answer;
    
}

-(NSOutputStream*)toAppendingOutputStream { 
    
    NSOutputStream* answer = [NSOutputStream outputStreamToFileAtPath:_pathname append:true];
    //[answer open];
    return answer;
    
}

-(NSOutputStream*)toOverWritingOutputStream { 
    
    NSOutputStream* answer = [NSOutputStream outputStreamToFileAtPath:_pathname append:false];
    return answer;
}

-(BOOL)mkdirs {
    
    [JBFolderUtilities mkdirs:_pathname];

    return true;
    
}

-(BOOL)isDirectory { 
    
    return [JBFolderUtilities directoryExistsAtPath:_pathname];
    
}

-(BOOL)isFile {
    
    return [JBFileUtilities isFile:_pathname];
    
}

-(NSString*)getAbsolutePath { 
    
    if( nil != _absolutePathname ) {
        return _absolutePathname;
    }
    
    [self setAbsolutePathname:[_pathname stringByStandardizingPath]];
    
    return _absolutePathname;
    
}


-(NSString*)getName {
    
    if( nil != _fileName ) { 
        return _fileName;
    }
    
    [self setFileName:[_pathname lastPathComponent]];
    
    return _fileName;
}

-(NSString*)getPath {
    
    return _pathname;
    
}

-(BOOL)delete { 
    
    NSError* error = nil;
    
    BOOL answer = [_fileManager removeItemAtPath:_pathname error:&error];
    
    if( nil != error ) { 
        
        Log_warnError( error );
        return false;
        
    }
    
    return answer;
    
}


-(long long)length {
    
    return [JBFileUtilities getFileLength:_pathname];

    
}


-(BOOL)renameTo:(RGFile*)dest {
    
    
    
    NSString* destPathname = dest->_pathname;
    NSError* error = nil;

    [_fileManager moveItemAtPath:_pathname toPath:destPathname error:&error];
    
    if( nil != error ) { 
        
        Log_warnError( error );
        return false;
    }
    
    return true;
    
}

-(NSDate*)getModificationDate { 
    if( nil != _modificationDate ) { 
        return _modificationDate;
    }

    NSError* error = nil;
    NSDictionary* fileAttributes = [_fileManager attributesOfItemAtPath:_pathname error:&error];

    if( nil != error ) { 
        
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"[ NSFileManager attributesOfItemAtPath:error:]" failedWithError:error];
        [e autorelease];
        @throw  e;
        
    }
    
    [self setModificationDate:[fileAttributes fileModificationDate]];
    
    return _modificationDate;
    
}

//-(NSNumber*)getSize { 
//    
//    if( nil != _size ) { 
//        return _size;
//    }
//    
//
//    NSError* error = nil;
//    NSDictionary* fileAttributes = [_fileManager attributesOfItemAtPath:_pathname error:&error];
//    
//    if( nil != error ) { 
//        
//        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"[ NSFileManager attributesOfItemAtPath:error:]" failedWithError:error];
//        [e autorelease];
//        @throw  e;
//        
//    }
//
//    unsigned long long fileSize = [fileAttributes fileSize];
//    _size = [[NSNumber alloc] initWithLongLong:fileSize];
//    return _size;
//    
//}


-(NSString*)lowercaseFileName {
    
    if( nil != _lowercaseFileName ) {
        return _lowercaseFileName;
    }
    
    NSString* filename = [self getName];
    _lowercaseFileName = [filename lowercaseString];
    JBRetain( _lowercaseFileName );
    
    return _lowercaseFileName;
    
}


#pragma mark instance lifecycle 


-(id)initWithFileManager:(NSFileManager*)fileManager pathname:(NSString*)pathname { 
    
    RGFile* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setFileManager:fileManager];

        [answer setPathname:pathname];
        
        [answer setIsExecutableFile:nil];
        [answer setIsReadableFile:nil];
        [answer setIsWritableFile:nil];
        [self setAbsolutePathname:nil];
        [answer setFileName:nil];


    }
    
    return answer;
}

-(id)initWithPathname:(NSString*)pathname { 
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];

    return [self initWithFileManager:defaultManager pathname:pathname];

}


-(id)initWithFileManager:(NSFileManager*)fileManager parentPathname:(NSString*)parentPathname child:(NSString*)child { 

    RGFile* answer = [super init];
    
    if( nil != answer ) { 

        [answer setFileManager:fileManager];

        NSString* pathname = [RGFile combineParentPath:parentPathname childPath:child];
        [answer setPathname:pathname];

        [answer setIsExecutableFile:nil];
        [answer setIsReadableFile:nil];
        [answer setIsWritableFile:nil];
        [self setAbsolutePathname:nil];
        [answer setFileName:nil];
        answer->_lowercaseFileName = nil;

    }
    
    return answer;
    

}

-(id)initWithParentPathname:(NSString*)parentPathname child:(NSString*)child { 
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    
    return [self initWithFileManager:defaultManager parentPathname:parentPathname child:child];

}

-(id)initWithFileManager:(NSFileManager*)fileManager parentFile:(RGFile*)parent child:(NSString*)child { 
    
    
    RGFile* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setFileManager:fileManager];
        
        NSString* parentPathname = parent->_pathname;
        NSString* pathname = [RGFile combineParentPath:parentPathname childPath:child];
        [answer setPathname:pathname];
        
        [answer setIsExecutableFile:nil];
        [answer setIsReadableFile:nil];
        [answer setIsWritableFile:nil];
        [self setAbsolutePathname:nil];
        [answer setFileName:nil];
        answer->_lowercaseFileName = nil;
    }
    
    return answer;

}

-(id)initWithParentFile:(RGFile*)parent child:(NSString*)child { 
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    
    return [self initWithFileManager:defaultManager parentFile:parent child:child];
}


-(void)dealloc {

    
    [self setFileManager:nil];
	[self setPathname:nil];
    [self setIsExecutableFile:nil];
    [self setIsReadableFile:nil];
	[self setIsWritableFile:nil];
    [self setAbsolutePathname:nil];
    [self setFileName:nil];
    [self setModificationDate:nil];
    
    if( nil != _lowercaseFileName ) {
        JBRelease( _lowercaseFileName );
        _lowercaseFileName = nil;
    }
    
	JBSuperDealloc();
	
}


#pragma mark fields



// fileManager
//NSFileManager* _fileManager;
//@property (nonatomic, retain) NSFileManager* fileManager;
@synthesize fileManager = _fileManager;


// pathname
//NSString* _pathname;
//@property (nonatomic, retain) NSString* pathname;
@synthesize pathname = _pathname;


// isExecutableFile
//NSNumber* _isExecutableFile;
//@property (nonatomic, retain) NSNumber* isExecutableFile;
@synthesize isExecutableFile = _isExecutableFile;

// isReadableFile
//NSNumber* _isReadableFile;
//@property (nonatomic, retain) NSNumber* isReadableFile;
@synthesize isReadableFile = _isReadableFile;


// isWritableFile
//NSNumber* _isWritableFile;
//@property (nonatomic, retain) NSNumber* isWritableFile;
@synthesize isWritableFile = _isWritableFile;

//
//// fileExists
////NSNumber* _fileExists;
////@property (nonatomic, retain) NSNumber* fileExists;
//@synthesize fileExists = _fileExists;
//

// absolutePathname
//NSString* _absolutePathname;
//@property (nonatomic, retain) NSString* absolutePathname;
@synthesize absolutePathname = _absolutePathname;

// fileName
//NSString* _fileName;
//@property (nonatomic, retain) NSString* fileName;
@synthesize fileName = _fileName;

// modificationDate
//NSDate* _modificationDate;
//@property (nonatomic, retain) NSDate* modificationDate;
@synthesize modificationDate = _modificationDate;


//
//// size
////NSNumber* _size;
////@property (nonatomic, retain) NSNumber* size;
//@synthesize size = _size;


@end
