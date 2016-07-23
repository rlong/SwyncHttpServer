//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


/* from http://tools.ietf.org/html/rfc6455#section-5.2 ...
 
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-------+-+-------------+-------------------------------+
 |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
 |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
 |N|V|V|V|       |S|             |   (if payload len==126/127)   |
 | |1|2|3|       |K|             |                               |
 +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
 |     Extended payload length continued, if payload len == 127  |
 + - - - - - - - - - - - - - - - +-------------------------------+
 |                               |Masking-key, if MASK set to 1  |
 +-------------------------------+-------------------------------+
 | Masking-key (continued)       |          Payload Data         |
 +-------------------------------- - - - - - - - - - - - - - - - +
 :                     Payload Data continued ...                :
 + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
 |                     Payload Data continued ...                |
 +---------------------------------------------------------------+
 
 FIN:  1 bit
 
 Indicates that this is the final fragment in a message.  The first
 fragment MAY also be the final fragment.
 
 RSV1, RSV2, RSV3:  1 bit each
 
 MUST be 0 unless an extension is negotiated that defines meanings
 for non-zero values.  If a nonzero value is received and none of
 the negotiated extensions defines the meaning of such a nonzero
 value, the receiving endpoint MUST _Fail the WebSocket
 Connection_.
 
 */


//#define JBFrame_OPCODE_CONTINUATION_FRAME 0x00
#define JBFrame_OPCODE_TEXT_FRAME 0x01
//#define JBFrame_OPCODE_BINARY_FRAME  0x02
//#define JBFrame_OPCODE_BINARY_RESERVED_3 0x03
//#define JBFrame_OPCODE_BINARY_RESERVED_4 0x04
//#define JBFrame_OPCODE_BINARY_RESERVED_5 0x05
//#define JBFrame_OPCODE_BINARY_RESERVED_6 0x06
//#define JBFrame_OPCODE_BINARY_RESERVED_7 0x07
#define JBFrame_OPCODE_CONNECTION_CLOSE 0x08
//#define JBFrame_OPCODE_PING 0x09
#define JBFrame_OPCODE_PONG 0x0a
//#define JBFrame_OPCODE_BINARY_RESERVED_B 0x0b
//#define JBFrame_OPCODE_BINARY_RESERVED_C 0x0c
//#define JBFrame_OPCODE_BINARY_RESERVED_D 0x0d
//#define JBFrame_OPCODE_BINARY_RESERVED_E 0x0e
//#define JBFrame_OPCODE_BINARY_RESERVED_F 0x0f


@interface HLFrame : NSObject {
    
    uint8_t* _maskingKey;

    uint8_t _opCode;
    
    uint32_t _payloadLength;
    

}

-(void)applyMask:(NSMutableData*)bytes;

-(uint8_t)opCode;

-(uint32_t)payloadLength;

+(HLFrame*)readFrame:(NSInputStream*)inputStream;
-(void)writeTo:(NSOutputStream*)outputStream;

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithOpCode:(uint8_t)opCode payloadLength:(uint32_t)payloadLength;

@end
