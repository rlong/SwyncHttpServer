//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "HLHttpMethod.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpMethod ()

-(id)initWithName:(NSString*)name;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation HLHttpMethod


static HLHttpMethod* _GET = nil;
static HLHttpMethod* _OPTIONS = nil;
static HLHttpMethod* _POST = nil;

+(void)initialize {
	
    _GET = [[HLHttpMethod alloc] initWithName:@"GET"];
    _OPTIONS = [[HLHttpMethod alloc] initWithName:@"OPTIONS"];
    _POST = [[HLHttpMethod alloc] initWithName:@"POST"];
	
}


+(HLHttpMethod*)GET {

    return _GET;

}

+(HLHttpMethod*)OPTIONS {

    return _OPTIONS;
    
}

+(HLHttpMethod*)POST {

    return _POST;
    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)initWithName:(NSString*)name {
    
    HLHttpMethod* answer = [super init];
    
    if( nil != answer ) {
        answer->_name = name;
        
    }
    
    return answer;
}

-(void)dealloc {
	
	
}

#pragma mark -
#pragma mark fields

// name
//NSString* _name;
//@property (nonatomic, retain) NSString* name;
@synthesize name = _name;

@end
