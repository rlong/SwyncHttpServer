// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "HLEntity.h"


@protocol HLHttpResponseHandler <NSObject>

-(void)handleResponseHeaders:(NSDictionary*)headers responseEntity:(id<HLEntity>)responseEntity;

@end
