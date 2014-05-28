//
//  MarketService.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResultBlock)(NSArray *objects, NSError *error);

@interface MarketService : NSObject

- (void) loadData:(ResultBlock)block;
- (void) loadDataRemote:(ResultBlock)block;;
- (void) loadDataLocal:(ResultBlock)block;;
- (BOOL) databaseIsEmpty;
@end
