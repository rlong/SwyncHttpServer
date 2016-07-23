//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "HLService.h"
#import "HLServiceDescription.h"

@protocol HLDescribedService <NSObject,HLService>

-(HLServiceDescription*)serviceDescription;

@end
