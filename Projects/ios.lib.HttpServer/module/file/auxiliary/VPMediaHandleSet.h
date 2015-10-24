//
//  AVMediaHandleSet.h
//  av_amigo
//
//  Created by rlong on 18/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "VPMediaHandle.h"

@interface VPMediaHandleSet : NSObject {
    
    // handles
    NSArray* _handles;
    //@property (nonatomic, retain) NSArray* handles;
    //@synthesize handles = _handles;

    // currentHandle
    id<VPMediaHandle> _currentHandle;
    //@property (nonatomic, retain) AVMediaHandle* currentHandle;
    //@synthesize currentHandle = _currentHandle;

}

//+(XPMediaHandleSet*)EMPTY_MEDIA_HANDLE_SET;

-(NSUInteger)getHandleCount;
-(id<VPMediaHandle>)getHandleAtIndex:(NSUInteger)index;

// will return nil, if the suffix is not found
-(id<VPMediaHandle>)getHandleWithUri:(NSString*)uri;


#pragma mark -
#pragma mark instance lifecycle

-(id)init;
-(id)initWithMediaHandle:(id<VPMediaHandle>)mediaHandle;
-(id)initWithMediaHandles:(NSArray*)mediaHandles;

#pragma mark -
#pragma mark fields



@end
