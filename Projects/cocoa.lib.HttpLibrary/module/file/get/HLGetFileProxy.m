//
//  AVGetFileProxy.m
//  av_amigo
//
//  Created by rlong on 25/03/13.
//  Copyright (c) 2013 HexBeerium. All rights reserved.
//


#import "JBJsonArray.h"
#import "JBJsonObject.h"
#import "JBLog.h"

#import "HLGetFileProxy.h"
#import "HLGetFileService.h"
#import "HLRemoteFileReference.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLGetFileProxy ()


// service
//id<Service> _service;
@property (nonatomic, retain) id<JBService> service;
//@synthesize service = _service;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation HLGetFileProxy




-(NSMutableArray*)getFilesForDownload {
    
    NSMutableArray* answer = [[NSMutableArray alloc] init];
    
    JBBrokerMessage* request = [JBBrokerMessage buildRequestWithServiceName:[HLGetFileService SERVICE_NAME] methodName:@"getFilesForDownload"];
    
    JBBrokerMessage* response = [_service process:request];
    JBJsonObject* ap = [response associativeParamaters];
    JBJsonArray* files = [ap jsonArrayForKey:@"files"];
    for( int i = 0, count = [files count]; i < count; i++ ) {
        
        JBJsonObject* file = [files objectAtIndex:i];
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

-(id)initWithService:(id<JBService>)service {
    
    
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
