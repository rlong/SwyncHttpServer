//
//  AVMediaHandleSet.m
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import "VPMediaHandleSet.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface VPMediaHandleSet ()


// handles
//NSArray* _handles;
@property (nonatomic, retain) NSArray* handles;
//@synthesize handles = _handles;

// currentHandle
//AVMediaHandle* _currentHandle;
@property (nonatomic, retain) id<VPMediaHandle> currentHandle;
//@synthesize currentHandle = _currentHandle;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation VPMediaHandleSet

static VPMediaHandleSet* _EMPTY_MEDIA_HANDLE_SET = nil;

+(void)initialize {
    
    _EMPTY_MEDIA_HANDLE_SET = [[VPMediaHandleSet alloc] init];
	
}

//+(XPMediaHandleSet*)EMPTY_MEDIA_HANDLE_SET {
//    return _EMPTY_MEDIA_HANDLE_SET;
//    
//}


-(NSUInteger)getHandleCount {
    return [_handles count];
}

-(id<VPMediaHandle>)getHandleAtIndex:(NSUInteger)index {
    
    return (id<VPMediaHandle>)[_handles objectAtIndex:index];
    
}


// will return nil, if the suffix is not found
-(id<VPMediaHandle>)getHandleWithUri:(NSString*)uri {
    
    @synchronized(self) {
        
        if( nil != _currentHandle ) {
            NSString* currentUriSuffix = [_currentHandle uriSuffix];
            NSRange range = [uri rangeOfString:currentUriSuffix];
            if( NSNotFound != range.location ) { // cache hit
                return _currentHandle;
            }
            [self setCurrentHandle:nil]; // cache miss
        }
    }
    
    for( NSUInteger i = 0, count = [_handles count]; i < count; i++ ) {
        
        id<VPMediaHandle> candidate = (id<VPMediaHandle>)[_handles objectAtIndex:i];
        
        NSString* candidateUriSuffix = [candidate uriSuffix];
        NSRange range = [uri rangeOfString:candidateUriSuffix];
        if( NSNotFound != range.location ) {
            
            @synchronized(self) {
                [self setCurrentHandle:candidate]; // setup the cache
            }
            
            return candidate;
        }
    }
    
    return nil;
}


#pragma mark -
#pragma mark instance lifecycle


-(id)init {
    
    VPMediaHandleSet* answer = [super init];
    
    
    if( nil != answer ) {
        
        
        [answer setHandles:[NSArray array]];
        
    }
    
    return answer;
    
}



-(id)initWithMediaHandle:(id<VPMediaHandle>)mediaHandle {
    
    VPMediaHandleSet* answer = [super init];
    
    if( nil != answer ) {
        
        NSArray* mediaHandles = [NSArray arrayWithObject:mediaHandle];
        [answer setHandles:mediaHandles];
        
    }
    
    return answer;
    
    
}

-(id)initWithMediaHandles:(NSArray*)mediaHandles {

    VPMediaHandleSet* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setHandles:mediaHandles];
        
    }
    
    return answer;

}

-(void)dealloc {
	
	[self setHandles:nil];
    [self setCurrentHandle:nil];

	[super dealloc];
}



#pragma mark -
#pragma mark fields

// handles
//NSArray* _handles;
//@property (nonatomic, retain) NSArray* handles;
@synthesize handles = _handles;

// currentHandle
//AVMediaHandle* _currentHandle;
//@property (nonatomic, retain) AVMediaHandle* currentHandle;
@synthesize currentHandle = _currentHandle;


@end
