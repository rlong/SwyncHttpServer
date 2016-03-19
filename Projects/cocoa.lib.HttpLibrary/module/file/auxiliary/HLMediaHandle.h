//
//  AVMediaHandle.h
//  av_amigo
//
//  Created by rlong on 20/02/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JBEntity.h"

@protocol HLMediaHandle <NSObject>


-(NSString*)getFilename;

-(unsigned long long)getContentLength;

-(id<JBEntity>)toEntity;

-(NSString*)uriSuffix;

-(NSString*)getMimeType;


@end
