//
//  AVGetFileProxy.h
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "JBService.h"


@interface HLGetFileProxy : NSObject {
    
    
    // service
    id<JBService> _service;
	//@property (nonatomic, retain) id<Service> service;
	//@synthesize service = _service;

}

-(NSMutableArray*)getFilesForDownload;


#pragma instance -
#pragma instance lifecycle

-(id)initWithService:(id<JBService>)service;


@end
