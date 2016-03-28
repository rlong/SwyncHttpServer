// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CAJsonObject.h"

@interface HLFaultSerializer : NSObject


+(CAJsonObject*)toJSONObject:(NSException*)exception;

+(CABaseException*)toBaseException:(CAJsonObject*)jsonObject;

@end
