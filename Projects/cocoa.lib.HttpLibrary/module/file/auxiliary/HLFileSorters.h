//
//  HLFileSorters.h
//  remote_gateway
//
//  Created by Richard Long on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLFile.h"


NSInteger HLFileSorters_sortByAgeAscending( HLFile* f1, HLFile* f2, void *context);
NSInteger HLFileSorters_sortByAgeDescending( HLFile* f1, HLFile* f2, void *context);

NSInteger HLFileSorters_sortByNameAscending( HLFile* f1, HLFile* f2, void *context);
NSInteger HLFileSorters_sortByNameDescending( HLFile* f1, HLFile* f2, void *context);

NSInteger HLFileSorters_sortBySizeAscending( HLFile* f1, HLFile* f2, void *context);
NSInteger HLFileSorters_sortBySizeDescending( HLFile* f1, HLFile* f2, void *context);
