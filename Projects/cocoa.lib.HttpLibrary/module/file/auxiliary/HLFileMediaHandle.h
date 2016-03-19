//
//  AVMediaHandle.h
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLMediaHandle.h"

@interface HLFileMediaHandle : NSObject <HLMediaHandle> {

    
    // contentSource
    NSURL* _contentSource;
    //@property (nonatomic, retain) NSURL* contentSource;
    //@synthesize contentSource = _contentSource;
    
    // contentLength
	unsigned long long _contentLength;
	//@property (nonatomic) long long contentLength;
	//@synthesize contentLength = _contentLength;
    
    // mimeType
    NSString* _mimeType;
    //@property (nonatomic, retain) NSString* mimeType;
    //@synthesize mimeType = _mimeType;
    
    
    // filename
    NSString* _filename;
    //@property (nonatomic, retain) NSString* filename;
    //@synthesize filename = _filename;
    

    // uriSuffix
    NSString* _uriSuffix;
    //@property (nonatomic, retain) NSString* uriSuffix;
    //@synthesize uriSuffix = _uriSuffix;



}




#pragma mark -
#pragma mark instance lifecycle

-(id)initWithContentSource:(NSURL*)contentSource contentLength:(unsigned long long)contentLength mimeType:(NSString*)mimeType filename:(NSString*)filename;

#pragma mark -
#pragma mark fields

// uriSuffix
//NSString* _uriSuffix;
@property (nonatomic, retain) NSString* uriSuffix;
//@synthesize uriSuffix = _uriSuffix;


@end
