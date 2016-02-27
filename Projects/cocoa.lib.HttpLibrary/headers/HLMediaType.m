// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"
#import "CABaseException.h"

#import "HLMediaType.h"
#import "HLParametersScanner.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLMediaType ()


-(id)initWithStringValue:(NSString*)stringValue;




// parameters
//NSMutableDictionary* _parameters;
@property (nonatomic, retain) NSMutableDictionary* parameters;
//@synthesize parameters = _parameters;




@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLMediaType



+(HLMediaType*)buildFromString:(NSString*)value {
    
    NSRange indexOfSlash = [value rangeOfString:@"/"];
    
    if( NSNotFound == indexOfSlash.location ) {
        @throw [CABaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"NSNotFound == indexOfSlash.location; value = '%@'", value];
    }
    
    HLMediaType* answer = [[HLMediaType alloc] initWithStringValue:value];
    
    NSString* type = [value substringToIndex:indexOfSlash.location];
    Log_debugString( type );
    [answer setType:type];
    
    NSString* remainder = [value substringFromIndex:indexOfSlash.location+1];
    Log_debugString(remainder);
    
    NSString* subtype;
    {
        NSRange indexOfSemiColon = [remainder rangeOfString:@";"];
        if( NSNotFound ==  indexOfSemiColon.location ) {
            subtype = [remainder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else {
            subtype = [remainder substringToIndex:indexOfSemiColon.location];
            HLParametersScanner* scanner = [[HLParametersScanner alloc] initWithValue:remainder offset:indexOfSemiColon.location];
            
            NSString* attribute;
            while( nil != (attribute = [scanner nextAttribute])) {
                Log_debugString(attribute);
                
                NSString* attributeValue = [scanner nextValue];
                Log_debugString(attributeValue);
                
                [answer->_parameters setObject:attributeValue forKey:attribute];
                
            }
        }
    }
    
    Log_debugString(subtype);
    [answer setSubtype:subtype];
    
    return answer;
    
}



-(NSString*)getParameterValue:(NSString*)key defaultValue:(NSString*)defaultValue {
  
    NSString* answer = [_parameters objectForKey:key];
    
    if( nil == answer ) {
        
        return defaultValue;
        
    }
    
    return answer;
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithStringValue:(NSString*)stringValue {
    
    
    HLMediaType* answer = [super init];
    
    if( nil != answer ) {
        
        
        [answer setToString:stringValue];
        answer->_parameters = [[NSMutableDictionary alloc] init];
        
    }
    
    return answer;
}


-(void)dealloc {
	
	[self setType:nil];
    [self setSubtype:nil];
	[self setParameters:nil];
    [self setToString:nil];


	
}


#pragma mark -
#pragma mark fields

// type
//NSString* _type;
//@property (nonatomic, retain) NSString* type;
@synthesize type = _type;


// subtype
//NSString* _subtype;
//@property (nonatomic, retain) NSString* subtype;
@synthesize subtype = _subtype;

// parameters
//NSMutableDictionary* _parameters;
//@property (nonatomic, retain) NSMutableDictionary* parameters;
@synthesize parameters = _parameters;

// toString
//NSString* _toString;
//@property (nonatomic, retain) NSString* toString;
@synthesize toString = _toString;


@end
