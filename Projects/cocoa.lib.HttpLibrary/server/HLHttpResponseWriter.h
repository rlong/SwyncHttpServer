//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLHttpResponse.h"

#import "HLFileHandle.h"

@interface HLHttpResponseWriter : NSObject {

}



+(void)writeResponse:(HLHttpResponse*)response outputStream:(NSOutputStream*)outputStream;

@end
