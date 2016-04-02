//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "HLSubject.h"

@interface HLSubjectGroup : NSObject {


	NSMutableDictionary* _subjectDictionary;
	//@property (nonatomic, retain) NSMutableDictionary* subjectDictionary;
	//@synthesize subjectDictionary = _subjectDictionary;
	
}


-(NSEnumerator*)subjectEnumerator;

-(int)count;

-(bool)containsUsername:(NSString*)username;
-(HLSubject*)subjectForUsername:(NSString*)username;

-(void)addSubject:(HLSubject*)subject;

-(void)removeSubjectWithUsername:(NSString*)username;
-(void)removeSubject:(HLSubject*)subject;



@end
