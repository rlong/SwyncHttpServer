//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "CALog.h"

#import "HLDataEntity.h"
#import "HLFileRequestHandler.h"
#import "HLHttpErrorHelper.h"
#import "HLHttpRequest.h"
#import "HLHttpResponse.h"
#import "HLMimeTypes.h"
#import "HLRequestHandlerHelper.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface HLFileRequestHandler ()

// rootFolder
//NSString* _rootFolder;
@property (nonatomic, retain) NSString* rootFolder;
//@synthesize rootFolder = _rootFolder;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@implementation HLFileRequestHandler





-(id<HLEntity>)readFile:(NSString*)absolutePath {
    
    
    NSData* fileData = [NSData dataWithContentsOfFile:absolutePath];
    HLDataEntity* answer = [[HLDataEntity alloc] initWithData:fileData];
    return answer;

}

-(NSString*)toAbsolutePath:(NSString*)relativePath {
    
    
    NSString* answer = [_rootFolder stringByAppendingString:relativePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if( ![fileManager fileExistsAtPath:answer] ) {
        Log_errorFormat( @"![fileManager fileExistsAtPath:answer]; answer = '%@'", answer);
        @throw [HLHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
    }
    
    if( ![fileManager isReadableFileAtPath:answer] ) {
        Log_errorFormat( @"![fileManager isReadableFileAtPath:answer]; answer = '%@'", answer);
        @throw [HLHttpErrorHelper forbidden403FromOriginator:self line:__LINE__];
        
    }
    
    return answer;
}


// could return `nil`
-(NSString*)getETag:(NSString*)absolutePath {

    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError* error = nil;
    NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:absolutePath error:&error];
    
    if( nil != error ) {
        Log_errorError( error );
        return nil;
    }
    
    NSDate* fileModificationDate = [fileAttributes fileModificationDate];
    
    NSTimeInterval modificationInterval = [fileModificationDate timeIntervalSince1970];
    uint64_t modificationTime = (uint64_t)modificationInterval;
    NSString* answer = [NSString stringWithFormat:@"\"%lld\"", modificationTime];
    return answer;

}


-(NSString*)getProcessorUri {
    return @"/";
}


-(HLHttpResponse*)processRequest:(HLHttpRequest*)request {
	
    
	NSString* requestUri = [request requestUri];

    if( [requestUri hasSuffix:@"/"] ) { 
        requestUri = [NSString stringWithFormat:@"%@index.html", requestUri];
    }
    
    { // some validation
        
		[HLRequestHandlerHelper validateRequestUri:requestUri];
		[HLRequestHandlerHelper validateMimeTypeForRequestUri:requestUri];
    }
    
    NSString* absolutePath = [self toAbsolutePath:requestUri];
    
    NSString* eTag = [self getETag:absolutePath];
    
    
    HLHttpResponse* answer;
    
    NSString* ifNoneMatch = [request getHttpHeader:@"if-none-match"];
    if( nil != ifNoneMatch && [ifNoneMatch isEqualToString:eTag] ) {
        answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_NOT_MODIFIED_304];
    } else {
        
        id<HLEntity> body = [self readFile:absolutePath];
        
        answer = [[HLHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:body];
        
        NSString* contentType = [HLMimeTypes getMimeTypeForPath:requestUri];
        [answer setContentType:contentType];
        
    }
    
    [answer putHeader:@"ETag" value:eTag];
    
    return answer;
	
}

#pragma mark instance lifecycle

-(id)initWithRootFolder:(NSString*)rootFolder { 
    
    HLFileRequestHandler* answer = [super init];
    
    [answer setRootFolder:rootFolder];
    
    return answer;
    
    
}

-(void)dealloc { 
    
    [self setRootFolder:nil];
    

}

#pragma mark fields


// rootFolder
//NSString* _rootFolder;
//@property (nonatomic, retain) NSString* rootFolder;
@synthesize rootFolder = _rootFolder;


@end
