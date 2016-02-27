//
//  VALocalStorage.m
//  vlc_amigo
//
//  Created by rlong on 8/02/13.
//
//

#include <sys/xattr.h>
#include <UIKit/UIKit.h> // for 'UIDevice' below


#import "JBBaseException.h"
#import "JBFileUtilities.h"
#import "JBFolderUtilities.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBNetworkUtilities.h"

#import "VPFileMediaHandle.h"
#import "VPMediaHandleSet.h"

#import "XPGetFileRequestHandler.h"
#import "XPStorageManagerHelper.h"

#import "VPLocalStorage.h"
#import "VPStorageSelectConductorHelper.h"

#import "RGFileService.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface VPLocalStorage ()

// storagePath
//NSString* _storagePath;
@property (nonatomic, retain) NSString* storagePath;
//@synthesize storagePath = _storagePath;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



// see https://developer.apple.com/library/ios/#qa/qa1719/_index.html
// and "App Backup Best Practices" in `iPhoneAppProgrammingGuide` ( /Volumes/shared-disk/document-library/information-technology/apple.ios/iPhoneAppProgrammingGuide.2013-01-28.pdf)
// and http://developer.apple.com/library/mac/#documentation/FileManagement/Conceptual/FileSystemProgrammingGUide/FileSystemOverview/FileSystemOverview.html
// and http://www.marco.org/2011/10/13/ios5-caches-cleaning
@implementation VPLocalStorage



//static bool _isIos500orLess = false;
//static bool _isIos501 = false;
//static bool _isIos510orGreater = false;
//
//
//static NSString* _rootStoragePath;
//
//
//+(void)initialize {
//    
//    
////    // determine iOS version (_isIos500orLess/_isIos501/_isIos510orGreater) ... 
////    {
////
////        NSUInteger majorVersion = [XPIosVersion majorVersion];
////        NSUInteger minorVersion = [XPIosVersion minorVersion];
////        NSUInteger maintenanceVersion = [XPIosVersion maintenanceVersion];
////        
////        if( majorVersion > 5 ) {
////            _isIos510orGreater = true;
////        } else if( majorVersion == 5 && minorVersion == 1 ) {
////            _isIos510orGreater = true;
////        } else if( majorVersion == 5 && minorVersion == 0 && maintenanceVersion == 1 ) {
////            _isIos501 = true;
////        } else {
////            _isIos500orLess = true;
////        }
////        
////        if( _isIos510orGreater) {
////            Log_infoInt(_isIos510orGreater);
////        }
////        
////        if( _isIos510orGreater) {
////            Log_infoInt(_isIos501);
////        }
////        
////        if( _isIos500orLess) {
////            Log_infoInt(_isIos500orLess);
////        }
////
////    }
////    
////    // determine '_rootStoragePath'
////    {
////     
////        if( _isIos510orGreater ) {
////            // use <Application_Home>/Library/Application Support and apply the `NSURLIsExcludedFromBackupKey`
////            
////            _rootStoragePath = [JBFolderUtilities getApplicationSupportDirectory];
////            
////        } else if ( _isIos501 ) {
////            
////            // use <Application_Home>/Library/Application Support apply the `com.apple.MobileBackup` (http://developer.apple.com/library/mac/#documentation/FileManagement/Conceptual/FileSystemProgrammingGUide/FileSystemOverview/FileSystemOverview.html)
////            
////            _rootStoragePath = [JBFolderUtilities getApplicationSupportDirectory];
////        } else { // assume _isIos500orLess
////            
////            // use <Application_Home> /Library/Caches (App Backup Best Practices" in `iPhoneAppProgrammingGuide`)
////            
////            _rootStoragePath = [JBFolderUtilities getCachesDirectory];
////            
////        }
////    }
//
//    
//}


+(NSString*)getFilesPath {
    return [JBFolderUtilities getDocumentDirectory];
}


#pragma mark -
#pragma mark <AVStorageManager> implementation



-(void)closeOutputStream:(NSOutputStream*)outputStream withFilename:(NSString*)filename {
    
    [outputStream close];
    
    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];
    NSString* fullPath = [parentFolder stringByAppendingPathComponent:filename];

    
    ////////////////////////////////////////////////////////////////
    // stop backups of files

    // vvv https://developer.apple.com/library/ios/#qa/qa1719/_index.html
    
    NSError *error = nil;
    
    NSURL* fullPathUrl = [NSURL fileURLWithPath:fullPath isDirectory:false];
    [fullPathUrl setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    // ^^^ https://developer.apple.com/library/ios/#qa/qa1719/_index.html
    
    if( nil != error ) {
        Log_warnError( error );
    }

    
//    if( _isIos510orGreater ) {
//        
//        // vvv https://developer.apple.com/library/ios/#qa/qa1719/_index.html
//        
//        NSError *error = nil;
//        
//        NSURL* fullPathUrl = [NSURL fileURLWithPath:fullPath isDirectory:false];
//        
//        [fullPathUrl setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
//        
//        // ^^^ https://developer.apple.com/library/ios/#qa/qa1719/_index.html
//        
//        if( nil != error ) {
//            Log_warnError( error );
//        }
//        
//        
//    } else if ( _isIos501 ) {
//        
//        
//        // vvv https://developer.apple.com/library/ios/#qa/qa1719/_index.html
//        
//        const char* utf8FullPath = [fullPath UTF8String];
//        
//        const char* attrName = "com.apple.MobileBackup";
//        
//        u_int8_t attrValue = 1;
//        
//        int result = setxattr(utf8FullPath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//        
//        
//        // ^^^ https://developer.apple.com/library/ios/#qa/qa1719/_index.html
//        
//        
//        if( 0 != result ) {
//            Log_warnCallFailed(@"setxattr", errno);
//        }
//        
//        
//    } else  { // assume _isIos500orLess
//        
//        // no-op ...
//        
//        // https://developer.apple.com/library/ios/#qa/qa1719/_index.html ...
//        // If your app must support iOS 5.0, then you will need to store your app data in Caches to avoid that data being backed up.
//        
//        // http://www.marco.org/2011/10/13/ios5-caches-cleaning ...
//        // Instapaper has stored its downloaded articles in Caches for years, since I didn’t want to slow down iTunes syncing for my customers or enlarge their backups unnecessarily, and full restores don’t happen often enough for it to be a problem for most people.
//    }


    
}


-(uint32_t)fileCount {
    
    uint32_t answer = 0;
    
    
    
    NSMutableArray* files = [[NSMutableArray alloc] init];
    NSMutableArray* folders = [[NSMutableArray alloc] init];
    {
        
        NSString* fileSystemPath = [JBFolderUtilities getDocumentDirectory];
        NSString* sort = [RGFileService SORT_BY_NAME];
        
        [RGFileService listPath:fileSystemPath files:files folders:folders sort:sort ascending:true];
        
        answer = (uint32_t)[files count];
        
    }
    
    return answer;
    
}
//// vvv scraped from RGFileService
//
//+(BOOL)fileIsBlacklisted:(XPFile*)candidate {
//    
//    NSString* candidateName = [[candidate getName] lowercaseString];
//    
//    if( [candidateName hasPrefix:@"."] ) {
//        return  true;
//    }
//    
//    if( [candidateName hasSuffix:@"json"] ) {
//        return true;
//    }
//    
//    return false;
//}
//
//// ^^^ scraped from RGFileService
//
//
//
//-(uint32_t)fileCount {
//    
//    uint32_t answer = 0;
//
//    NSString* documentDirectoryPath = [JBFolderUtilities getDocumentDirectory];
//    XPFile* documentDirectory = [[XPFile alloc] initWithPathname:documentDirectoryPath];
//    JBAutorelease( documentDirectory );
//    
//    NSArray* listing = [documentDirectory list];
//    
//    for( NSString* childsName in listing ) {
//        
//    
//        XPFile* child = [[XPFile alloc] initWithParentFile:documentDirectory child:childsName];
//        if( [child isFile] && ![XPLocalStorage fileIsBlacklisted:child] ) {
//            answer++;
//        }
//        JBRelease( child );
//        
//    }
//    
//    return answer;
//
//    
//}


-(BOOL)fileExistsWithName:(NSString*)filename {
    
    
    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];

    return [JBFileUtilities fileWithName:filename existsInFolder:parentFolder];
}

-(uint64_t)getFreeSpace {

    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];

    return [XPStorageManagerHelper getFreeSpaceForPath:parentFolder];
    
}


-(NSInputStream*)inputStreamWithFilename:(NSString*)filename {

    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];

    NSString* fullPath = [parentFolder stringByAppendingPathComponent:filename];
    
    NSInputStream* answer = [NSInputStream inputStreamWithFileAtPath:fullPath];
    
    return answer;
    
}

-(VPFileMediaHandle*)mediaHandleWithFilename:(NSString*)filename mimeType:(NSString*)mimeType {
    
    
    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];
    
    NSString* fullPath = [parentFolder stringByAppendingPathComponent:filename];
    NSURL* url = [NSURL fileURLWithPath:fullPath];
    uint64_t contentLength = [JBFileUtilities getFileLength:fullPath];
    VPFileMediaHandle* answer = [[VPFileMediaHandle alloc] initWithContentSource:url contentLength:contentLength mimeType:mimeType filename:filename];
    
    return answer;
    
}

-(VPFileMediaHandle*)mediaHandleWithFilename:(NSString*)filename {
    
    return [self mediaHandleWithFilename:filename mimeType:nil];
    
}


-(NSOutputStream*)outputStreamWithFilename:(NSString*)filename append:(BOOL)append {
    
    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];
    
    NSString* fullPath = [parentFolder stringByAppendingPathComponent:filename];
    
    
    NSOutputStream* answer = [NSOutputStream outputStreamToFileAtPath:fullPath append:append];
    
    return answer;
}


-(BOOL)removeAllFilesSwallowErrors:(BOOL)swallowErrors {
    
    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];
    
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    NSError* error = nil;
    NSArray* contentsOfDirectory = [defaultManager contentsOfDirectoryAtPath:parentFolder error:&error];
    
    if( nil != error ) {
        
        if( swallowErrors ) {
            Log_warnError(error);
            return false;
        }
        JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSFileManager contentsOfDirectoryAtPath:error:]" failedWithError:error];
        [e addStringContext:parentFolder withName:@"parentFolder"];
        @throw  e;
    }

    // vvv not sure this is necessary (but this was in the [RGFileService listPath:files:folders:sort:ascending:] ...
    {
        if( nil == contentsOfDirectory  ) {
            if( swallowErrors ) {
                Log_warnFormat( @"nil == contentsOfDirectory; parentFolder = '%@'", parentFolder );
                return false;
            }
            JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"nil == contentsOfDirectory"];
            [e addStringContext:parentFolder withName:@"parentFolder"];
            @throw  e;
        }
    }
    // ^^^ not sure this is necessary (but this was in the [RGFileService listPath:files:folders:sort:ascending:] ...


    
    bool answer = true;
    
    for( NSString* filename in contentsOfDirectory ) {

        if( ![XPStorageManagerHelper removeFileWithName:filename inFolder:parentFolder swallowErrors:swallowErrors] ) {

            answer = false;
        }
    }
    
    return answer;


}

-(BOOL)removeFileWithName:(NSString*)filename swallowErrors:(BOOL)swallowErrors {

    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];

    return [XPStorageManagerHelper removeFileWithName:filename inFolder:parentFolder swallowErrors:swallowErrors];
    
}

// throws an exception if the file does not exist
-(unsigned long long)sizeOfFileWithName:(NSString*)filename {

    NSString* parentFolder = [JBFolderUtilities getDocumentDirectory];

    return [XPStorageManagerHelper sizeOfFileWithName:filename inFolder:parentFolder];
}



-(VPMediaHandleSet*)toMediaHandleSetWithFiles:(NSArray*)files {
    
//    NSString* urlTemplate;
//    {
//        JBIPAddress* wifiIpAddress = [JBNetworkUtilities getWifiIpAddress];
//        NSString* wifiIpAddressString = [wifiIpAddress toString];
//        
//        urlTemplate = [NSString stringWithFormat:@"http://%@:%d%@", wifiIpAddressString, [XPHttpServer PORT], [XPGetFileRequestHandler REQUEST_HANDLER_URI]];
//        
//        Log_debugString( urlTemplate );
//        
//    }
    
    VPMediaHandleSet* answer;
    {
        NSMutableArray* mediaHandleArray = [[NSMutableArray alloc] init];
        
        for( NSUInteger i = 0, count = [files count]; i < count; i++ ) {
            
            RGFile* file = [files objectAtIndex:i];
            
            NSString* filename = [file getName];
            NSString* contentType = [VPStorageSelectConductorHelper getContentTypeForLocalStorageFilename:filename];

            VPFileMediaHandle* mediaHandle = [self mediaHandleWithFilename:filename mimeType:contentType];
            [mediaHandleArray addObject:mediaHandle];

        }


        answer = [[VPMediaHandleSet alloc] initWithMediaHandles:mediaHandleArray];

    }
    return answer;
    
    

}



-(VPMediaHandleSet*)toMediaHandleSet {
    
    VPMediaHandleSet* answer;
    
    NSString* fileSystemPath = [JBFolderUtilities getDocumentDirectory];
    
    NSMutableArray* files = [[NSMutableArray alloc] init];
    NSMutableArray* folders = [[NSMutableArray alloc] init];
    {
        
        NSString* sort = [RGFileService SORT_BY_NAME];
        [RGFileService listPath:fileSystemPath files:files folders:folders sort:sort ascending:true];
       
        
        answer = [self toMediaHandleSetWithFiles:files];
        
        
    }


    return answer;
    
    
}


#pragma mark -


//-(NSString*)getFileSystemPath {
//    
//    if( !_setupCalled ){
//        Log_warnFormat(@"!_setupCalled; [XPLocalStorage setup] should have been called before. ");
//        [self setup];
//        
//    }
//    
//    return _rootStoragePath;
//    
//}



+(void)ensureDocumentDirectoryIsNotBackedUp {
    Log_enteredMethod();
    
    NSString* documentDirectory = [JBFolderUtilities getDocumentDirectory];
    
    
    NSError* error = nil;

    
    // vvv https://developer.apple.com/library/ios/#qa/qa1719/_index.html

    NSURL* documentUrl = [NSURL fileURLWithPath:documentDirectory isDirectory:true];

    [documentUrl setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    // ^^^ https://developer.apple.com/library/ios/#qa/qa1719/_index.html
    
    if( nil != error ) {
        Log_warnError( error );
    }

}


+(void)ensureFilesAreInDocuments {
    
    Log_enteredMethod();
    
    [self ensureDocumentDirectoryIsNotBackedUp];
    
    NSString* storageFolder = [JBFolderUtilities getApplicationSupportDirectory];
    // NSString* storageFolder = [applicationSupportDirectory stringByAppendingString:@"/AVLocalStorage"]; // 'AVLocalStorage' for legacy reasons
    Log_debugString(storageFolder);
    
    if( ![JBFolderUtilities directoryExistsAtPath:storageFolder] ) {
        return; // nothing to do;
    }

    NSFileManager* defaultManager = [NSFileManager defaultManager];
    NSError* error = nil;
    NSArray* contentsOfDirectory = [defaultManager contentsOfDirectoryAtPath:storageFolder error:&error];
    
    if( nil != error ) {
        Log_warnError( error );
        return;
    }
    
    for( NSString* directoryEntry in contentsOfDirectory ) {
        
        Log_debugString( directoryEntry );
        
        NSString* sourcePath = [NSString stringWithFormat:@"%@/%@", storageFolder, directoryEntry];
        if( ![JBFileUtilities isFile:sourcePath] ) {
            continue;
        }
        
        NSString* destinationPath = [NSString stringWithFormat:@"%@/%@", [JBFolderUtilities getDocumentDirectory], directoryEntry];
        Log_infoFormat(@"moving '%@' to '%@'", sourcePath, destinationPath );
        
        @try {
            [JBFileUtilities moveItemAtPath:sourcePath toPath:destinationPath];
            
            // shouldn't be required (any previously uploaded files will be marked as excluded from backup ...
            // but we mark the file as not being for backup anyways ...
            NSURL* fullPathUrl = [NSURL fileURLWithPath:destinationPath isDirectory:false];
            [fullPathUrl setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];

        }
        @catch (NSException *exception) {
            Log_errorException( exception );
        }
        
        
    }
    
}


//-(void)setup {
//    
//    
//    // marks documents folder so that it will be expluded from iCloud
//    {
//        
//    }
//    
//    if( ![JBFolderUtilities directoryExistsAtPath:_storagePath] ) {
//        [JBFolderUtilities mkdirs:_storagePath];
//    }
//    
//    
//    
////    ////////////////////////////////////////////////////////////////
////    // stop backups of files
////    
////    if( _isIos510orGreater ) {
////        
////        // vvv https://developer.apple.com/library/ios/#qa/qa1719/_index.html
////        
////        NSError *error = nil;
////        
////        NSURL* fullPathUrl = [NSURL fileURLWithPath:_storagePath isDirectory:true];
////        
////        [fullPathUrl setResourceValue:[NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
////
////        // ^^^ https://developer.apple.com/library/ios/#qa/qa1719/_index.html
////        
////        if( nil != error ) {
////            Log_warnError( error );
////        }
////        _setupCalled = true;
////
////        
////    } else if ( _isIos501 ) {
////
////
////        // vvv https://developer.apple.com/library/ios/#qa/qa1719/_index.html
////
////        const char* utf8FullPath = [_storagePath UTF8String];
////        
////        const char* attrName = "com.apple.MobileBackup";
////        
////        u_int8_t attrValue = 1;
////        
////        int result = setxattr(utf8FullPath, attrName, &attrValue, sizeof(attrValue), 0, 0);
////
////        
////        // ^^^ https://developer.apple.com/library/ios/#qa/qa1719/_index.html
////
////
////        if( 0 != result ) {
////            Log_warnCallFailed(@"setxattr", errno);
////        }
////
////        _setupCalled = true;
////        
////    } else  { // assume _isIos500orLess
////        
////        // no-op ...
////        
////        // https://developer.apple.com/library/ios/#qa/qa1719/_index.html ...
////        // If your app must support iOS 5.0, then you will need to store your app data in Caches to avoid that data being backed up.
////        
////        // http://www.marco.org/2011/10/13/ios5-caches-cleaning ...
////        // Instapaper has stored its downloaded articles in Caches for years, since I didn’t want to slow down iTunes syncing for my customers or enlarge their backups unnecessarily, and full restores don’t happen often enough for it to be a problem for most people.
////        
////        _setupCalled = true;
////
////    }
//    
//}
//
//
//
//#pragma mark -
//#pragma mark instance lifecycle
//
//-(id)initWithSubFolderName:(NSString*)subFolderName {
//    
//    XPLocalStorage* answer = [super init];
//    if( nil != answer ) {
//        
//        // vvv 'AVLocalStorage' for legacy reasons
//        NSString* storagePath = [_rootStoragePath stringByAppendingPathComponent:subFolderName];
//        // ^^^ 'AVLocalStorage' for legacy reasons
//        
//        Log_debugString( storagePath );
//        [answer setStoragePath:storagePath];
//        
//        answer->_setupCalled = false;
//        
//    }
//    
//    return answer;
//}
//
//
//-(id)init {
//    
//    // vvv 'AVLocalStorage' for legacy reasons
//    return [self initWithSubFolderName:@"AVLocalStorage"];
//    // ^^^ 'AVLocalStorage' for legacy reasons
//    
//}
//
//-(void)dealloc {
//	
//    [self setStoragePath:nil];
//
//	[super dealloc];
//	
//}
//
//
//#pragma mark -
//#pragma mark fields
//
//
//// storagePath
////NSString* _storagePath;
////@property (nonatomic, retain) NSString* storagePath;
//@synthesize storagePath = _storagePath;
//
//
@end
