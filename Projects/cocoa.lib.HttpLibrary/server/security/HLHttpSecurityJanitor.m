//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "CALog.h"

#import "HLHttpSecurityJanitor.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpSecurityJanitor () 


// httpSecurityManager
//HttpSecurityManager* _httpSecurityManager;
@property (nonatomic, retain) HLHttpSecurityManager* httpSecurityManager;
//@synthesize httpSecurityManager = _httpSecurityManager;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLHttpSecurityJanitor



- (void)runCleanup:(NSTimer*)theTimer {
    
    Log_enteredMethod();
    
    [_httpSecurityManager runCleanup];
    
}


-(void)run:(NSObject*)ignoredObject {
	
	[[NSThread currentThread] setName:@"HLHttpSecurityJanitor"];
	
    Log_enteredMethod();
    
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    {
        
        Log_debug( @"Starting ... " );
        
        [NSTimer scheduledTimerWithTimeInterval:(2.0 * 60.0) target:self selector:@selector(runCleanup:) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] run];
        
        Log_debug( @"... Finished" );
        
    }
//	[pool release];
    
}



-(void)start {
	
    Log_enteredMethod();
	
	[NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:nil];	
    
}


#pragma mark instance lifecycle 

-(id)initWithHttpSecurityManager:(HLHttpSecurityManager*) httpSecurityManager {
    
    HLHttpSecurityJanitor* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setHttpSecurityManager:httpSecurityManager];
    }
    
    return answer;
}

-(void)dealloc {
	
	[self setHttpSecurityManager:nil];
	
	
}

#pragma mark fields


// httpSecurityManager
//HttpSecurityManager* _httpSecurityManager;
//@property (nonatomic, retain) HttpSecurityManager* httpSecurityManager;
@synthesize httpSecurityManager = _httpSecurityManager;

@end
