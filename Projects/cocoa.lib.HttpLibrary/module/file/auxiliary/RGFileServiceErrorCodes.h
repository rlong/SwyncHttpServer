//
//  FileServiceErrorCodes.h
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RGFileServiceErrorCodes : NSObject


+(int)getFileServiceErrorCode;
+(int)getPushFileJobErrorCode;
+(int)getFileJobManagerErrorCode;

@end
