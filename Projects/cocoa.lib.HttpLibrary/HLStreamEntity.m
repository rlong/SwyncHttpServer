// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CALog.h"
#import "CAInputStreamHelper.h"
#import "CAStreamHelper.h"

#import "HLStreamEntity.h"


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

@interface HLStreamEntity () 

// content
//NSInputStream* _content;
@property (nonatomic, retain) NSInputStream* content;
//@synthesize content = _content;

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



@end 

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLStreamEntity


-(NSInputStream*)getContent {
    
    
    if( nil == _content ) {
        [self setContent:[NSInputStream inputStreamWithURL:_contentSource]];
    }
    
    NSUInteger streamStatus = [_content streamStatus];
    
    if( NSStreamStatusOpen == streamStatus || NSStreamStatusOpening == streamStatus ) {
        _didOpen = false;
    } else {
        
        [_content open];
        _didOpen = true;
        
    }

    return _content;
    
}
-(unsigned long long)getContentLength {
    
    return _contentLength;
}

-(NSString*)md5 {
    
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unsupported"];
    @throw  e;
    
}



-(void)teardownForCaller:(id)caller swallowErrors:(BOOL)swallowException {
    if( _didOpen ) {
        [CAStreamHelper closeStream:_content swallowErrors:swallowException caller:caller];
    } else {
        // someone elses responsibility
    }

}

-(void)writeTo:(NSOutputStream*)destination offset:(unsigned long long)offset length:(unsigned long long)length {

    NSInputStream* content = [self getContent]; // will open the stream if necessary
    
    [CAInputStreamHelper seek:content to:offset];
    [CAInputStreamHelper writeFrom:content toOutputStream:destination count:length];
}



#pragma mark instance lifecycle


-(id)initWithContent:(NSInputStream*)content contentLength:(unsigned long long)contentLength {
    
    HLStreamEntity* answer = [super init];
    
    if( nil != answer ) {
        
        
        [answer setContentLength:contentLength];
        [answer setContent:content];
        
        answer->_didOpen = false;
    }
    
    
    return answer;
    
}


-(id)initWithContentSource:(NSURL*)contentSource contentLength:(uint64_t)contentLength mimeType:(NSString*)mimeType {
    
    HLStreamEntity* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setContentLength:contentLength];
        [answer setContentSource:contentSource];
        [answer setMimeType:mimeType];

        answer->_didOpen = false;
    }
    
    
    return answer;
    
}


-(void)dealloc{
    
    
    
    if( nil != _content ) {

        if( NSStreamStatusOpen == [_content streamStatus] ) {
            if( _didOpen ) {
                Log_warn( @"[HLStreamEntity teardownForCaller:swallowErrors:] not called, will call it now and swallow any errors" );
                [self teardownForCaller:self swallowErrors:YES];
            } else {
                Log_warn(@"NSStreamStatusOpen == [_content streamStatus] && !_didOpen" );
            }
        }
    }
    
	[self setContent:nil];
    [self setContentSource:nil];
	[self setMimeType:nil];

	
}

#pragma mark fields


// content
//NSInputStream* _content;
//@property (nonatomic, retain) NSInputStream* content;
@synthesize content = _content;

// contentSource
//NSURL* _contentSource;
//@property (nonatomic, retain) NSURL* contentSource;
@synthesize contentSource = _contentSource;


// contentLength
//uint64_t _contentLength;
//@property (nonatomic) uint64_t contentLength;
@synthesize contentLength = _contentLength;

// mimeType
//NSString* _mimeType;
//@property (nonatomic, retain) NSString* mimeType;
@synthesize mimeType = _mimeType;

@end
