//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "CALog.h"

#import "HLMainThreadServiceDelegator.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLMainThreadServiceDelegator () 



//NSException* _exception;
@property (nonatomic, retain) NSException* exception;
//@synthesize exception = _exception;

//BrokerMessage* _response;
@property (nonatomic, retain) HLBrokerMessage* response;
//@synthesize response = _response;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLMainThreadServiceDelegator


-(void)processInMainThread:(HLBrokerMessage*)request {
	
	
	@try {
		HLBrokerMessage* response = [_delegate process:request];
		[self setResponse:response];
	}
	@catch (NSException * e) {
		[self setException:e];
	}
}


#pragma mark <NamedService> implementation 

-(NSString*)serviceName {
    
    NSString* answer = [[_delegate serviceDescription] serviceName];

    return answer;
}

-(HLBrokerMessage*)process:(HLBrokerMessage*)request {
	
//	Log_enteredMethod();
	
	[self setException:nil];
	[self setResponse:nil];
	
	[self performSelectorOnMainThread:@selector(processInMainThread:) withObject:request waitUntilDone:YES];
	
	if( nil != _exception ) {
		@throw _exception;
	}
	
	return _response;
	
}

#pragma mark instance lifecycle 

-(id)initWithDelegate:(id<HLMainThreadService>)delegate { 
	
	HLMainThreadServiceDelegator* answer = [super init];
	
	
	[answer setDelegate:delegate];
	
	return answer;
	
	
}

-(void)dealloc { 
	
	
	[self setDelegate:nil];
	[self setException:nil];
	[self setResponse:nil];
	
	
}
#pragma mark fields



//id<UserInterfaceService> _delegate;
//@property (nonatomic, retain) id<UserInterfaceService> delegate;
@synthesize delegate = _delegate;

//NSException* _exception;
//@property (nonatomic, retain) NSException* exception;
@synthesize exception = _exception;

//BrokerMessage* _response;
//@property (nonatomic, retain) BrokerMessage* response;
@synthesize response = _response;


@end
