//
//  RGFileSorters.h
//  remote_gateway
//
//  Created by Richard Long on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLFile.h"


NSInteger RGFileSorters_sortByAgeAscending( HLFile* f1, HLFile* f2, void *context);
NSInteger RGFileSorters_sortByAgeDescending( HLFile* f1, HLFile* f2, void *context);

NSInteger RGFileSorters_sortByNameAscending( HLFile* f1, HLFile* f2, void *context);
NSInteger RGFileSorters_sortByNameDescending( HLFile* f1, HLFile* f2, void *context);

NSInteger RGFileSorters_sortBySizeAscending( HLFile* f1, HLFile* f2, void *context);
NSInteger RGFileSorters_sortBySizeDescending( HLFile* f1, HLFile* f2, void *context);
