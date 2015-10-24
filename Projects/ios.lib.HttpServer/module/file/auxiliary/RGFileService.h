//
//  FileService.h
//  vlc_amigo
//
//  Created by rlong on 29/07/2011.
//  Copyright 2011 HexBeerium. All rights reserved.
//


#import "JBDescribedService.h"
#import "RGFileTransactionManager.h"

@interface RGFileService : NSObject <JBDescribedService> {
    
    
    // fileJobManager
	RGFileTransactionManager* _fileJobManager;
	//@property (nonatomic, retain) FileTransactionManager* fileJobManager;
	//@synthesize fileJobManager = _fileJobManager;


}

+(NSString*)SORT_BY_AGE;
+(NSString*)SORT_BY_NAME;
+(NSString*)SORT_BY_SIZE;


+(void)listPath:(NSString*)path files:(NSMutableArray*)files folders:(NSMutableArray*)folders sort:(NSString*)sort ascending:(BOOL)ascending;

#pragma mark instance lifecycle


-(id)initWithFileTransactionManager:(RGFileTransactionManager*)fileJobManager;

@end
