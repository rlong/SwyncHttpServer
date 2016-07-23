//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CABaseException.h"
#import "CALog.h"
#import "CAOutputStreamHelper.h"

#import "HLFrame.h"

#define JBFrame_FIN_BIT 0x80
#define JBFrame_MASK_BIT 0x80

#define JBFrame_MASKING_KEY_LENGTH 4

@implementation HLFrame


-(void)applyMask:(NSMutableData*)bytes {
    
    if( nil == _maskingKey ) {
        return;
    }
    
    uint32_t maskIndex = 0;
    
    uint8_t* mutableBytes = [bytes mutableBytes];
    
    for( uint32_t i = 0, count = (uint32_t)[bytes length]; i < count; i++ ) {
        
        mutableBytes[i] ^= _maskingKey[maskIndex];
        
        maskIndex++;
        if( 4 == maskIndex  ) {
            maskIndex = 0;
        }
        
    }
}


-(uint8_t)opCode {
    
    return _opCode;
    
}


-(uint32_t)payloadLength {
    
    return _payloadLength;
    
}


// the next byte of data, or -1 if the end of the stream is reached
// this code is deviates from `[NSInputStream read:maxLength:]` and is modelled after the Java version of `InputStreamHelper.readByte()`
+(int32_t)readByteFromStream:(NSInputStream*)inputStream {
    
    uint8_t answer;
    
    NSInteger bytesRead = [inputStream read:&answer maxLength:1];
    
    
    // method failed
    if( 0 > bytesRead ) {
        
        Log_errorInt( [inputStream streamStatus] );
        Log_errorError( [inputStream streamError] );

        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"0 > bytesRead; bytesRead = %d", bytesRead];
    }
    
    // end of stream
    if( 0 == bytesRead ) {
        return -1;
    }
    
    
    return answer;
    
}

+(HLFrame*)tryReadFrame:(NSInputStream*)inputStream {
    
    uint8_t byte0;
    {
        int32_t byteRead = [self readByteFromStream:inputStream];
        if( -1 == byteRead ) {
            return nil;
        }
        byte0 = byteRead;
    }
    
    uint8_t opCode;
    {
        opCode = 0x7f & byte0; // mask of the 'FIN_BIT'
        
        if( JBFrame_OPCODE_TEXT_FRAME == opCode ) {
            
            // ok
            Log_debug( @"JBFrame_OPCODE_TEXT_FRAME" );
            
        } else if( JBFrame_OPCODE_CONNECTION_CLOSE == opCode ) {
            
            // ok
            Log_debug( @"JBFrame_OPCODE_CONNECTION_CLOSE" );
            
        } else if( JBFrame_OPCODE_PONG == opCode ) {
            
            
            // vvv [RFC 6455 - The WebSocket Protocol](https://tools.ietf.org/html/rfc6455#section-5.5.3)
            
//            A Pong frame MAY be sent unsolicited.  This serves as a
//            unidirectional heartbeat.  A response to an unsolicited Pong frame is
//            not expected.
            
            // ^^^ [RFC 6455 - The WebSocket Protocol](https://tools.ietf.org/html/rfc6455#section-5.5.3)
            
            // ok
            Log_debug( @"JBFrame_OPCODE_PONG" );
            
        } else {
            @throw  [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"unhandled opcode; opCode = %d", opCode];
        }
        
    }
    
    uint8_t byte1 = [self readByteFromStream:inputStream];
    uint32_t length = (0x7F)&byte1; // mask out the mask bit
    
    if( 126 == length ) {
        
        uint8_t extendPayloadLengthMsb = [self readByteFromStream:inputStream];
        uint32_t extendedLength = 0xFF&extendPayloadLengthMsb;
        extendedLength <<= 8;
        
        uint8_t extendPayloadLengthLsb = [self readByteFromStream:inputStream];
        extendedLength |= 0xFF&extendPayloadLengthLsb;
        
        
        length += extendedLength;
        
    } else if( 127 == length ) {
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultString:@"127 == length; unsupported"];
    }
    
    
    HLFrame* answer = [[HLFrame alloc] initWithOpCode:opCode payloadLength:length];
    
    if( JBFrame_MASK_BIT == (byte1&JBFrame_MASK_BIT) ) {
        
        [answer setupMaskingKeyFrom:inputStream];
        
    }
    
    return answer;

}

+(HLFrame*)readFrame:(NSInputStream*)inputStream {
    
    @try {
        HLFrame* answer = nil;
        do {
            answer = [self tryReadFrame:inputStream];
        }
        while( nil != answer && JBFrame_OPCODE_PONG == [answer opCode] ); // we can get unsolicited `pong`s
        return answer;
    }
    @catch (NSException *exception) {
        Log_errorException( exception );
        return nil;
    }
    
}


-(void)setupMaskingKeyFrom:(NSInputStream*)inputStream{
    
    _maskingKey = malloc(JBFrame_MASKING_KEY_LENGTH*(sizeof(uint8_t))); // 4 bytes
    
    NSInteger bytesRead = [inputStream read:_maskingKey maxLength:JBFrame_MASKING_KEY_LENGTH];
    
    // method failed, not enough bytes, or reached end of stream
    if( JBFrame_MASKING_KEY_LENGTH != bytesRead ) {
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"JBFrame_MASKING_KEY_LENGTH != bytesRead; bytesRead = %d", bytesRead];
    }
    
}

-(void)writeTo:(NSOutputStream*)outputStream {
    
    uint8_t byte0 = JBFrame_FIN_BIT|_opCode;
    
    uint8_t byte1;
    bool usingExtendedLength = false;
    uint8_t extendedLength[2];
    
    if( 126 > _payloadLength ) {
        
        byte1 = _payloadLength;
        
    } else if( 126 + 0xFFFF > _payloadLength) { // greater than 125 but less than '126 + 0xFFFF' (65,661)
        
        
        usingExtendedLength = true;
        byte1 = 126;
        
        uint32_t payloadLength = _payloadLength;
        
        // network byte order (big endian) ...
        extendedLength[1] = (uint8_t)(payloadLength&0xFF); // Least Significant Byte
        payloadLength >>= 8;
        extendedLength[0] = (uint8_t)(payloadLength&0xFF); // Most Significant Byte


    } else { // greater than '126 + 0xFFFF' (65,661)
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"unhandled payload length (too large); _payloadLength = %d", _payloadLength];
    }
    
    [CAOutputStreamHelper writeTo:outputStream buffer:&byte0 bufferLength:1];
    
    if( nil != _maskingKey ) {
        byte1 |= JBFrame_MASK_BIT;
    }
    
    [CAOutputStreamHelper writeTo:outputStream buffer:&byte1 bufferLength:1];
    
    if( usingExtendedLength ) {

        [CAOutputStreamHelper writeTo:outputStream buffer:extendedLength bufferLength:2];

    }
    
    if( nil != _maskingKey ) {
        
        [CAOutputStreamHelper writeTo:outputStream buffer:_maskingKey bufferLength:JBFrame_MASKING_KEY_LENGTH];
        
    }

    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithOpCode:(uint8_t)opCode payloadLength:(uint32_t)payloadLength {
    
    HLFrame* answer = [super init];
    
    if( nil != answer ) {
        answer->_maskingKey = nil;
        answer->_opCode = opCode;
        answer->_payloadLength = payloadLength;
    }
    
    return answer;
    
}


-(void)dealloc {
    
    if( nil != _maskingKey ) {
        free( _maskingKey );
        _maskingKey = nil;
    }
    
    
}






@end
