//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLSubject.h"

@protocol HLServerSecurityConfiguration <NSObject>

-(void)addClient:(HLSubject*)client;

-(NSString*)realm;

//can return nil
-(HLSubject*)getClient:(NSString *)clientUsername;

-(BOOL)hasClient:(NSString *)clientUsername;


-(NSArray*)getClients;

-(void)removeClient:(NSString*)clientUsername;
@end
