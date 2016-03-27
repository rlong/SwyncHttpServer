//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@class CABaseException;
@class HLHttpResponse;

@interface HLHttpErrorHelper : NSObject


+(CABaseException*)badRequest400FromOriginator:(id)originator line:(int)line;
+(CABaseException*)unauthorized401FromOriginator:(id)originator line:(int)line;
+(CABaseException*)forbidden403FromOriginator:(id)originator line:(int)line;
+(CABaseException*)notFound404FromOriginator:(id)originator line:(int)line;
+(CABaseException*)requestEntityTooLarge413FromOriginator:(id)originator line:(int)line;

+(CABaseException*)internalServerError500FromOriginator:(id)originator line:(int)line;
+(CABaseException*)notImplemented501FromOriginator:(id)originator line:(int)line;

+(HLHttpResponse*)toHttpResponse:(NSException*)e;

@end
