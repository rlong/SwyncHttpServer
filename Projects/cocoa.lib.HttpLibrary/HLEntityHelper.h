// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@protocol HLEntity;

@interface HLEntityHelper : NSObject


+(NSData*)toData:(id<HLEntity>)entity;

@end
