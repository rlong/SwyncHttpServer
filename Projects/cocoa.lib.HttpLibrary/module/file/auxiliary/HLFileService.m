//
//  FileService.m
//  vlc_amigo
//
//  Created by rlong on 29/07/2011.
//  Copyright 2011 HexBeerium. All rights reserved.
//

#import "CAFile.h"

#import "JBBaseException.h"
#import "JBJsonObject.h"
#import "JBLog.h"
#import "JBServiceHelper.h"

#import "HLFilePathUtilities.h"
#import "HLFileService.h"
#import "HLFileServiceErrorCodes.h"
#import "HLPullFile.h"
#import "HLFileServiceConstants.h"
#import "HLFileSorters.h"
#import "HLPullFile.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLFileService ()

// fileJobManager
//FileTransactionManager* _fileJobManager;
@property (nonatomic, retain) HLFileTransactionManager* fileJobManager;
//@synthesize fileJobManager = _fileJobManager;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -




@implementation HLFileService


static JBServiceDescription* _SERVICE_DESCRIPTION = nil; 


static int _CANNOT_READ; 
static int _FILE_DOES_NOT_EXIST; 
static int _FOLDER_PATH_REFERENCES_FILE; 
static int _FILE_PATH_REFERENCES_FOLDER; 
static int _FILE_PATH_REFERENCES_EXISTING_FILE; 
static int _FOLDER_DOES_NOT_EXIST; 
static int _FILE_TYPE_IS_BLACKLISTED; 

static NSString* _SORT_BY_AGE = @"age";
static NSString* _SORT_BY_NAME = @"name";
static NSString* _SORT_BY_SIZE = @"size";

+(void)initialize {
    
    _SERVICE_DESCRIPTION = [[JBServiceDescription alloc] initWithServiceName:[HLFileServiceConstants SERVICE_NAME]];

    
    int baseErrorCode = [HLFileServiceErrorCodes getFileServiceErrorCode];
    
    _CANNOT_READ = baseErrorCode | 0x1;
    _FILE_DOES_NOT_EXIST = baseErrorCode | 0x2;
    _FOLDER_PATH_REFERENCES_FILE = baseErrorCode | 0x3;
	_FILE_PATH_REFERENCES_FOLDER = baseErrorCode | 0x4;
    _FILE_PATH_REFERENCES_EXISTING_FILE = baseErrorCode | 0x5;
    _FOLDER_DOES_NOT_EXIST = baseErrorCode | 0x6;
    _FILE_TYPE_IS_BLACKLISTED = baseErrorCode | 0x7;
	
}


+(NSString*)SORT_BY_AGE {
    return _SORT_BY_AGE;
}

+(NSString*)SORT_BY_NAME {
    return _SORT_BY_NAME;
}

+(NSString*)SORT_BY_SIZE {
    return _SORT_BY_SIZE;
}

+(BOOL)fileIsBlacklisted:(CAFile*)candidate {
    
    NSString* candidateName = [[candidate getName] lowercaseString];
    
    if( [candidateName hasPrefix:@"."] ) { 
        return  true;
    }
    
    if( [candidateName hasSuffix:@"json"] ) { 
        return true;
    }
    
    return false;
}

-(JBJsonObject*)beginPush:(NSString*)filePath fileLength:(long)fileLength { 
    
    CAFile* taHLet = [[CAFile alloc] initWithPathname:filePath];
    
    if( [HLFileService fileIsBlacklisted:taHLet] ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[FileService fileIsBlacklisted:taHLet]; filePath = '%@'", filePath];
        [e setFaultCode:_FILE_TYPE_IS_BLACKLISTED];
        @throw e;
    }
    
    if( [taHLet exists] ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[taHLet exists]; filePath = '%@'", filePath];
        [e setFaultCode:_FILE_PATH_REFERENCES_EXISTING_FILE];
        @throw e;        
    }
    
    // abort any existing transactions associated with the file
    [_fileJobManager abortTransactions:taHLet];
    
    HLPushFile* fileTransaction = [[HLPushFile alloc] initWithResume:false filePath:filePath fileLength:fileLength];
    
    JBJsonObject* answer = [[JBJsonObject alloc] init];
    NSString* transactionId = [_fileJobManager begin:fileTransaction];
    [answer setObject:transactionId forKey:[HLFileServiceConstants PULL_PUSH_TRANSACTION_ID]];
    return answer;
    
    
}


-(JBJsonObject*)beginPull:(NSString*)filePath {
    
    CAFile* taHLet = [[CAFile alloc] initWithPathname:filePath];
    
    {
        
        if( [HLFileService fileIsBlacklisted:taHLet] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[FileService fileIsBlacklisted:taHLet]; filePath = '%@'", filePath];
            [e setFaultCode:_FILE_TYPE_IS_BLACKLISTED];
            @throw e;
        }
        
        if( ![taHLet exists] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![taHLet exists]; filePath = '%@'", filePath];
            [e setFaultCode:_FILE_DOES_NOT_EXIST];
            @throw e;        
        }
        
        if( [taHLet isDirectory] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[taHLet isDirectory]; filePath = '%@'", filePath];
            [e setFaultCode:_FILE_PATH_REFERENCES_FOLDER];
            @throw e;        
            
        }
        
        if( ![taHLet canRead] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![taHLet canRead]; filePath = '%@'", filePath];
            [e setFaultCode:_CANNOT_READ];
            @throw e;        
        }
    }
    
 
    JBJsonObject* answer = [[JBJsonObject alloc] init];
    
    HLPullFile* fileTransaction = [[HLPullFile alloc] initWithTarget:taHLet];
    //[fileTransaction autorelease];
    {
        NSString* transactionId = [_fileJobManager begin:fileTransaction];
        [answer setObject:transactionId forKey:[HLFileServiceConstants PULL_PUSH_TRANSACTION_ID]];
        [answer setLongLong:[fileTransaction getFileLength] forKey:[HLFileServiceConstants PULL_FILE_LENGTH]];
        
    }

    return answer;

}


-(JBJsonObject*)resumePush:(NSString*)transactionId filePath:(NSString*)filePath fileLength:(long)fileLength {
    
    
    CAFile* taHLet = [[CAFile alloc] initWithPathname:filePath];
    
    if( [HLFileService fileIsBlacklisted:taHLet] ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[FileService fileIsBlacklisted:taHLet]; filePath = '%@'", filePath];
        [e setFaultCode:_FILE_TYPE_IS_BLACKLISTED];
        @throw e;
    }

    HLPushFile* fileTransaction = [[HLPushFile alloc] initWithResume:true filePath:filePath fileLength:fileLength];

    
    [_fileJobManager resumeWithTransactionId:transactionId pushFile:fileTransaction];
    
    JBJsonObject* answer = [[JBJsonObject alloc] init];

    [answer setObject:transactionId forKey:[HLFileServiceConstants PULL_PUSH_TRANSACTION_ID]];
    [answer setLongLong:[fileTransaction getFileLength] forKey:[HLFileServiceConstants PULL_FILE_LENGTH]];
    
    return  answer;
    
}

-(void)abort:(NSString*)transactionId { 
    
    [_fileJobManager abort:transactionId];
    
}


-(void)commit:(NSString*)transactionId { 
    
    [_fileJobManager commit:transactionId];
    
}

-(JBJsonObject*)getFileInfo:(NSString*)filePath {
    
    CAFile* taHLet = [[CAFile alloc] initWithPathname:filePath];
    
    if( [HLFileService fileIsBlacklisted:taHLet] ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[FileService fileIsBlacklisted:taHLet]; filePath = '%@'", filePath];
        [e setFaultCode:_FILE_TYPE_IS_BLACKLISTED];
        @throw e;
    }
    
    JBJsonObject* answer = [[JBJsonObject alloc] init];

    [answer setBool:[taHLet exists] forKey:@"exists"];
    
    if( [taHLet exists] ) { 
        
        [answer setBool:[taHLet isDirectory] forKey:@"isDirectory"];
        [answer setBool:[taHLet isFile] forKey:@"isFile"];
        [answer setLongLong:[taHLet length] forKey:[HLFileServiceConstants FILEINFO_FILELENGTH]];
        //[answer setLongLong:[taHLet length] forKey:@"length"];
        [answer setBool:[taHLet canRead] forKey:@"canRead"];
        [answer setBool:[taHLet canWrite] forKey:@"canWrite"];
        
        if( [taHLet isDirectory] ) { 
            [answer setLongLong:[taHLet getFreeSpace] forKey:@"freeSpace"];
        } else {
            [answer setObject:nil forKey:@"freeSpace"];
        }
    }
    
    return answer;
    
}


// can return nil
-(CAFile*)getComputer {
    
    CAFile* answer = [[CAFile alloc] initWithPathname:@"/"];
    return answer;
    
}

// can return nil
-(CAFile*)getDesktop {
        
    NSArray* paths =  NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    
    if( 0 == [paths count] ) {
        return nil;
    }
    
    NSString* desktopPath = [paths objectAtIndex:0];
    
    CAFile* answer = [[CAFile alloc] initWithPathname:desktopPath];
    return answer;
    
    
}



// can return nil
-(CAFile*)getDocuments {
    
    NSArray* paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if( 0 == [paths count] ) {
        return nil;
    }
    
    NSString* documentsPath = [paths objectAtIndex:0];
    CAFile* answer = [[CAFile alloc] initWithPathname:documentsPath];
    return answer;


}



// can return nil
-(CAFile*)getDownloads {

    NSArray* paths =  NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    
    if( 0 == [paths count] ) {
        return nil;
    }
    
    NSString* downloadsPath = [paths objectAtIndex:0];
    
    CAFile* answer = [[CAFile alloc] initWithPathname:downloadsPath];
    return answer;
    
}

// can return nil
-(CAFile*)getHome {

    
    NSString* homeDirectory = NSHomeDirectory();
    
    CAFile* answer = [[CAFile alloc] initWithPathname:homeDirectory];
    return answer;


    
}

// can return nil
-(CAFile*)getMusic {

    NSArray* paths =  NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    
    if( 0 == [paths count] ) {
        return nil;
    }
    
    NSString* musicPath = [paths objectAtIndex:0];
    
    CAFile* answer = [[CAFile alloc] initWithPathname:musicPath];
    return answer;

    
}


// can return nil
-(CAFile*)getVideos {
    
    NSArray* paths =  NSSearchPathForDirectoriesInDomains(NSMoviesDirectory, NSUserDomainMask, YES);
    
    if( 0 == [paths count] ) {
        return nil;
    }

    NSString* moviesPath = [paths objectAtIndex:0];
    
    CAFile* answer = [[CAFile alloc] initWithPathname:moviesPath];
    return answer;
    
}


// tag can be nil
-(JBJsonObject*)toRootFileInfoForName:(NSString*)name path:(NSString*)path tag:(NSString*)tag { 
    

    JBJsonObject* answer = [[JBJsonObject alloc] init];
    
    [answer setObject:name forKey:@"name"];
    [answer setObject:path forKey:@"path"];
    
    if( nil != tag ) { 
        
        JBJsonArray* tagsInfo = [[JBJsonArray alloc] init];        
        {
            [tagsInfo add:tag];
            [answer setObject:tagsInfo forKey:@"tags"];            
        }
        
    }
    
    return answer;
    
}

// tag can be nil
-(JBJsonObject*)toRootFileInfo:(CAFile*)file tag:(NSString*)tag {
    
    return [self toRootFileInfoForName:[file getName] path:[file getPath] tag:tag];

}

-(JBJsonArray*)listRootPlaces {
    
    Log_enteredMethod();
    
    JBJsonArray* answer = [[JBJsonArray alloc] init];

    
    // 'computer' folder ...
    {
        CAFile* computer = [self getComputer];
        if( nil != computer ) { 
            JBJsonObject* computerInfo = [self toRootFileInfo:computer tag:@"computer"];
            [answer add:computerInfo];
            
        }
    }
    
    // 'home' folder 
    {
        CAFile* homeFolder = [self getHome];
        if( nil != homeFolder ) { 
            JBJsonObject* homeInfo = [self toRootFileInfo:homeFolder tag:@"home"];
            [answer add:homeInfo];
        }
    }
    
    // desktop folder ...
    {
        CAFile* desktop = [self getDesktop];
        if( nil != desktop ) { 
            JBJsonObject* desktopInfo = [self toRootFileInfo:desktop tag:@"desktop"];
            [answer add:desktopInfo];                                
        }
        
    }
    
    // Documents ...
    {
        CAFile* documents = [self getDocuments];
        if( nil != documents )  {
            JBJsonObject* documentsInfo = [self toRootFileInfo:documents tag:@"documents"];
            [answer add:documentsInfo];
        }
    }
    
    // Downloads
    {
        CAFile* downloads = [self getDownloads];
        if( nil != downloads ) { 
            JBJsonObject* downloadsInfo = [self toRootFileInfo:downloads tag:@"downloads"];
            [answer add:downloadsInfo];
        }
    }
    
    // Music 
    {
        CAFile* music = [self getMusic];
        if( nil != music ) { 
            JBJsonObject* musicInfo = [self toRootFileInfo:music tag:@"music"];
            [answer add:musicInfo];
        }
    }
    
    // Video
    {
        CAFile* videos = [self getVideos];
        if( nil != videos ) { 
            JBJsonObject* videosInfo = [self toRootFileInfo:videos tag:@"videos"];
            [answer add:videosInfo];
        }
    }
    
    return answer;
    
}

-(JBJsonArray*)listRootDevices {
    
    Log_enteredMethod();
    
    JBJsonArray* answer = [[JBJsonArray alloc] init];
    
    
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    
    // vvv issue with 64-bit 'archive' builds comparing type OSStatus to 'nsvErr' and 'noErr'
    
    long longNsvErr = nsvErr;
    long longNoErr = noErr;
    
    // ^^^ issue with 64-bit 'archive' builds comparing type OSStatus to 'nsvErr' and 'noErr'
    
    
    // vvv derived from XCode sample project 'FSMegaInfo', file 'FileManager.c', method 'PrintFSGetVolumeInfo'
    
    // vvv issue with 64-bit 'archive' builds comparing type OSStatus to 'nsvErr' and 'noErr'
    
    long errStatus = 0;
    
    //OSStatus errStatus;
    // ^^^ issue with 64-bit 'archive' builds comparing type OSStatus to 'nsvErr' and 'noErr'
    
    
    FSVolumeRefNum volRefNum = kFSInvalidVolumeRefNum;
    ItemCount       volIndex = 1;
    FSVolumeRefNum      realVolRefNum;
    int             options;
    FSVolumeInfo    volInfo;
    HFSUniStr255    volName;
    FSRef volumeFSRef;
    
    
    // When indexing through the list of mounted volumes, you may encounter an error
    // with a particular volume. The terminating error code for full traversal of
    // this list is nsvErr. In order to completely traverse the entire list, you
    // may have to bump the index count when encountering other errors (for example, ioErr).
    for( ; errStatus != longNsvErr; volIndex++ ) {
        
        
        errStatus = FSGetVolumeInfo(volRefNum, volIndex, &realVolRefNum, options, &volInfo, &volName, &volumeFSRef);
        
        if (errStatus == longNoErr) {
            
            
            // vvv https://developer.apple.com/carbon/tipsandtricks.html#CFStringFromUnicode
            
            NSString* volNameString = (NSString*)CFBridgingRelease(CFStringCreateWithCharacters( kCFAllocatorDefault, volName.unicode, volName.length ));
            
            // ^^^ https://developer.apple.com/carbon/tipsandtricks.html#CFStringFromUnicode
            
            // vvv http://stackoverflow.com/questions/2033077/cocoa-objective-c-for-os-x-get-volume-mount-point-from-path
            
            NSURL *url = (NSURL *)CFBridgingRelease(CFURLCreateFromFSRef(NULL, &volumeFSRef));
            NSString *path = [url path];
            
            // ^^^ http://stackoverflow.com/questions/2033077/cocoa-objective-c-for-os-x-get-volume-mount-point-from-path
            
            Log_debugString( path );
            
            JBJsonObject* deviceInfo = [self toRootFileInfoForName:volNameString path:path tag:nil];
            [answer add:deviceInfo];
            
            
        } else {
            //            char status[5];
            //            [self formatOSStatus:status withStatus:err];
            Log_infoFormat( @"errStatus = %d; volIndex = %d", errStatus, volIndex);
        }
    }
    
    // ^^^ derived from XCode sample project 'FSMegaInfo', file 'FileManager.c', method 'PrintFSGetVolumeInfo'
    
#else 
    
    Log_warn(@"!defined(__MAC_OS_X_VERSION_MIN_REQUIRED)");
    
#endif

    return answer;
    
}


+(void)listPath:(NSString*)path files:(NSMutableArray*)files folders:(NSMutableArray*)folders sort:(NSString*)sort ascending:(BOOL)ascending {
    
    Log_enteredMethod();
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    NSError* error = nil;
    NSArray* contentsOfDirectory = [defaultManager contentsOfDirectoryAtPath:path error:&error];
    
    if( nil != error ) { 
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"[NSFileManager contentsOfDirectoryAtPath:error:]" failedWithError:error];
        @throw  e;
    }
    
    if( nil == contentsOfDirectory  ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"nil == contentsOfDirectory; path = '%@'", path];
        @throw e;
    }

    for( NSString* directoryEntry in contentsOfDirectory ) { 
        
        CAFile* file = [[CAFile alloc] initWithParentPathname:path child:directoryEntry];
        {
            if( ![HLFileService fileIsBlacklisted:file] ) {
                
                if( [file isFile] ) { 
                    [files addObject:file];
                    
                } else if( [file isDirectory] ) {
                    
                    [folders addObject:file];
                    
                }
            }
            
        }
       
    }

    if( [_SORT_BY_AGE isEqualToString:sort] ) { 
        
        if( ascending ) { 
            [files sortUsingFunction:HLFileSorters_sortByAgeAscending context:NULL];
            [folders sortUsingFunction:HLFileSorters_sortByNameAscending context:NULL];
        } else {
            [files sortUsingFunction:HLFileSorters_sortByAgeDescending context:NULL];
            [folders sortUsingFunction:HLFileSorters_sortByNameAscending context:NULL];
        }
    } else if( [_SORT_BY_SIZE isEqualToString:sort] ) { 
        
        if( ascending ) { 
            
            [files sortUsingFunction:HLFileSorters_sortBySizeAscending context:NULL];
            [folders sortUsingFunction:HLFileSorters_sortByNameAscending context:NULL];
            
        } else {
            
            [files sortUsingFunction:HLFileSorters_sortBySizeDescending context:NULL];
            [folders sortUsingFunction:HLFileSorters_sortByNameAscending context:NULL];
        }
    } else {
        
        if( ![_SORT_BY_NAME isEqualToString:sort] ) { 
            Log_warnString( sort );
        }

        if( ascending ) { 
            
            [files sortUsingFunction:HLFileSorters_sortByNameAscending context:NULL];
            [folders sortUsingFunction:HLFileSorters_sortByNameAscending context:NULL];
            
        } else {
            
            [files sortUsingFunction:HLFileSorters_sortByNameDescending context:NULL];
            [folders sortUsingFunction:HLFileSorters_sortByNameDescending context:NULL];
        }
    }

}


// sort = "name" or "age"
// order = "ascending" or "descending"
-(JBJsonObject*)listFolderPath:(NSString*)folderPath sort:(NSString*)sort ascending:(BOOL)ascending { 
    
    
    CAFile* taHLet = [[CAFile alloc] initWithPathname:folderPath];
    
    // validate ... 
    {

        if( [HLFileService fileIsBlacklisted:taHLet] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"[FileService fileIsBlacklisted:taHLet]; folderPath = '%@'", folderPath];
            [e setFaultCode:_FILE_TYPE_IS_BLACKLISTED];
            @throw e;
        }
        
        if( ![taHLet exists] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![taHLet exists]; folderPath = '%@'", folderPath];
            [e setFaultCode:_FOLDER_DOES_NOT_EXIST];
            @throw e;        
        }


        if( ![taHLet isDirectory] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![taHLet isDirectory]; folderPath = '%@'", folderPath];
            [e setFaultCode:_FOLDER_PATH_REFERENCES_FILE];
            @throw e;        
        }


        if( ![taHLet canRead] ) { 
            BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultStringFormat:@"![taHLet canRead]; folderPath = '%@'", folderPath];
            [e setFaultCode:_CANNOT_READ];
            @throw e;        
        }
    }
    
    JBJsonObject* answer = [[JBJsonObject alloc] init];
    
    [answer setObject:folderPath forKey:@"folderPath"];
    [answer setLongLong:[taHLet getFreeSpace] forKey:@"freeSpace"];
    [answer setObject:@"/" forKey:@"folderSeparator"];
    [answer setBool:ascending forKey:@"ascendingOrder"];
    
    if( [_SORT_BY_AGE isEqualToString:sort] ) {
        [answer setObject:sort forKey:@"sortBy"];
    } else if( [_SORT_BY_SIZE isEqualToString:sort] ) {
        [answer setObject:sort forKey:@"sortBy"];
    } else {
        if( [_SORT_BY_NAME isEqualToString:sort] ) {
            Log_warnString( sort );
            sort = _SORT_BY_NAME;
        }
        [answer setObject:sort forKey:@"sortBy"];
    }
    
    
    
    JBJsonArray* jsonFiles = [[JBJsonArray alloc] init];
    {
        [answer setObject:jsonFiles forKey:@"files"];
    }

    JBJsonArray* jsonFolders = [[JBJsonArray alloc] init];
    {
        [answer setObject:jsonFolders forKey:@"folders"];        
    }

    {
        
        NSMutableArray* files = [[NSMutableArray alloc] init];
        NSMutableArray* folders = [[NSMutableArray alloc] init];
        {
            
            [HLFileService listPath:[taHLet getPath] files:files folders:folders sort:sort ascending:ascending];
            
            for( CAFile* file in files ) {
                [jsonFiles add:[file getName]];
            }
            
            for( CAFile* folder in folders ) {
                [jsonFolders add:[folder getName]];
            }

        }
    }
    
    return answer;

}



-(void)ping {
    Log_enteredMethod();
}


#pragma mark <Service> implementation 


//	public BrokerMessage process( BrokerMessage message );
-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
    
    
    NSString* methodName = [request methodName];
    
    if( [@"abort" isEqualToString:methodName] ) { 

        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* transactionId = [associativeParamaters stringForKey:@"transactionId"];
        
        [self abort:transactionId];
        
        return [JBBrokerMessage buildResponse:request];

    }
    
    
    if( [@"beginPull" isEqualToString:methodName] ) { 
        
        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* filePath = [HLFilePathUtilities getFilePath:associativeParamaters];
        
        associativeParamaters = [self beginPull:filePath];
        
        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        [answer setAssociativeParamaters:associativeParamaters];
        return answer;
        
    }
    
    if( [@"beginPush" isEqualToString:methodName] ) { 
        
        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* filePath = [HLFilePathUtilities getFilePath:associativeParamaters];
        long fileLength = [associativeParamaters longForKey:@"fileLength"];
        
        associativeParamaters = [self beginPush:filePath fileLength:fileLength];
        
        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        [answer setAssociativeParamaters:associativeParamaters];
        return answer;
    }
    
    if( [@"commit" isEqualToString:methodName] ) { 

        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* transactionId = [associativeParamaters stringForKey:@"transactionId"];
        
        [self commit:transactionId];
        
        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        return answer;
    }
    
    
    if( [@"getFileInfo" isEqualToString:methodName] ) { 
        
        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* filePath = [HLFilePathUtilities getFilePath:associativeParamaters];
        
        JBJsonObject* fileInfo = [self getFileInfo:filePath];

        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        [answer setAssociativeParamaters:fileInfo];
        return answer;
        
    }
    
    if( [@"listFolder" isEqualToString:methodName] ) { 

        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* folderPath = [HLFilePathUtilities getFolderPath:associativeParamaters];
        NSString* sort = [associativeParamaters stringForKey:@"sortBy" defaultValue:[HLFileService SORT_BY_NAME]];
        bool ascending = [associativeParamaters boolForKey:@"ascendingOrder" defaultValue:true];
        
        JBJsonObject* listing = [self listFolderPath:folderPath sort:sort ascending:ascending];
        
        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        [answer setAssociativeParamaters:listing];
        return answer;

    }
    
    if( [@"listRoots" isEqualToString:methodName] ) { 
        
        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        JBJsonObject* associativeParamaters = [answer associativeParamaters];
        
        
        {
            JBJsonObject* properties = [[JBJsonObject alloc] init];
            {
                [properties setObject:@"/" forKey:@"folderSeparator"];
                [associativeParamaters setObject:properties forKey:@"properties"];
            }
        }
        
        JBJsonArray* rootDevices = [self listRootDevices];
        [associativeParamaters setObject:rootDevices forKey:@"devices"];
        
        JBJsonArray* rootFolders = [self listRootPlaces];
        [associativeParamaters setObject:rootFolders forKey:@"places"];
        
        return answer;
        
    }
    
    if( [@"ping" isEqualToString:methodName] ) {
        
        [self ping];
        
        return [JBBrokerMessage buildResponse:request];
        
    }

    
    if( [@"resumePush" isEqualToString:methodName] ) { 
        
        JBJsonObject* associativeParamaters = [request associativeParamaters];
        NSString* transactionId = [associativeParamaters stringForKey:@"transactionId"];
        NSString* filePath = [HLFilePathUtilities getFilePath:associativeParamaters];
        long fileLength = [associativeParamaters longForKey:@"fileLength"];

        associativeParamaters = [self resumePush:transactionId filePath:filePath fileLength:fileLength];
        
        
        JBBrokerMessage* answer = [JBBrokerMessage buildResponse:request];
        [answer setAssociativeParamaters:associativeParamaters];
        return answer;
        
    }
	
    
    @throw [JBServiceHelper methodNotFound:self request:request];
	
}



-(JBServiceDescription*)serviceDescription {
    return _SERVICE_DESCRIPTION;
}


#pragma mark instance lifecycle


-(id)initWithFileTransactionManager:(HLFileTransactionManager*)fileJobManager {
    
    HLFileService* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setFileJobManager:fileJobManager];
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setFileJobManager:nil];
	
	
}

#pragma mark fields

// fileJobManager
//FileTransactionManager* _fileJobManager;
//@property (nonatomic, retain) FileTransactionManager* fileJobManager;
@synthesize fileJobManager = _fileJobManager;


@end
