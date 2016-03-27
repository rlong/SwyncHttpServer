// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "CABaseException.h"

@protocol HLPartHandler <NSObject>

-(void)handleHeaderWithName:(NSString*)name value:(NSString*)value;
-(void)handleBytes:(const UInt8*)bytes offset:(NSUInteger)offset length:(NSUInteger)length;

-(void)handleFailure:(BaseException*)e;

-(void)partCompleted;

@end
