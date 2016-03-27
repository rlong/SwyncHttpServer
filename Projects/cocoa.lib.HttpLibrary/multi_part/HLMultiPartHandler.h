// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "CABaseException.h"

#import "HLPartHandler.h"

@protocol HLMultiPartHandler <NSObject>


-(id<HLPartHandler>)foundPartDelimiter;


// gives a warning in "iOS App" validation
-(void)handleExceptionZZZ:(BaseException*)e;

-(void)foundCloseDelimiter;

@end
