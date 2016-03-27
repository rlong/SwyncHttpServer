// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLHttpAsyncCall.h"
#import "HLHttpCall.h"
#import "HLHttpRunLoop.h"


#define RUNLOOP_AWAITING_INITIALISATION 100
#define RUNLOOP_INITIALISED 300


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLHttpRunLoop () 


-(void)start;



// runLoop
//NSRunLoop* _runLoop;
@property (nonatomic, retain) NSRunLoop* runLoop;
//@synthesize runLoop = _runLoop;


// runLoopInitialised
//NSConditionLock* _runLoopInitialised;
@property (nonatomic, retain) NSConditionLock* runLoopInitialised;
//@synthesize runLoopInitialised = _runLoopInitialised;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLHttpRunLoop


static HLHttpRunLoop* _instance = nil; 


+(HLHttpRunLoop*)getInstance {

    @synchronized(self) {
        
        if( nil != _instance ) {
            return _instance;
        }
        
        _instance = [[HLHttpRunLoop alloc] init];
        [_instance start];
        
        return _instance;
    }
    
}


- (NSData *)sendSynchronousRequest:(NSURLRequest*)request returningResponse:(NSURLResponse **)urlResponse error:(NSError **)error {
    
    
//    Log_enteredMethod();
    
    if( NO ) { 
        return [NSURLConnection sendSynchronousRequest:request returningResponse:urlResponse error:error];
    }
        
    NSData* answer;
    
    HLHttpCall* call = [[HLHttpCall alloc] initWithRequest:request];
    {
        @synchronized(_runLoop) {
            
            [call start:_runLoop];
        }
        [call waitUntilCompleted];
        
        answer = [call responseData];
        if( nil != answer ) { 
        }
        
        *urlResponse = [call response];
        if( nil != *urlResponse ) { 
        }
        
        if( nil != error ) {
            *error = [call error];
            if( nil != *error ) {
            }
        }
    }
    
    return answer;

}

-(void)startAsynchronousRequest:(HLHttpAsyncCall *)asyncCall {
    
    [asyncCall start:_runLoop];
}


- (void)timerCallback:(NSTimer*)theTimer {
	
	Log_enteredMethod();
	
}


-(void)main:(NSObject*)ignoredObject {
	
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[[NSThread currentThread] setName:@"HLHttpRunLoop"];

    Log_enteredMethod();

	Log_debug( @"Starting ... ");
	
	[NSTimer scheduledTimerWithTimeInterval:(60) target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
	
    [self setRunLoop:[NSRunLoop currentRunLoop]];
    
    [_runLoopInitialised lock];
    [_runLoopInitialised unlockWithCondition:RUNLOOP_INITIALISED];
    
    [_runLoop run];
	
	Log_debug( @"... Finished" );
	
//	[pool release];
	
}


-(void)start {
	
	Log_enteredMethod();
	
	[NSThread detachNewThreadSelector:@selector(main:) toTarget:self withObject:nil];
    
    [_runLoopInitialised lockWhenCondition:RUNLOOP_INITIALISED];
	[_runLoopInitialised unlock];
}


#pragma mark instance lifecycle 


-(id)init { 
    HLHttpRunLoop* answer = [super init];
    
    [answer setRunLoop:nil];
    answer->_runLoopInitialised = [[NSConditionLock alloc] initWithCondition:RUNLOOP_AWAITING_INITIALISATION];
    
    return answer;
}

-(void)dealloc {
	
	[self setRunLoop:nil];
    [self setRunLoopInitialised:nil];
	
	
}


#pragma mark fields

// runLoop
//NSRunLoop* _runLoop;
//@property (nonatomic, retain) NSRunLoop* runLoop;
@synthesize runLoop = _runLoop;


// runLoopInitialised
//NSConditionLock* _runLoopInitialised;
//@property (nonatomic, retain) NSConditionLock* runLoopInitialised;
@synthesize runLoopInitialised = _runLoopInitialised;



@end
