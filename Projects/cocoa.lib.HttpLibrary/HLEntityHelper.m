// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CAInputStreamHelper.h"

#import "HLEntity.h"
#import "HLDataEntity.h"
#import "HLEntityHelper.h"

@implementation HLEntityHelper




+(NSData*)toData:(id<HLEntity>)entity {
    
    
    if( [entity isKindOfClass:[HLDataEntity class]] ) {
        
        HLDataEntity* dataEntity = (HLDataEntity*)entity;
        return [dataEntity data];
        
    }
    
    NSUInteger contentLength = (NSUInteger)[entity getContentLength];

    NSMutableData* answer = [[NSMutableData alloc] initWithCapacity:contentLength];
    
    NSInputStream* entityContent = [entity getContent];

    [CAInputStreamHelper write:contentLength inputStream:entityContent outputData:answer];
    
    return answer;
    
}

@end
