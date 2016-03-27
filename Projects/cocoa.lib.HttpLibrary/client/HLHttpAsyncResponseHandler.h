// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@protocol HLHttpAsyncResponseHandler <NSObject>


-(void)onResponseHeaderWithName:(NSString*)name value:(NSString*)value;

-(void)onResponseEntityStarted;
-(void)onResponseBytes:(const UInt8*)bytes length:(NSUInteger)length;
-(void)onResponseEntityCompleted;

-(void)onResponseCancelled;
-(void)onResponseError:(NSError*)e;


@end
