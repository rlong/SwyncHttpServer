//
//  HLFileSorters.h
//  remote_gateway
//
//  Created by Richard Long on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CAFile.h"


NSInteger HLFileSorters_sortByAgeAscending( CAFile* f1, CAFile* f2, void *context);
NSInteger HLFileSorters_sortByAgeDescending( CAFile* f1, CAFile* f2, void *context);

NSInteger HLFileSorters_sortByNameAscending( CAFile* f1, CAFile* f2, void *context);
NSInteger HLFileSorters_sortByNameDescending( CAFile* f1, CAFile* f2, void *context);

NSInteger HLFileSorters_sortBySizeAscending( CAFile* f1, CAFile* f2, void *context);
NSInteger HLFileSorters_sortBySizeDescending( CAFile* f1, CAFile* f2, void *context);
