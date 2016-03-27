// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLTestMultiPartHandler.h"
#import "HLTestPartHandler.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLTestMultiPartHandler ()



@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLTestMultiPartHandler


-(bool)haveFoundCloseDelimiter {
    return _foundCloseDelimiter;
}

#pragma mark -
#pragma mark <HLMultiPartHandler> implementation

-(id<HLPartHandler>)foundPartDelimiter {
    
    HLTestPartHandler* answer = [[HLTestPartHandler alloc] init];
    {
        [_partHandlers addObject:answer];
    }
    
    return answer;
    
}

-(void)handleExceptionZZZ:(BaseException*)e {
    
    Log_errorException(e);

}

-(void)foundCloseDelimiter {
    
    _foundCloseDelimiter = true;
    
    
}

#pragma mark -
#pragma mark instance lifecycle


-(id)init {
    
    
    HLTestMultiPartHandler* answer = [super init];
    
    if( nil != answer ) {
        
        answer->_partHandlers = [[NSMutableArray alloc] init];
        answer->_foundCloseDelimiter = false;
        
    }
    
    return answer;
    
}

-(void)dealloc {
	
	[self setPartHandlers:nil];
	
	
}

#pragma mark -
#pragma mark fields

// partHandlers
//NSMutableArray* _partHandlers;
//@property (nonatomic, retain) NSMutableArray* partHandlers;
@synthesize partHandlers = _partHandlers;

@end
