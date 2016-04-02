//
//  AVMediaHandle.h
//  av_amigo
//
//  Created by rlong on 20/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLEntity.h"

@protocol HLMediaHandle <NSObject>


-(NSString*)getFilename;

-(unsigned long long)getContentLength;

-(id<HLEntity>)toEntity;

-(NSString*)uriSuffix;

-(NSString*)getMimeType;


@end
