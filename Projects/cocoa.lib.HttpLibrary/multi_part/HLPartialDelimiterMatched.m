// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLPartialDelimiterMatched.h"




@implementation HLPartialDelimiterMatched





#pragma mark -
#pragma mark instance lifecycle


-(id)initWithMatchingData:(NSData*)matchingData {

    
    HLPartialDelimiterMatched* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setMatchingData:matchingData];
        
    }
    
    
    return answer;

}





-(void)dealloc {
	
	[self setMatchingData:nil];
	
	
}



#pragma mark -
#pragma mark fields

// matchingData
//NSData* _matchingData;
//@property (nonatomic, retain) NSData* matchingData;
@synthesize matchingData = _matchingData;


@end
