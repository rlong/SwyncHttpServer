//
//  AVMediaHandle.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "JBStreamEntity.h"

#import "HLFileMediaHandle.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLFileMediaHandle ()

// contentSource
//NSURL* _contentSource;
@property (nonatomic, retain) NSURL* contentSource;
//@synthesize contentSource = _contentSource;

// contentLength
//unsigned long long _contentLength;
@property (nonatomic) unsigned long long contentLength;
//@synthesize contentLength = _contentLength;

// mimeType
//NSString* _mimeType;
@property (nonatomic, retain) NSString* mimeType;
//@synthesize mimeType = _mimeType;

// filename
//NSString* _filename;
@property (nonatomic, retain) NSString* filename;
//@synthesize filename = _filename;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -





@implementation HLFileMediaHandle

#pragma mark - instance lifecycle

-(id)initWithContentSource:(NSURL*)contentSource contentLength:(unsigned long long)contentLength mimeType:(NSString*)mimeType filename:(NSString*)filename {
    
    HLFileMediaHandle* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setContentSource:contentSource];
        [answer setContentLength:contentLength];
        [answer setMimeType:mimeType];
        [answer setFilename:filename];
        
        NSString* uriSuffix = [HLFileMediaHandle uriSuffixForFilename:filename];
        [answer setUriSuffix:uriSuffix];
    }
    
    return answer;
}

-(void)dealloc {
    
    [self setContentSource:nil];
    [self setMimeType:nil];
    [self setFilename:nil];
    [self setUriSuffix:nil];
    
    
}

#pragma mark -


-(unsigned long long)getContentLength {
    return _contentLength;
}

-(NSString*)getFilename {
    
    return _filename;
    
}

-(id<JBEntity>)toEntity {
    
    JBStreamEntity* answer = [[JBStreamEntity alloc] initWithContentSource:_contentSource contentLength:_contentLength mimeType:_mimeType];
    
    return answer;
    
}



-(NSString*)getMimeType {
    return _mimeType;
}


+(NSString*)uriSuffixForFilename:(NSString*)filename {
    
//    NSString* rand = [[JBRandomUtilities generateUuid] substringToIndex:8];
    
    filename = [filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if( NSNotFound != [filename rangeOfString:@"'"].location ) {
        filename = [filename stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    }
    
//    NSString* answer = [NSString stringWithFormat:@"/%@/%@", rand, filename];
    NSString* answer = [NSString stringWithFormat:@"/%@", filename];
    
    return answer;
    
}




#pragma mark - fields


// contentSource
//NSURL* _contentSource;
//@property (nonatomic, retain) NSURL* contentSource;
@synthesize contentSource = _contentSource;


// contentLength
//unsigned long long _contentLength;
//@property (nonatomic) unsigned long long contentLength;
@synthesize contentLength = _contentLength;

// mimeType
//NSString* _mimeType;
//@property (nonatomic, retain) NSString* mimeType;
@synthesize mimeType = _mimeType;

// filename
//NSString* _filename;
//@property (nonatomic, retain) NSString* filename;
@synthesize filename = _filename;

// uriSuffix
//NSString* _uriSuffix;
//@property (nonatomic, retain) NSString* uriSuffix;
@synthesize uriSuffix = _uriSuffix;


@end
