// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLDelimiterFound.h"

@implementation HLDelimiterFound



-(NSUInteger)startOfDelimiter {
    return _startOfDelimiter;
}

-(NSUInteger)endOfDelimiter {
    return _endOfDelimiter;
}

-(bool)isCloseDelimiter {
    return _isCloseDelimiter;

}

-(bool)completesPartialMatch {
    return _completesPartialMatch;

}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStartOfDelimiter:(NSUInteger)startOfDelimiter endOfDelimiter:(NSUInteger)endOfDelimiter isCloseDelimiter:(bool)isCloseDelimiter completesPartialMatch:(bool)completesPartialMatch {
    
    HLDelimiterFound* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_startOfDelimiter = startOfDelimiter;
        answer->_endOfDelimiter = endOfDelimiter;
        answer->_isCloseDelimiter = isCloseDelimiter;
        answer->_completesPartialMatch = completesPartialMatch;
        
    }
    
    
    return answer;
    
    
}

@end
