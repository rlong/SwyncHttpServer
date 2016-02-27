// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "HLEntity.h"


@interface HLStreamEntity : NSObject<HLEntity> {

    

	// content
	NSInputStream* _content;
	//@property (nonatomic, retain) NSInputStream* content;
	//@synthesize content = _content;
    
    // contentSource
    NSURL* _contentSource;
    //@property (nonatomic, retain) NSURL* contentSource;
    //@synthesize contentSource = _contentSource;

    // contentLength
	unsigned long long _contentLength;
	//@property (nonatomic) unsigned long long contentLength;
	//@synthesize contentLength = _contentLength;

    bool _didOpen;

    // mimeType
    NSString* _mimeType;
    //@property (nonatomic, retain) NSString* mimeType;
    //@synthesize mimeType = _mimeType;

    
    
}


#pragma mark instance lifecycle

-(id)initWithContent:(NSInputStream*)content contentLength:(unsigned long long)contentLength;
-(id)initWithContentSource:(NSURL*)contentSource contentLength:(unsigned long long)contentLength mimeType:(NSString*)mimeType;


@end
