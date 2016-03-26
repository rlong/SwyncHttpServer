//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLSubject.h"

@protocol HLClientSecurityConfiguration <NSObject>


-(void)addServer:(HLSubject*)server;
-(NSString*)username;

-(BOOL)hasServer:(NSString *)realm;
-(HLSubject*)getServer:(NSString*)realm;

-(void)removeServer:(NSString *)realm;

@end
