// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@protocol HLEntity <NSObject>

-(NSInputStream*)getContent;
-(unsigned long long)getContentLength;
-(NSString*)md5;

// can return nil
-(NSString*)mimeType;


-(void)teardownForCaller:(id)caller swallowErrors:(BOOL)swallowErrors;

-(void)writeTo:(NSOutputStream*)destination offset:(unsigned long long)offset length:(unsigned long long)length;

@optional


@end

