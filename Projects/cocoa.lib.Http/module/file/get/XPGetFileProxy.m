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

#import "XPGetFileProxy.h"
#import "XPGetFileService.h"
#import "XPRemoteFileReference.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface XPGetFileProxy ()


// service
//id<Service> _service;
@property (nonatomic, retain) id<JBService> service;
//@synthesize service = _service;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation XPGetFileProxy




-(NSMutableArray*)getFilesForDownload {
    
    NSMutableArray* answer = [[NSMutableArray alloc] init];
    [answer autorelease];
    
    JBBrokerMessage* request = [JBBrokerMessage buildRequestWithServiceName:[XPGetFileService SERVICE_NAME] methodName:@"getFilesForDownload"];
    
    JBBrokerMessage* response = [_service process:request];
    JBJsonObject* ap = [response associativeParamaters];
    JBJsonArray* files = [ap jsonArrayForKey:@"files"];
    for( int i = 0, count = [files count]; i < count; i++ ) {
        
        JBJsonObject* file = [files objectAtIndex:i];
        NSString* filename = [file stringForKey:@"filename"];
        Log_debugString( filename );
        long long filesize = [file longLongForKey:@"filesize"];
        NSString* uri = [file stringForKey:@"uri"];
        
        XPRemoteFileReference* fileReference = [[XPRemoteFileReference alloc] initWithFilename:filename filesize:filesize uri:uri];
        {
            [answer addObject:fileReference];
        }
        [fileReference release];
        
    }
    
    return answer;
    
}



#pragma instance -
#pragma instance lifecycle

-(id)initWithService:(id<JBService>)service {
    
    
    XPGetFileProxy* answer = [super init];
    
    
    if( nil != answer ) {
        
        [answer setService:service];
    }
    
    
    
    return answer;
}

-(void)dealloc {
    
	[self setService:nil];
	
	[super dealloc];
	
}

#pragma instance -
#pragma mark fields


// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;

@end
