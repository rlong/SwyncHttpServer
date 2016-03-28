//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "HLAuthenticationInfo.h"
#import "HLEntity.h"
#import "HLWwwAuthenticate.h"
#import "HLHttpStatus.h"
#import "HLRange.h"

@protocol HLConnectionDelegate;


@interface HLHttpResponse : NSObject {
    
    
    
    // connectionDelegate
    id<HLConnectionDelegate> _connectionDelegate;
    //@property (nonatomic, retain) id<HLConnectionDelegate> connectionDelegate;
    //@synthesize connectionDelegate = _connectionDelegate;

	
    // status
	int _status;
	//@property (nonatomic) int status;
	//@synthesize status = _status;

    NSMutableDictionary* _headers;
	//@property (nonatomic, retain) NSMutableDictionary* headers;
	//@synthesize headers = _headers;

	// range
	HLRange* _range;
	//@property (nonatomic, retain) Range* range;
	//@synthesize range = _range;

    
    ////////////////////////////////////////////////////////////////////////////
	// entity
	id<HLEntity> _entity;
	//@property (nonatomic, retain) id<Entity> entity;
	//@synthesize entity = _entity;
	
	
	
}

-(void)setContentType:(NSString*)contentType; 

-(void)putHeader:(NSString*)header value:(NSString*)value;
-(NSString*)getHeader:(NSString*)header;


#pragma mark instance setup/teardown 


-(id)initWithStatus:(int)status;

-(id)initWithStatus:(int)status entity:(id<HLEntity>)entity;


#pragma mark -
#pragma mark fields

// connectionDelegate
//id<HLConnectionDelegate> _connectionDelegate;
@property (nonatomic, retain) id<HLConnectionDelegate> connectionDelegate;
//@synthesize connectionDelegate = _connectionDelegate;


// status
//int _status;
@property (nonatomic) int status;
//@synthesize status = _status;

//NSMutableDictionary* _headers;
@property (nonatomic, retain) NSMutableDictionary* headers;
//@synthesize headers = _headers;


// range
//Range* _range;
@property (nonatomic, retain) HLRange* range;
//@synthesize range = _range;

////////////////////////////////////////////////////////////////////////////
// entity
//id<Entity> _entity;
@property (nonatomic, retain) id<HLEntity> entity;
//@synthesize entity = _entity;


@end
