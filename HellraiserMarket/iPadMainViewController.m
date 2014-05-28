//
//  iPadMainViewController.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "iPadMainViewController.h"

@interface iPadMainViewController ()

@end

@implementation iPadMainViewController{
    BrandsTableViewController *brandsViewController;
    ProductsViewController *productsViewController;
    UINavigationController *productsNavViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)setLeftBrandsController:(UIViewController *)leftBrandsController
{
    _leftBrandsController = leftBrandsController;
    
    [self addChildViewController:_leftBrandsController];
    [_leftBrandsController didMoveToParentViewController:self];
    
    if ([self isViewLoaded]) {
        [self updateLeftArea];
    }
}

- (void)setRightProductsController:(UIViewController *)rightProductsController
{
    _rightProductsController = rightProductsController;
    
    [self addChildViewController:_rightProductsController];
    [_rightProductsController didMoveToParentViewController:self];
    
    if ([self isViewLoaded]) {
        [self updateRightArea];
    }
}

-(void) updateLeftArea{
    _leftBrandsController.view.frame = _leftArea.bounds;
    [_leftArea addSubview:_leftBrandsController.view];
}

-(void) updateRightArea{
    _rightProductsController.view.frame = _rightArea.bounds;
    [_rightArea addSubview:_rightProductsController.view];
}

-(void) setupAreas{
    if (!_leftBrandsController){
        brandsViewController =
        [[UIStoryboard storyboardWithName:@"Main-iPad"
                                   bundle:NULL] instantiateViewControllerWithIdentifier:@"SBIDbrandsViewController"];
        brandsViewController.delegate = self;
        UINavigationController *navViewController = [[UINavigationController alloc]initWithRootViewController:brandsViewController];
        [self setLeftBrandsController:navViewController];
    }else{
        [self updateLeftArea];
    }
    
    if (!_rightProductsController){

        productsViewController =
        [[UIStoryboard storyboardWithName:@"Main-iPad" bundle:NULL]
         instantiateViewControllerWithIdentifier:@"SBIDproductsViewController"];
        productsViewController.delegate = self;
        productsNavViewController = [[UINavigationController alloc]initWithRootViewController:productsViewController];
        [self setRightProductsController:productsNavViewController];
    }else{
        [self updateRightArea];
    }
}

- (void) didSelectBrand: (Brand *)brand{
    NSLog(@"Brand selected: %@", brand.name);
    productsViewController.brand = brand;
    [productsNavViewController popViewControllerAnimated:YES];
}

- (void) didSelectProduct: (Product *)product{
    NSLog(@"Product selected: %@", product.description);
    ProductDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main-iPad"
                                                                                   bundle:NULL] instantiateViewControllerWithIdentifier:@"SBIDproductDetailViewController"];
    detailViewController.product = product;
    [productsNavViewController pushViewController:detailViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupAreas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
