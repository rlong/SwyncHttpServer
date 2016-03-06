//
//  AVRemoteFileReference.h
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLRemoteFileReference : NSObject {
    
    
    // filename
    NSString* _filename;
    //@property (nonatomic, readonly) NSString* filename;
    //@property (nonatomic, retain, readwrite) NSString* filename;
    //@synthesize filename = _filename;
    
    // filesize
    long long _filesize;
    //@property (nonatomic, readonly) long long filesize;
    //@property (nonatomic, assign, readwrite) long long filesize;
    //@synthesize filesize = _filesize;
    
    // uri
    NSString* _uri;
    //@property (nonatomic, readonly) NSString* uri;
    //@property (nonatomic, retain, readwrite) NSString* uri;
    //@synthesize uri = _uri;
    
    
    // extension
    id _extension;
    //@property (nonatomic, retain) id extension;
    //@synthesize extension = _extension;

    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithFilename:(NSString*)filename filesize:(long long)filesize uri:(NSString*)uri;


#pragma mark -
#pragma mark fields

// filename
//NSString* _filename;
@property (nonatomic, readonly) NSString* filename;
//@property (nonatomic, retain, readwrite) NSString* filename;
//@synthesize filename = _filename;

// filesize
//long long _filesize;
@property (nonatomic, readonly) long long filesize;
//@property (nonatomic, assign, readwrite) long long filesize;
//@synthesize filesize = _filesize;


// uri
//NSString* _uri;
@property (nonatomic, readonly) NSString* uri;
//@property (nonatomic, retain, readwrite) NSString* uri;
//@synthesize uri = _uri;

// extension
//id _extension;
@property (nonatomic, retain) id extension;
//@synthesize extension = _extension;

@end
