//
//  ProductDetainViewController.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/28/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}


- (void) loadData{
    [self.productImageView setImageWithURL:[NSURL URLWithString:self.product.snapshot]];
    self.nameLabel.text = self.product.descriptionProduct;
    self.descriptionLabel.text = self.product.descriptionProduct;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceString = [numberFormatter stringFromNumber:self.product.price];
    self.priceLabel.text = priceString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



@end
