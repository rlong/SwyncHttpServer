//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "CALog.h"

#import "HLHttpErrorHelper.h"
#import "HLSubjectGroup.h"



@interface HLSubjectGroup () 

#pragma mark private fields 


//NSMutableDictionary* _subjectDictionary;
@property (nonatomic, retain) NSMutableDictionary* subjectDictionary;
//@synthesize subjectDictionary = _subjectDictionary;



@end



@implementation HLSubjectGroup


-(NSEnumerator*)subjectEnumerator {
	return [_subjectDictionary objectEnumerator];
}



-(int)count {
	return (int)[_subjectDictionary count];
}


-(bool)containsUsername:(NSString*)username {

    HLSubject* subject = [_subjectDictionary objectForKey:username];
    
    if( nil != subject ) {
        return true;
    }
    
    return false;
}



-(HLSubject*)subjectForUsername:(NSString*)username {
	
	
	HLSubject* answer = [_subjectDictionary objectForKey:username];
	
	if( nil == answer ) {
        
        Log_errorFormat( @"nil == answer; username = '%@'", username);
        @throw [HLHttpErrorHelper unauthorized401FromOriginator:self line:__LINE__];
	}
	
	return answer;
	
}


-(void)addSubject:(HLSubject*)subject {

    Log_enteredMethod();

	NSString* username = [subject username];
	
	[_subjectDictionary setObject:subject forKey:username];
	
}

-(void)removeSubjectWithUsername:(NSString*)username {

    Log_enteredMethod();

	[_subjectDictionary removeObjectForKey:username];
	
		
}

-(void)removeSubject:(HLSubject*)subject {
    
    Log_enteredMethod();
    NSString* username = [subject username];
	[_subjectDictionary removeObjectForKey:username];
}



#pragma mark instance setup/teardown

-(id)init {
	
	HLSubjectGroup* answer = [super init];
    
    if( nil != answer ) { 
        
        
        answer->_subjectDictionary = [[NSMutableDictionary alloc] init];

    }
	
	return answer;
	
}

-(void)dealloc {

	
	[self setSubjectDictionary:nil];
	
}


#pragma mark fields


//NSMutableDictionary* _subjectDictionary;
//@property (nonatomic, retain) NSMutableDictionary* subjectDictionary;
@synthesize subjectDictionary = _subjectDictionary;



@end
