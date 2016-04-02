//
//  VALocalStorage.h
//  vlc_amigo
//
//  Created by rlong on 8/02/13.
//
//

#import <Foundation/Foundation.h>

#import "HLStorageManager.h"


@class HLFileMediaHandle;
@class HLMediaHandleSet;



// see https://developer.apple.com/library/ios/#qa/qa1719/_index.html
// and http://developer.apple.com/library/mac/#documentation/FileManagement/Conceptual/FileSystemProgrammingGUide/FileSystemOverview/FileSystemOverview.html
// and http://www.marco.org/2011/10/13/ios5-caches-cleaning

@interface HLLocalStorage : NSObject <HLStorageManager> {
    

//    // storagePath
//    NSString* _storagePath;
//    //@property (nonatomic, retain) NSString* storagePath;
//    //@synthesize storagePath = _storagePath;
//
//    bool _setupCalled;
    
}

+(NSString*)getFilesPath;

-(uint32_t)fileCount;

-(BOOL)fileExistsWithName:(NSString*)filename;
-(uint64_t)getFreeSpace;


-(HLFileMediaHandle*)mediaHandleWithFilename:(NSString*)filename mimeType:(NSString*)mimeType;
-(HLFileMediaHandle*)mediaHandleWithFilename:(NSString*)filename;

-(BOOL)removeAllFilesSwallowErrors:(BOOL)swallowErrors;

// throws an exception if the file does not exist
-(unsigned long long)sizeOfFileWithName:(NSString*)filename;

//-(void)setup;


-(HLMediaHandleSet*)toMediaHandleSet;

+(void)ensureFilesAreInDocuments;


//#pragma mark -
//#pragma mark instance lifecycle
//
////-(id)initWithSubFolderName:(NSString*)subFolderName;
//-(id)init;


@end
