//
//  iPhoneMainViewController.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/28/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandsTableViewController.h"
#import "ProductsViewController.h"
#import "ProductDetailViewController.h"

@interface iPhoneMainViewController : UIViewController <BrandsDataDelegate, ProductsDataDelegate>

@end
