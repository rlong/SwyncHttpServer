// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "HLDelimiterIndicator.h"


@interface HLDelimiterDetector : NSObject {
    
    
    // delimiterData
    NSData* _delimiterData;
    //@property (nonatomic, retain) NSData* delimiterData;
    //@synthesize delimiterData = _delimiterData;


    // closeDelimiterData
    NSData* _closeDelimiterData;
    //@property (nonatomic, retain) NSData* closeDelimiterData;
    //@synthesize closeDelimiterData = _closeDelimiterData;


    // currentDelimiterData
    NSData* _currentDelimiterData;
    //@property (nonatomic, retain) NSData* currentDelimiterData;
    //@synthesize currentDelimiterData = _currentDelimiterData;
    
    
    NSUInteger _currentMatchingDelimiterIndex;

}


-(id<HLDelimiterIndicator>)update:(const UInt8*)buffer startingOffset:(NSUInteger)startingOffset endingOffset:(NSUInteger)endingOffset;


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithBoundary:(NSString*)boundary;


@end
