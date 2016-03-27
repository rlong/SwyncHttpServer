// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLDelimiterIndicator.h"

@interface HLDelimiterFound : NSObject <HLDelimiterIndicator> {
    
    
    NSUInteger _startOfDelimiter;
    NSUInteger _endOfDelimiter;
    bool _isCloseDelimiter;
    bool _completesPartialMatch;
    
}


-(NSUInteger)startOfDelimiter;
-(NSUInteger)endOfDelimiter;
-(bool)isCloseDelimiter;
-(bool)completesPartialMatch;

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithStartOfDelimiter:(NSUInteger)startOfDelimiter endOfDelimiter:(NSUInteger)endOfDelimiter isCloseDelimiter:(bool)isCloseDelimiter completesPartialMatch:(bool)completesPartialMatch;


@end
