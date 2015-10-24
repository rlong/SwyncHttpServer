//
//  RGFileSorters.h
//  remote_gateway
//
//  Created by Richard Long on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RGFile.h"


NSInteger RGFileSorters_sortByAgeAscending( RGFile* f1, RGFile* f2, void *context);
NSInteger RGFileSorters_sortByAgeDescending( RGFile* f1, RGFile* f2, void *context);

NSInteger RGFileSorters_sortByNameAscending( RGFile* f1, RGFile* f2, void *context);
NSInteger RGFileSorters_sortByNameDescending( RGFile* f1, RGFile* f2, void *context);

NSInteger RGFileSorters_sortBySizeAscending( RGFile* f1, RGFile* f2, void *context);
NSInteger RGFileSorters_sortBySizeDescending( RGFile* f1, RGFile* f2, void *context);
