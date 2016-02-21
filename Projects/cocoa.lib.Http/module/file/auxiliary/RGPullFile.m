//
//  PullFile.m
//  remote_gateway
//
//  Created by Richard Long on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBLog.h"
#import "RGPullFile.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface RGPullFile () 

// target
//RGFile* _target;
@property (nonatomic, retain) RGFile* target;
//@synthesize target = _target;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation RGPullFile


-(long long)getFileLength {
    
    return [_target length];
    
}

#pragma mark <FileJobDelegate> implementation 


-(RGFile*)getTarget {
    
    return _target;
    
}

-(void)abort:(RGFileTransaction*)fileJob {
    
    Log_enteredMethod();
    
    
}
-(void)commit:(RGFileTransaction*)fileJob {

    Log_enteredMethod();

}





#pragma mark instance lifecycle

-(id)initWithTarget:(RGFile*)target {
    
    RGPullFile* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setTarget:target];
          
    }
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setTarget:nil];
    
	[super dealloc];
	
}


#pragma mark fields

// target
//RGFile* _target;
//@property (nonatomic, retain) RGFile* target;
@synthesize target = _target;

@end
