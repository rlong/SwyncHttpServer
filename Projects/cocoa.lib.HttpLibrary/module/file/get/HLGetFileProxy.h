//
//  AVGetFileProxy.h
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "HLService.h"


@interface HLGetFileProxy : NSObject {
    
    
    // service
    id<HLService> _service;
	//@property (nonatomic, retain) id<Service> service;
	//@synthesize service = _service;

}

-(NSMutableArray*)getFilesForDownload;


#pragma instance -
#pragma instance lifecycle

-(id)initWithService:(id<HLService>)service;


@end
