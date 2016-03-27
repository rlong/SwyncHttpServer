// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLPartHandler.h"

@interface HLTestPartHandler : NSObject <HLPartHandler> {
    
    // data
    NSMutableData* _data;
    //@property (nonatomic, retain) NSMutableData* data;
    //@synthesize data = _data;

    
}


#pragma mark -
#pragma mark fields


// data
//NSMutableData* _data;
@property (nonatomic, retain) NSMutableData* data;
//@synthesize data = _data;

@end
