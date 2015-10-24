//
//  RGFile.h
//  remote_gateway
//
//  Created by Richard Long on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGFile : NSObject {

    // fileManager
	NSFileManager* _fileManager;
	//@property (nonatomic, retain) NSFileManager* fileManager;
	//@synthesize fileManager = _fileManager;

    // pathname
	NSString* _pathname;
	//@property (nonatomic, retain) NSString* pathname;
	//@synthesize pathname = _pathname;
    
    
	// isExecutableFile
	NSNumber* _isExecutableFile;
	//@property (nonatomic, retain) NSNumber* isExecutableFile;
	//@synthesize isExecutableFile = _isExecutableFile;

    
	// isReadableFile
	NSNumber* _isReadableFile;
	//@property (nonatomic, retain) NSNumber* isReadableFile;
	//@synthesize isReadableFile = _isReadableFile;

    
    // isWritableFile
	NSNumber* _isWritableFile;
	//@property (nonatomic, retain) NSNumber* isWritableFile;
	//@synthesize isWritableFile = _isWritableFile;

//    
//    // fileExists
//	NSNumber* _fileExists;
//	//@property (nonatomic, retain) NSNumber* fileExists;
//	//@synthesize fileExists = _fileExists;

    
	// absolutePathname
	NSString* _absolutePathname;
	//@property (nonatomic, retain) NSString* absolutePathname;
	//@synthesize absolutePathname = _absolutePathname;
    
	// fileName
	NSString* _fileName;
	//@property (nonatomic, retain) NSString* fileName;
	//@synthesize fileName = _fileName;
    
    // lowercaseFileName
    NSString* _lowercaseFileName;
    //@property (nonatomic, retain) NSString* lowercaseFileName;
    //@synthesize lowercaseFileName = _lowercaseFileName;

    
    // modificationDate
	NSDate* _modificationDate;
	//@property (nonatomic, retain) NSDate* modificationDate;
	//@synthesize modificationDate = _modificationDate;

//    
//    // size
//	NSNumber* _size;
//	//@property (nonatomic, retain) NSNumber* size;
//	//@synthesize size = _size;


}


-(BOOL)canExecute;
-(BOOL)canRead;
-(BOOL)canWrite;
-(BOOL)createNewFile;
-(BOOL)exists;
-(long long)getFreeSpace;

-(NSFileHandle*)toFileHandleForReading;
-(NSInputStream*)toInputStream;
-(NSOutputStream*)toAppendingOutputStream;
-(NSOutputStream*)toOverWritingOutputStream;



-(BOOL)mkdirs;
-(BOOL)isDirectory;
-(BOOL)isFile;
-(NSString*)getAbsolutePath;
-(NSString*)getName;
-(NSString*)getPath;
-(BOOL)delete;
-(long long)length;
-(BOOL)renameTo:(RGFile*)dest;
-(NSDate*)getModificationDate;
//-(NSNumber*)getSize;

-(NSString*)lowercaseFileName;

#pragma mark instance lifecycle 

//-(id)initWithFileManager:(NSFileManager*)fileManager pathname:(NSString*)pathname;
-(id)initWithPathname:(NSString*)pathname;


//-(id)initWithFileManager:(NSFileManager*)fileManager parentPathname:(NSString*)parentPathname child:(NSString*)child;
-(id)initWithParentPathname:(NSString*)parentPathname child:(NSString*)child;


//-(id)initWithFileManager:(NSFileManager*)fileManager parentFile:(RGFile*)parent child:(NSString*)child;
-(id)initWithParentFile:(RGFile*)parent child:(NSString*)child;


@end
