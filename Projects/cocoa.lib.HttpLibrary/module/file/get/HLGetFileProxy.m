//
//  AVGetFileProxy.m
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//


#import "CAJsonArray.h"
#import "CAJsonObject.h"
#import "CALog.h"

#import "HLGetFileProxy.h"
#import "HLGetFileService.h"
#import "HLRemoteFileReference.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLGetFileProxy ()


// service
//id<Service> _service;
@property (nonatomic, retain) id<HLService> service;
//@synthesize service = _service;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLGetFileProxy




-(NSMutableArray*)getFilesForDownload {
    
    NSMutableArray* answer = [[NSMutableArray alloc] init];
    
    HLBrokerMessage* request = [HLBrokerMessage buildRequestWithServiceName:[HLGetFileService SERVICE_NAME] methodName:@"getFilesForDownload"];
    
    HLBrokerMessage* response = [_service process:request];
    CAJsonObject* ap = [response associativeParamaters];
    CAJsonArray* files = [ap jsonArrayForKey:@"files"];
    for( int i = 0, count = [files count]; i < count; i++ ) {
        
        CAJsonObject* file = [files objectAtIndex:i];
        NSString* filename = [file stringForKey:@"filename"];
        Log_debugString( filename );
        long long filesize = [file longLongForKey:@"filesize"];
        NSString* uri = [file stringForKey:@"uri"];
        
        HLRemoteFileReference* fileReference = [[HLRemoteFileReference alloc] initWithFilename:filename filesize:filesize uri:uri];
        {
            [answer addObject:fileReference];
        }
        
    }
    
    return answer;
    
}



#pragma instance -
#pragma instance lifecycle

-(id)initWithService:(id<HLService>)service {
    
    
    HLGetFileProxy* answer = [super init];
    
    
    if( nil != answer ) {
        
        [answer setService:service];
    }
    
    
    
    return answer;
}

-(void)dealloc {
    
	[self setService:nil];
		
}

#pragma instance -
#pragma mark fields


// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;

@end
