//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@interface HLFileHandle : NSObject {
    
	// fileDescriptor
	int _fileDescriptor;
	//@property (nonatomic) int fileDescriptor;
	//@synthesize fileDescriptor = _fileDescriptor;
    
    bool _open;

}


-(void)close;

#pragma mark instance lifecycle

-(id)initWithFileDescriptor:(int)fileDescriptor;

#pragma mark fields


// fileDescriptor
//int _fileDescriptor;
@property (nonatomic) int fileDescriptor;
//@synthesize fileDescriptor = _fileDescriptor;

@end
