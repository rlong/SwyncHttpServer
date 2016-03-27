// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CALog.h"
#import "CAStringHelper.h"

#import "HLDelimiterDetector.h"
#import "HLDelimiterFound.h"
#import "HLMultiPartReader.h"
#import "HLPartialDelimiterMatched.h"





////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLMultiPartReader ()


// boundary
//NSString* _boundary;
@property (nonatomic, retain) NSString* boundary;
//@synthesize boundary = _boundary;


// content
//NSInputStream* _content;
@property (nonatomic, retain) NSInputStream* content;
//@synthesize content = _content;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


/// <summary>
///
/// as per http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
/// </summary>
@implementation HLMultiPartReader

#define _BUFFER_SIZE 8 * 1024

const UInt8 _CARRAIGE_RETURN_AND_NEWLINE[2] = {0x0d,0x0a};

+(NSUInteger)BUFFER_SIZE {
    return _BUFFER_SIZE;
}


-(void)fillBuffer {
    
    
    _currentOffset = 0;

    UInt64 amountToRead = _contentRemaining;
    if( amountToRead > _BUFFER_SIZE ) {
        amountToRead = _BUFFER_SIZE;
    }
    

    long bytesRead = [_content read:_buffer maxLength:(NSUInteger)amountToRead];
    if( 0 == bytesRead && 0 != amountToRead) { // `0 == bytesRead` marks the end of the stream
        
        
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"0 == bytesRead && 0 != amountToRead; amountToRead = %d; _contentRemaining = %d", amountToRead, _contentRemaining];
        
    }
    if( 0 > bytesRead ) {
        Log_error(@"0 > bytesRead");
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSInputStream read:maxLength:]" failedWithError:[_content streamError]];
    }
    
    _contentRemaining -= bytesRead;
    _bufferEnd = bytesRead;
    
}


-(UInt8)readByte {
    if( _currentOffset == _bufferEnd ) {
        [self fillBuffer];
    }
    UInt8 answer = _buffer[_currentOffset];
    _currentOffset++;
    return answer;

}


// external use is for testing only
-(NSString*)readLine:(NSMutableData*)stringBuffer {
    
    
    UInt8 lastChar = 88; // 'X'
    
    
    [stringBuffer setLength:0]; // `clear` the stringBuffer
    
    
    while( true ) {
        
        UInt8 currentChar = [self readByte];
        
        if (0x0d == lastChar) {// '\r'
            
            if (0x0a == currentChar) { // `\n`
                
                return [CAStringHelper getUtf8String:stringBuffer];
                
            } else {
                
                [stringBuffer appendBytes:&lastChar length:1]; // add the previous '\r'
                
            }
            
            
        }
        if (0x0d != currentChar) { // '\r'
            
            [stringBuffer appendBytes:&currentChar length:1]; // add the previous '\r'
            
        }
        
        lastChar = currentChar;
        
    }
    
}


// used for testing only
-(id<HLDelimiterIndicator>)skipToNextDelimiterIndicator {
    
    

    HLDelimiterDetector* detector = [[HLDelimiterDetector alloc] initWithBoundary:_boundary];
    
    if( _currentOffset == _bufferEnd) {
        
        [self fillBuffer];
    }
    
    id<HLDelimiterIndicator> indicator = [detector update:_buffer startingOffset:_currentOffset endingOffset:_bufferEnd];
    
    
    if ( nil == indicator)
    {
        return nil;
    }
    
    if( [indicator isKindOfClass:[HLDelimiterFound class]] ) {
        
        HLDelimiterFound* delimiterFound = (HLDelimiterFound*)indicator;
        _currentOffset = [delimiterFound endOfDelimiter];
    }
    
    return indicator;
    
}




// can return null if not indicator was found (partial or complete)
-(HLDelimiterFound*)findFirstDelimiterIndicator:(HLDelimiterDetector*)detector {
    
    if (_currentOffset == _bufferEnd) {
        [self fillBuffer];
    }
    
    id<HLDelimiterIndicator> indicator = [detector update:_buffer startingOffset:_currentOffset endingOffset:_bufferEnd];
    
    if (nil == indicator)
    {
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"null == indicator, could not find first delimiter; _boundary = '%@'", _boundary];
        
    }
    
    if( ![indicator isKindOfClass:[HLDelimiterFound class]] ) {
        Log_error(@"unimplemented: support for `HLDelimiterIndicator` types that are not `HLDelimiterFound`" );
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"![indicator isKindOfClass:[HLDelimiterFound class]]; NSStringFromClass([indicator class]) = '%@'", NSStringFromClass([indicator class])];
    }
    
    return (HLDelimiterFound*)indicator;

}


// will accept `null` values
-(void)writePartialDelimiter:(HLPartialDelimiterMatched*)partialDelimiterMatched partHandler:(id<HLPartHandler>)partHandler {
    
    
    if (nil == partialDelimiterMatched)
    {
        return;
    }
    
    NSData* matchingData = [partialDelimiterMatched matchingData];
    
    [partHandler handleBytes:[matchingData bytes] offset:0 length:[matchingData length]];
    
    
}


-(HLDelimiterFound*)tryProcessPart:(id<HLPartHandler>)partHandler detector:(HLDelimiterDetector*)detector {
    
    NSMutableData* stringBuffer = [[NSMutableData alloc] init];
    
    NSString* line = [self readLine:stringBuffer];
    while( 0 != [line length] ) {
        
        
        NSRange firstColon = [line rangeOfString:@":"];
        
        if( NSNotFound == firstColon.location ) {
            @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"NSNotFound == firstColon.location; line = '%@'", line];
        }
        
        NSString* name = [line substringToIndex:firstColon.location];
        name = [name lowercaseString]; // headers are case insensitive
        
        NSString* value = [line substringFromIndex:firstColon.location+1];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [partHandler handleHeaderWithName:name value:value];
        

        line = [self readLine:stringBuffer];
        
        
    }
    
    HLPartialDelimiterMatched* partialDelimiterMatched = nil;
    
    bool partCompleted = false;
    
    while (!partCompleted) {
        
        id<HLDelimiterIndicator> delimiterIndicator = [detector update:_buffer startingOffset:_currentOffset endingOffset:_bufferEnd];
        
        // nothing detected ?
        if (nil == delimiterIndicator) {
            
            // write existing partial match (if it exists)
            {
                [self writePartialDelimiter:partialDelimiterMatched partHandler:partHandler];
                partialDelimiterMatched = nil;
            }
            
            NSUInteger length = _bufferEnd - _currentOffset;
            [partHandler handleBytes:_buffer offset:_currentOffset length:length];
            [self fillBuffer];
            continue;
        }
        
        if( [delimiterIndicator isKindOfClass:[HLDelimiterFound class]] ) {
            
            HLDelimiterFound* delimiterFound = (HLDelimiterFound*)delimiterIndicator;
            // more content to add ?
            if( ![delimiterFound completesPartialMatch] ) {
                
                // write existing partial match (if it exists)
                {
                    [self writePartialDelimiter:partialDelimiterMatched partHandler:partHandler];
                    partialDelimiterMatched = nil;
                }
                
                NSUInteger length = [delimiterFound startOfDelimiter] - _currentOffset;
                [partHandler handleBytes:_buffer offset:_currentOffset length:length];
                

            } else { // delimiterFound completesPartialMatch
                
                partialDelimiterMatched = nil;
                
            }
            
            _currentOffset = [delimiterFound endOfDelimiter];
            [partHandler partCompleted];
            partCompleted = true; // not required, but signalling intent
            return delimiterFound;
        }
        
        if( [delimiterIndicator isKindOfClass:[HLPartialDelimiterMatched class]] ){
            
            // write existing partial match (if it exists)
            {
                [self writePartialDelimiter:partialDelimiterMatched partHandler:partHandler];
            }
            
            partialDelimiterMatched = (HLPartialDelimiterMatched*)delimiterIndicator;
            NSData* matchingData = [partialDelimiterMatched matchingData];
            NSUInteger startOfMatch = _bufferEnd - [matchingData length];
            if (startOfMatch < _currentOffset) {
                // can happen when the delimiter straddles 2 distinct buffer reads of size `BUFFER_SIZE`
                startOfMatch = _currentOffset;
                
            } else {
                NSUInteger length = startOfMatch - _currentOffset;
                [partHandler handleBytes:_buffer offset:_currentOffset length:length];
            }
            [self fillBuffer];

        }

    }
    
    // will never happen ... we hope
    @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"unexpected code path followed"];

}


-(HLDelimiterFound*)processPart:(id<HLMultiPartHandler>)multiPartHandler detector:(HLDelimiterDetector*)detector {
    
    
    id<HLPartHandler> partHandler = [multiPartHandler foundPartDelimiter];
    
    @try {
        return [self tryProcessPart:partHandler detector:detector];
    }
    @catch (BaseException *exception) {
        [partHandler handleFailure:exception];
        @throw exception;
    }
    

    
}

-(void)tryProcess:(id<HLMultiPartHandler>)multiPartHandler skipFirstCrNl:(bool)skipFirstCrNl {
    
    
    HLDelimiterDetector* detector = [[HLDelimiterDetector alloc] initWithBoundary:_boundary];
    {
        if( skipFirstCrNl ) {
            [detector update:_CARRAIGE_RETURN_AND_NEWLINE startingOffset:0 endingOffset:2];
        }
        
        id<HLDelimiterIndicator> indicator = [self findFirstDelimiterIndicator:detector];
        
        if( nil == indicator ) {
            
            @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"nil == indicator; expected delimiter at start of stream"];
            
        }
        
        if( ![indicator isKindOfClass:[HLDelimiterFound class]] ) {
            
            Log_error(@"unimplemented: support for `HLDelimiterIndicator` types that are not `HLDelimiterFound`");
            @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"![indicator isKindOfClass:[HLDelimiterFound class]]; NSStringFromClass([indicator class]) = '%@'", NSStringFromClass([indicator class])];
            
        }
        
        
        HLDelimiterFound* delimiterFound = (HLDelimiterFound*)indicator;
        
        _currentOffset = [delimiterFound endOfDelimiter];
        
        while( ![delimiterFound isCloseDelimiter] ) {
            
            delimiterFound =  [self processPart:multiPartHandler detector:detector];
            
            
        }
        
    }
    
    
    [multiPartHandler foundCloseDelimiter];
    
    // consume (and discard) any trailing data
    while( 0 != _contentRemaining  ) {
        [self fillBuffer];
    }
    
    
}

-(void)process:(id<HLMultiPartHandler>)multiPartHandler skipFirstCrNl:(bool)skipFirstCrNl {
    
    @try {
        [self tryProcess:multiPartHandler skipFirstCrNl:skipFirstCrNl];
    }
    @catch (BaseException *exception) {
        
        [multiPartHandler handleExceptionZZZ:exception];
    }
}


-(void)process:(id<HLMultiPartHandler>)multiPartHandler {
    [self process:multiPartHandler skipFirstCrNl:false];
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithBoundary:(NSString*)boundary entity:(id<HLEntity>)entity {
    
    HLMultiPartReader* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setBoundary:boundary];
        [answer setContent:[entity getContent]];
        answer->_contentRemaining = [entity getContentLength];
        answer->_buffer = malloc( sizeof(UInt8) * _BUFFER_SIZE  );
        answer->_currentOffset = 0;
        answer->_bufferEnd = 0;
    }
    
    return answer;
}

-(void)dealloc {
	
	[self setBoundary:nil];
	[self setContent:nil];
    
    free( _buffer );

	

}


#pragma mark -
#pragma mark fields

// boundary
//NSString* _boundary;
//@property (nonatomic, retain) NSString* boundary;
@synthesize boundary = _boundary;


// content
//NSInputStream* _content;
//@property (nonatomic, retain) NSInputStream* content;
@synthesize content = _content;


@end
