//
//  FileJobDelegate.h
//  remote_gateway
//
//  Created by Richard Long on 04/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RGFile.h"

@class RGFileTransaction;

@protocol FileTransactionDelegate <NSObject>


-(RGFile*)getTarget;

-(void)abort:(RGFileTransaction*)fileJob;
-(void)commit:(RGFileTransaction*)fileJob;


@end
