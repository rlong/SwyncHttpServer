//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "CABaseException.h"

#import "HLBrokerMessage.h"

@interface HLServiceHelper : NSObject

+(BaseException*)methodNotFound:(id)originator request:(HLBrokerMessage*)request;

@end
