// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface HLMediaType : NSObject {
    
    
    // type
    NSString* _type;
    //@property (nonatomic, retain) NSString* type;
    //@synthesize type = _type;

    
    // subtype
    NSString* _subtype;
    //@property (nonatomic, retain) NSString* subtype;
    //@synthesize subtype = _subtype;

    
    // parameters
    NSMutableDictionary* _parameters;
    //@property (nonatomic, retain) NSMutableDictionary* parameters;
    //@synthesize parameters = _parameters;

    
    // toString
    NSString* _toString;
    //@property (nonatomic, retain) NSString* toString;
    //@synthesize toString = _toString;

}


+(HLMediaType*)buildFromString:(NSString*)value;

-(NSString*)getParameterValue:(NSString*)key defaultValue:(NSString*)defaultValue;



#pragma mark -
#pragma mark fields


// type
//NSString* _type;
@property (nonatomic, retain) NSString* type;
//@synthesize type = _type;



// subtype
//NSString* _subtype;
@property (nonatomic, retain) NSString* subtype;
//@synthesize subtype = _subtype;


// toString
//NSString* _toString;
@property (nonatomic, retain) NSString* toString;
//@synthesize toString = _toString;

@end
