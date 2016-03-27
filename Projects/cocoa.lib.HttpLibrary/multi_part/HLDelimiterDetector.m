// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CAStringHelper.h"

#import "HLDelimiterDetector.h"
#import "HLDelimiterFound.h"
#import "HLPartialDelimiterMatched.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLDelimiterDetector ()


// delimiterData
//NSData* _delimiterData;
@property (nonatomic, retain) NSData* delimiterData;
//@synthesize delimiterData = _delimiterData;


// closeDelimiterData
//NSData* _closeDelimiterData;
@property (nonatomic, retain) NSData* closeDelimiterData;
//@synthesize closeDelimiterData = _closeDelimiterData;


// currentDelimiterData
//NSData* _currentDelimiterData;
@property (nonatomic, retain) NSData* currentDelimiterData;
//@synthesize currentDelimiterData = _currentDelimiterData;



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLDelimiterDetector 


-(void)reset {
 
    [self setCurrentDelimiterData:_delimiterData];
    _currentMatchingDelimiterIndex = 0;

}

-(id<HLDelimiterIndicator>)update:(const UInt8*)buffer startingOffset:(NSUInteger)startingOffset endingOffset:(NSUInteger)endingOffset {
    
    
    bool partialDelimiterMatched = false;
    
    if( 0 != _currentMatchingDelimiterIndex ) {
        
        partialDelimiterMatched = true;
        
    }
    
    const UInt8* currentDelimiterBytes = [_currentDelimiterData bytes];
    
    
    
    for (NSUInteger i = startingOffset; i < endingOffset; i++) {
        
        
        if (0 == _currentMatchingDelimiterIndex)  { //  not previously matched (previous byte != `\r`)
            
            // vvv function ?

            if( buffer[i] ==  currentDelimiterBytes[_currentMatchingDelimiterIndex] ) {
                _currentMatchingDelimiterIndex = 1;
            }
            // ^^^ function ?
          
            continue;

        }
        
        
        bool resetRequired = false;
        
        if (4 > _currentMatchingDelimiterIndex) { //  only during a `\r\n--` sequence
            
            
            if (buffer[i] == currentDelimiterBytes[_currentMatchingDelimiterIndex])
            {
                _currentMatchingDelimiterIndex++;
            }
            else { // reset
                resetRequired = true;
            }
            
        } else {
            
            // determine if we might be looking at the closeDelimiter
            if( _currentMatchingDelimiterIndex == ([_delimiterData length] - 2 ) ) { // at where the terminating `\r` should be on an standard (non-closing) delimiter
                
                
                if (_currentDelimiterData == _delimiterData ) {
                    
                    if ('-' == buffer[i]) {
                        
                        [self setCurrentDelimiterData:_closeDelimiterData];
                        currentDelimiterBytes = [_currentDelimiterData bytes];
                        
                    }

                }
            }
            if (buffer[i] == currentDelimiterBytes[_currentMatchingDelimiterIndex]) {
                _currentMatchingDelimiterIndex++;
                
                if ([_currentDelimiterData length] == _currentMatchingDelimiterIndex) { // reached the end of the delimiter
                    
                    bool isCloseDelimiter = false;
                    if( _currentDelimiterData == _closeDelimiterData ) {
                        isCloseDelimiter = true;
                    }
                    
                    NSUInteger startOfDelimiter = i - ([_currentDelimiterData length] - 1); // `-1` to given us the index of the first character of the delimiter
                    
                    
                    if (partialDelimiterMatched) {
                        
                        startOfDelimiter = startingOffset;
                    }
                    
                    NSUInteger endOfDelimiter = i + 1; // after the last character of the delimiter
                    
                    { // in C#: creating another answer object outside of the `PartialDelimiterCompleted` above, causes a compiler error
                        
                        HLDelimiterFound* answer = [[HLDelimiterFound alloc] initWithStartOfDelimiter:startOfDelimiter endOfDelimiter:endOfDelimiter isCloseDelimiter:isCloseDelimiter completesPartialMatch:partialDelimiterMatched];
                        return answer;
                        
                        
                    }
                }
            } else { // buffer[i] != buffer[i] == currentDelimiterBytes[_currentMatchingDelimiterIndex] ... reset
                resetRequired = true;
            }
        }
        
        if (resetRequired) {
            
            [self reset];
            
            partialDelimiterMatched = false;
            
            
            // vvv function ?
            
            if( buffer[i] ==  currentDelimiterBytes[_currentMatchingDelimiterIndex] ) {
                _currentMatchingDelimiterIndex = 1;
            }
            // ^^^ function ?
            
        }

    }

    
    // finished with the loop but looks like we might have a partial match
    if (0 != _currentMatchingDelimiterIndex) {
        
        NSData* partialData = [NSData dataWithBytes:currentDelimiterBytes length:_currentMatchingDelimiterIndex];
        
        HLPartialDelimiterMatched* answer = [[HLPartialDelimiterMatched alloc] initWithMatchingData:partialData];
        return answer;
        
        
    }

    
    
    // no `match` partial, or complete
    return nil;

    
    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithBoundary:(NSString*)boundary {
    
    
    HLDelimiterDetector* answer = [super init];
    
    
    if( nil != answer ) {
        
        {
            NSString* delimiterString = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
            NSData* delimiterData = [CAStringHelper toUtf8Data:delimiterString];
            [answer setDelimiterData:delimiterData];
        }
        
        {
            
            NSString* closeDelimiterString = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
            NSData* closeDelimiterData = [CAStringHelper toUtf8Data:closeDelimiterString];
            [answer setCloseDelimiterData:closeDelimiterData];
        }
        
        [answer setCurrentDelimiterData:[answer delimiterData]];
        answer->_currentMatchingDelimiterIndex = 0;
        
    }
    
    return answer;

}

-(void)dealloc {
	
	[self setDelimiterData:nil];
	[self setCloseDelimiterData:nil];
	[self setCurrentDelimiterData:nil];

	
}


#pragma mark -
#pragma mark fields

// delimiterData
//NSData* _delimiterData;
//@property (nonatomic, retain) NSData* delimiterData;
@synthesize delimiterData = _delimiterData;

// closeDelimiterData
//NSData* _closeDelimiterData;
//@property (nonatomic, retain) NSData* closeDelimiterData;
@synthesize closeDelimiterData = _closeDelimiterData;

// currentDelimiterData
//NSData* _currentDelimiterData;
//@property (nonatomic, retain) NSData* currentDelimiterData;
@synthesize currentDelimiterData = _currentDelimiterData;


@end
