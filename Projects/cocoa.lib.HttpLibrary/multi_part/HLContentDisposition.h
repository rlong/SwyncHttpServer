// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


#import "HLHttpHeader.h"

/// <summary>
/// as per http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
/// </summary>
@interface HLContentDisposition : NSObject <HLHttpHeader> {
    
    
    
    // dispExtensionToken ... can be null, see http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
    NSString* _dispExtensionToken;
    //@property (nonatomic, retain) NSString* dispExtensionToken;
    //@synthesize dispExtensionToken = _dispExtensionToken;
    
    
    // value
    NSString* _value;
    //@property (nonatomic, retain) NSString* value;
    //@synthesize value = _value;

    
    // dispositionParameters
    NSMutableDictionary* _dispositionParameters;
    //@property (nonatomic, retain) NSMutableDictionary* dispositionParameters;
    //@synthesize dispositionParameters = _dispositionParameters;


}

-(NSString*)getDispositionParameter:(NSString*)parameterName defaultValue:(NSString*)defaultValue;


+(HLContentDisposition*)buildFromString:(NSString*)value;


#pragma mark -
#pragma mark fields


// dispExtensionToken ... can be null, see http://www.w3.org/Protocols/rfc2616/rfc2616-sec19.html#sec19.5.1
//NSString* _dispExtensionToken;
@property (nonatomic, retain) NSString* dispExtensionToken;
//@synthesize dispExtensionToken = _dispExtensionToken;


@end
