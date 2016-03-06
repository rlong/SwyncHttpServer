//
//  FileJobDelegate.h
//  remote_gateway
//
//  Created by Richard Long on 04/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLFile.h"

@class HLFileTransaction;

@protocol FileTransactionDelegate <NSObject>


-(HLFile*)getTarget;

-(void)abort:(HLFileTransaction*)fileJob;
-(void)commit:(HLFileTransaction*)fileJob;


@end
