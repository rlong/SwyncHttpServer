//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@class HLFileHandle;

@protocol HLConnectionDelegate <NSObject>


// can return a `nil` which indicates processing on the socket should stop
-(id<HLConnectionDelegate>)processRequestOnSocket:(HLFileHandle*)socket inputStream:(NSInputStream*)inputStream  outputStream:(NSOutputStream*)outputStream;


@end