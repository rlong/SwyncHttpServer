//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <CommonCrypto/CommonDigest.h>

#import "HLWebSocketUtilities.h"

@implementation HLWebSocketUtilities

+(NSString*)buildSecWebSocketAccept:(NSString*)secWebSocketKey {

    
    NSString* magic= @"258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
    NSString* sha1Input = [secWebSocketKey stringByAppendingString:magic];

    int inputLength = (int)[sha1Input lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    CC_SHA1_CTX sha1Context;
    CC_SHA1_Init( &sha1Context);
    
    CC_SHA1_Update(&sha1Context, (void *)[sha1Input UTF8String], inputLength);
    
    UInt8 hashBytes[20];
    memset(hashBytes, 0x0, 20);
    CC_SHA1_Final( hashBytes, &sha1Context);
    
    NSData* hashData = [NSData dataWithBytes:hashBytes length:20];
    
    NSDataBase64EncodingOptions options = 0;
    NSString* answer = [hashData base64EncodedStringWithOptions:options];
    return answer;
    
}

@end
