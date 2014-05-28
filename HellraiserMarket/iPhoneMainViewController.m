//
//  iPhoneMainViewController.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/28/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "iPhoneMainViewController.h"

@interface iPhoneMainViewController ()

@end

@implementation iPhoneMainViewController{
    BrandsTableViewController *brandsViewController;
    UINavigationController *navController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    brandsViewController = [[UIStoryboard storyboardWithName:@"Main-iPad"
                                                      bundle:NULL] instantiateViewControllerWithIdentifier:@"SBIDbrandsViewController"];
    brandsViewController.delegate = self;
    navController = [[UINavigationController alloc]initWithRootViewController:brandsViewController];
    [self.view addSubview:navController.view];
    [self.navigationController pushViewController:brandsViewController animated:NO];
}

- (void) didSelectBrand: (Brand *)brand{
    NSLog(@"Brand selected: %@", brand.name);
    ProductsViewController *productsViewController = [[UIStoryboard storyboardWithName:@"Main-iPad" bundle:NULL]
                                                      instantiateViewControllerWithIdentifier:@"SBIDproductsViewController"];
    productsViewController.delegate = self;

    productsViewController.brand = brand;
    [navController pushViewController:productsViewController animated:YES];
}

- (void) didSelectProduct: (Product *)product{
    NSLog(@"Product selected: %@", product.description);
    ProductDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main-iPad"
                                                                                   bundle:NULL] instantiateViewControllerWithIdentifier:@"SBIDproductDetailViewController"];
    detailViewController.product = product;
    [navController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
