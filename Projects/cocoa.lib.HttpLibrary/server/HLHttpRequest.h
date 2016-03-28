//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "HLRange.h"

#import "HLEntity.h"
#import "HLHttpMethod.h"

@interface HLHttpRequest : NSObject {
	
	// created
	NSDate* _created;
	//@property (nonatomic, retain) NSDate* created;
	//@synthesize created = _created;
    
    // method
    HLHttpMethod* _method;
    //@property (nonatomic, retain) HLHttpMethod* method;
    //@synthesize method = _method;
	
	NSString* _requestUri;
	//@property (nonatomic, retain) NSString* requestUri;
	//@synthesize requestUri = _requestUri;

	NSMutableDictionary* _headers;
	//@property (nonatomic, retain) NSMutableDictionary* headers;
	//@synthesize headers = _headers;

    // range
	HLRange* _range;
	//@property (nonatomic, retain, getter=range) Range* range;
	//@synthesize range = _range;

    // entity
	id<HLEntity> _entity;
	//@property (nonatomic, retain) id<Entity> entity;
	//@synthesize entity = _entity;

    
    // closeConnectionIndicated
    NSNumber* _closeConnectionIndicated;
    //@property (nonatomic, retain) NSNumber* closeConnectionIndicated;
    //@synthesize closeConnectionIndicated = _closeConnectionIndicated;

	
}



-(void)setHttpHeader:(NSString*)headerName headerValue:(NSString*)headerValue;

-(NSString*)getHttpHeader:(NSString*)headerName;

// vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
-(BOOL)isCloseConnectionIndicated;
// ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10

#pragma mark instance setup/teardown 


#pragma mark fields


// created
//NSDate* _created;
@property (nonatomic, retain) NSDate* created;
//@synthesize created = _created;

// method
//HLHttpMethod* _method;
@property (nonatomic, retain) HLHttpMethod* method;
//@synthesize method = _method;

//NSString* _requestUri;
@property (nonatomic, retain) NSString* requestUri;
//@synthesize requestUri = _requestUri;

//NSMutableDictionary* _headers;
@property (nonatomic, retain) NSMutableDictionary* headers;
//@synthesize headers = _headers;



// range
//Range* _range;
@property (nonatomic, retain, getter=range) HLRange* range;
//@synthesize range = _range;


// entity
//id<Entity> _entity;
@property (nonatomic, retain) id<HLEntity> entity;
//@synthesize entity = _entity;


@end





