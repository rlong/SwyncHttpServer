// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface HLRange : NSObject {
    
    ////////////////////////////////////////////////////////////////////////////
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
    // firstBytePosition
	NSNumber* _firstBytePosition;
	//@property (nonatomic, retain) NSNumber* firstBytePosition;
	//@synthesize firstBytePosition = _firstBytePosition;

    ////////////////////////////////////////////////////////////////////////////
	// http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
    // lastBytePosition
	NSNumber* _lastBytePosition;
	//@property (nonatomic, retain) NSNumber* lastBytePosition;
	//@synthesize lastBytePosition = _lastBytePosition;
    
    // toString
	NSString* _toString;
	//@property (nonatomic, readonly) NSString* toString;
	//@synthesize toString = _toString;


}


+(HLRange*)buildFromString:(NSString*)value;


-(NSString*)toContentRange:(unsigned long long)entityContentLength;
-(unsigned long long)getSeekPosition:(unsigned long long)entityContentLength;
-(unsigned long long)getContentLength:(unsigned long long)entityContentLength;



#pragma mark fields


////////////////////////////////////////////////////////////////////////////
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
// firstBytePosition
//NSNumber* _firstBytePosition;
@property (nonatomic, retain) NSNumber* firstBytePosition;
//@synthesize firstBytePosition = _firstBytePosition;

////////////////////////////////////////////////////////////////////////////
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35
// lastBytePosition
//NSNumber* _lastBytePosition;
@property (nonatomic, retain) NSNumber* lastBytePosition;
//@synthesize lastBytePosition = _lastBytePosition;

// toString
//NSString* _toString;
@property (nonatomic, readonly) NSString* toString;
//@synthesize toString = _toString;

@end
