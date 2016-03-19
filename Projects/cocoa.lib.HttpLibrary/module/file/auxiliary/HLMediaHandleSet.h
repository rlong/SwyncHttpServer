//
//  AVMediaHandleSet.h
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "HLMediaHandle.h"

@interface HLMediaHandleSet : NSObject {
    
    // handles
    NSArray* _handles;
    //@property (nonatomic, retain) NSArray* handles;
    //@synthesize handles = _handles;

    // currentHandle
    id<HLMediaHandle> _currentHandle;
    //@property (nonatomic, retain) AVMediaHandle* currentHandle;
    //@synthesize currentHandle = _currentHandle;

}

//+(XPMediaHandleSet*)EMPTY_MEDIA_HANDLE_SET;

-(NSUInteger)getHandleCount;
-(id<HLMediaHandle>)getHandleAtIndex:(NSUInteger)index;

// will return nil, if the suffix is not found
-(id<HLMediaHandle>)getHandleWithUri:(NSString*)uri;


#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithMediaHandle:(id<HLMediaHandle>)mediaHandle;
-(id)initWithMediaHandles:(NSArray*)mediaHandles;

#pragma mark -
#pragma mark fields



@end
