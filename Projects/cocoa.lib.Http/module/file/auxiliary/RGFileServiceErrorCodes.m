//
//  FileServiceErrorCodes.m
//  remote_gateway
//
//  Created by Richard Long on 06/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JBErrorCodeUtilities.h"
#import "RGFileServiceErrorCodes.h"
#import "RGFileService.h"

#import "RGFileServiceConstants.h"


@implementation RGFileServiceErrorCodes


static int _BASE_ERROR_CODE; 

static int _FILE_SERVICE_ERROR_CODE;
static int _PUSH_FILE_JOB_ERROR_CODE;
static int _FILE_JOB_MANAGER_ERROR_CODE;


+(void)initialize {
	
    _BASE_ERROR_CODE = [JBErrorCodeUtilities getBaseErrorCode:[RGFileServiceConstants SERVICE_NAME]];
    
    _FILE_SERVICE_ERROR_CODE = _BASE_ERROR_CODE;
    _PUSH_FILE_JOB_ERROR_CODE = _BASE_ERROR_CODE | 0x10;
    _FILE_JOB_MANAGER_ERROR_CODE = _BASE_ERROR_CODE | 0x20;
    
	
}


+(int)getFileServiceErrorCode {
    return _FILE_SERVICE_ERROR_CODE;
}

+(int)getPushFileJobErrorCode {
    return _PUSH_FILE_JOB_ERROR_CODE;
}


+(int)getFileJobManagerErrorCode {
    return _FILE_JOB_MANAGER_ERROR_CODE;
}


@end
