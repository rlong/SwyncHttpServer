// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CABaseException.h"

#import "HLParametersScanner.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLParametersScanner ()

// value
//NSString* _value;
@property (nonatomic, retain) NSString* value;
//@synthesize value = _value;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation HLParametersScanner


static bool tokenChars[128];



+(void)initialize {
	
    for (int i = 0; i < 128; i++)
    {
        tokenChars[i] = true;
    }
    
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2
    // CTL chars ...
    {
        for (int i = 0; i < 32; i++)
        {
            tokenChars[i] = false;
        }
        
        tokenChars[127] = false; // 'DEL'

    }

	
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2
    // separators ...
    {
        tokenChars['('] = false;
        tokenChars[')'] = false;
        tokenChars['<'] = false;
        tokenChars['>'] = false;
        tokenChars['@'] = false;
        
        tokenChars[','] = false;
        tokenChars[';'] = false;
        tokenChars[':'] = false;
        tokenChars['\\'] = false;
        tokenChars['"'] = false;
        
        tokenChars['/'] = false;
        tokenChars['['] = false;
        tokenChars[']'] = false;
        tokenChars['?'] = false;
        tokenChars['='] = false;
        
        tokenChars['{'] = false;
        tokenChars['}'] = false;
        tokenChars[' '] = false;
        tokenChars[9] = false;  // HT
    }

}



// http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2
// only covers the octets 0-31 and 127 ... does not include ' ' (space)
+(bool)isTokenCharacter:(UInt8)c {
    
    if (c > 128)
    {
        return false;
    }
    return tokenChars[c];
    
}



/// returns true if another token was found
-(bool)moveToStartOfNextToken:(bool)quotesIsTokenCharacter {
    
    while ( _offset < _utf8ValueLength && ![HLParametersScanner isTokenCharacter:_utf8Value[_offset]] ) {
        
        if( quotesIsTokenCharacter && '"' == _utf8Value[_offset] ) {
            return true;
        }
        
        _offset++;
        
    }
    
    // run out of string ?
    if (_offset == _utf8ValueLength)
    {
        return false;
    }
    
    return true;

    
}


-(void)moveToEndOfToken {
    
    while ( _offset < _utf8ValueLength && [HLParametersScanner isTokenCharacter:_utf8Value[_offset]] ) {
        
        _offset++;
        
    }

    
    
}


// http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2
-(NSString*)nextToken:(bool)quotesIsTokenCharacter {
    
    
    if( ![self moveToStartOfNextToken:quotesIsTokenCharacter]) {
        return nil;
    }
    
    NSUInteger startOfToken = _offset;
    Log_debugInt( startOfToken );
    
    [self moveToEndOfToken];
    
    
    NSUInteger length = _offset - startOfToken;
    
    const char* start = _utf8Value + (sizeof(char)*startOfToken);
    NSString* answer = [[NSString alloc] initWithBytes:start length:length encoding:NSUTF8StringEncoding];
    
    return answer;
    
    
}


// returns nil when there are no more keys
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6
-(NSString*)nextAttribute {
    
    if (_offset >= _utf8ValueLength) {
        return nil;
    }
    
    
    NSString* answer = [self nextToken:false];
    return answer;
    
}

-(void)moveToEndOfQuotedString {
    
    bool lastCharWasAnEscape = false;
    
    while ( _offset < _utf8ValueLength && (lastCharWasAnEscape || '"' != _utf8Value[_offset] ) ) {
        
        UInt8 lastChar = _utf8Value[_offset];
        _offset++;
        
        if (lastCharWasAnEscape) {
            lastCharWasAnEscape = false;
            continue;
        }
        
        if ('\\' == lastChar)
        {
            lastCharWasAnEscape = true;
            continue;
        }
        
    }
    
}

-(NSString*)nextValue {
    
    if( ![self moveToStartOfNextToken:true] ){
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"![self moveToStartOfNextToken:true]; _value = '%@'", _value];

    }
    
    bool isQuotedString = false;
    NSUInteger startOfToken = _offset;
    
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6
    if ('"' == _utf8Value[_offset]) {
        
        isQuotedString = true;
        _offset++; // move past the quotes
        
        startOfToken = _offset;

        if (_offset >= _utf8ValueLength) {
            @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"_offset >= _utf8ValueLength; _offset = %d; _utf8ValueLength = %d; _value = '%@'", _offset, _utf8ValueLength, _value];
        }
        
        [self moveToEndOfQuotedString];

    } else {
        [self moveToEndOfToken];
    }
    
    NSUInteger length = _offset - startOfToken;
    const char* start = _utf8Value + (sizeof(char)*startOfToken);
    NSString* answer = [[NSString alloc] initWithBytes:start length:length encoding:NSUTF8StringEncoding];
    
    
    if (isQuotedString) // move past the closing quotes
    {
        _offset++;
    }
    
    return answer;

}




#pragma mark -
#pragma mark instance lifecycle



-(id)initWithValue:(NSString*)value offset:(NSUInteger)offset {
    
    HLParametersScanner* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setValue:value];
        answer->_offset = offset;
        answer->_utf8Value = [value UTF8String];
        answer->_utf8ValueLength = strlen( answer->_utf8Value );
    }
    
    return answer;
    
}



-(void)dealloc {
	
	[self setValue:nil];
    _utf8Value = nil; // _utf8Value is owned by `value`
	
	
}

#pragma mark -
#pragma mark fields

// value
//NSString* _value;
//@property (nonatomic, retain) NSString* value;
@synthesize value = _value;


@end
