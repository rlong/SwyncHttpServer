//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@class HLHttpRequest;
@class HLHttpResponse;

#import "HLRequestHandler.h"


@interface HLFileRequestHandler : NSObject <HLRequestHandler> {
    
	// rootFolder
	NSString* _rootFolder;
	//@property (nonatomic, retain) NSString* rootFolder;
	//@synthesize rootFolder = _rootFolder;


}



-(HLHttpResponse*)processRequest:(HLHttpRequest*)request;


#pragma mark instance lifecycle


-(id)initWithRootFolder:(NSString*)rootFolder; 

@end
