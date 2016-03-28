//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLBrokerMessage.h"

@protocol HLService <NSObject>


-(HLBrokerMessage*)process:(HLBrokerMessage*)request;


@end
