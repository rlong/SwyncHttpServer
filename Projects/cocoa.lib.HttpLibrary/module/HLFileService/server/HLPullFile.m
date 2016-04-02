//
//  PullFile.m
//  remote_gateway
//
//  Created by Richard Long on 08/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CALog.h"

#import "HLPullFile.h"
#import "HLFileTransaction.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLPullFile () 

// target
//RGFile* _target;
@property (nonatomic, retain) CAFile* target;
//@synthesize target = _target;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation HLPullFile


-(long long)getFileLength {
    
    return [_target length];
    
}

#pragma mark <FileJobDelegate> implementation 


-(CAFile*)getTarget {
    
    return _target;
    
}

-(void)abort:(HLFileTransaction*)fileJob {
    
    Log_enteredMethod();
    
    
}
-(void)commit:(HLFileTransaction*)fileJob {

    Log_enteredMethod();

}





#pragma mark instance lifecycle

-(id)initWithTarget:(CAFile*)target {
    
    HLPullFile* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setTarget:target];
          
    }
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setTarget:nil];
    
	
}


#pragma mark fields

// target
//RGFile* _target;
//@property (nonatomic, retain) RGFile* target;
@synthesize target = _target;

@end
