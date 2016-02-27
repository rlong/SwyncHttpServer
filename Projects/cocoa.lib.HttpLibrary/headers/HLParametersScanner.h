// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface HLParametersScanner : NSObject {
    
    
    NSUInteger _offset;
    
    // value
    NSString* _value;
    //@property (nonatomic, retain) NSString* value;
    //@synthesize value = _value;
    

    const char* _utf8Value;
    
    size_t _utf8ValueLength;
}


// returns nil when there are no more keys
// http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6
-(NSString*)nextAttribute;


-(NSString*)nextValue;

#pragma mark -
#pragma mark instance lifecycle



-(id)initWithValue:(NSString*)value offset:(NSUInteger)offset;

@end
