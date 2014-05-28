//
//  ProductsViewController.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataCVC.h"

@protocol ProductsDataDelegate <NSObject>
@required
- (void) didSelectProduct: (Product *)product;
@end

@interface ProductsViewController : CoreDataCVC

@property (strong, nonatomic) id delegate;
@property (nonatomic, nonatomic) CoreDataHelper *cdh;
@property (strong, nonatomic) Brand *brand;

@end
