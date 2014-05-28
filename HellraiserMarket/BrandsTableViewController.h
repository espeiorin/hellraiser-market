//
//  BrandsTableViewController.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketService.h"
#import "CoreDataTVC.h"

@protocol BrandsDataDelegate <NSObject>
@required
- (void) didSelectBrand: (Brand *)brand;
@end

@interface BrandsTableViewController : CoreDataTVC

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) MarketService *marketService;
@property (nonatomic, readonly) CoreDataHelper *cdh;

@end
