//
//  iPadMainViewController.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandsTableViewController.h"
#import "ProductsViewController.h"
#import "ProductDetailViewController.h"

@interface iPadMainViewController : UIViewController <BrandsDataDelegate, ProductsDataDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftArea;
@property (weak, nonatomic) IBOutlet UIView *rightArea;
@property (strong,nonatomic) UIViewController *leftBrandsController;
@property (strong,nonatomic) UIViewController *rightProductsController;
@end
