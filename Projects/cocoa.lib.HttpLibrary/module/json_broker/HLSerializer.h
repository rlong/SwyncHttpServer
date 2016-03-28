// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLBrokerMessage.h"



@interface HLSerializer : NSObject {

}

+(HLBrokerMessage*)deserialize:(NSData*)data;
	



@end
