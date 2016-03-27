// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "HLDelimiterIndicator.h"


@interface HLPartialDelimiterMatched : NSObject <HLDelimiterIndicator> {
    
    // matchingData
    NSData* _matchingData;
    //@property (nonatomic, retain) NSData* matchingData;
    //@synthesize matchingData = _matchingData;
    

}



#pragma mark -
#pragma mark instance lifecycle


-(id)initWithMatchingData:(NSData*)matchingData;

#pragma mark -
#pragma mark fields



// matchingData
//NSData* _matchingData;
@property (nonatomic, retain) NSData* matchingData;
//@synthesize matchingData = _matchingData;

@end
