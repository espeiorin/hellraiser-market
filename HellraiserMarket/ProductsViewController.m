//
//  ProductsViewController.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "ProductsViewController.h"
#import "UIViewController+HRViewControllerCategory.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProductCell.h"
#import "ProductsHeaderCell.h"

@interface ProductsViewController ()

@end

@implementation ProductsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) settingsButtonTapped:(id) sender{
    NSLog(@"Settings button tapped");
    [self showAlert:@"Ops" withMessage:@"Funcionalidade não implementada :)"];
}

- (void)cartButtonTapped:(id) sender{
    NSLog(@"Cart button tapped");
    [self showAlert:@"Ops" withMessage:@"Funcionalidade não implementada :)"];
}

-(void) addSettingsAndCartButtons{
    
    UIImage *imageSettings = [UIImage imageNamed:@"SettingsIcon"];
    CGRect frame = CGRectMake(0, 0, 36, 36);
    UIButton* settingsButton = [[UIButton alloc] initWithFrame:frame];
    [settingsButton setBackgroundImage:imageSettings forState:UIControlStateNormal];
    [settingsButton setShowsTouchWhenHighlighted:YES];
    [settingsButton addTarget:self action:@selector(settingsButtonTapped:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    UIImage *imageCart = [UIImage imageNamed:@"CartIcon"];
    UIButton* cartButton = [[UIButton alloc] initWithFrame:frame];
    [cartButton setBackgroundImage:imageCart forState:UIControlStateNormal];
    [cartButton setShowsTouchWhenHighlighted:YES];
    [cartButton addTarget:self action:@selector(cartButtonTapped:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *cartBarButton = [[UIBarButtonItem alloc] initWithCustomView:cartButton];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cartBarButton,settingsBarButton, nil];
    
}

- (void) changeBorderColor{
    CALayer *border = [CALayer layer];
    border.borderColor = [UIColor colorWithRed:0 green:0.76 blue:0.94 alpha:1].CGColor;
    border.borderWidth = 4;
    CALayer *layer = self.navigationController.navigationBar.layer;
    border.frame = CGRectMake(0, layer.bounds.size.height, layer.bounds.size.width, 4);
    [layer addSublayer:border];
}

- (void) setupStyles{
    [self changeBorderColor];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.07 green:0.78 blue:0.94 alpha:1]];
}

- (void) loadData{
    self.title = self.brand.name;
    [self configureFetch];
    [self performFetch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(!_cdh){
        _cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    }
    [self setupStyles];
    [self addSettingsAndCartButtons];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.brand){
        [self loadData];
    }
}

- (void) setBrand:(Brand *)brand{
    _brand = brand;
    if(_cdh){
        [self loadData];
    }
}

- (void) configureFetch{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand == %@", self.brand ];
    [request setPredicate:predicate];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil];
    [request setFetchBatchSize:20];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_cdh.context sectionNameKeyPath:nil cacheName:nil];
    [request setFetchBatchSize:1];
    self.frc.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    NSLog(@"Orientation changed!");
    [self changeBorderColor];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];

    cell.nameLabel.text = @"";
    cell.descriptionLabel.text = @"";
    cell.priceLabel.text = @"";
    cell.productImageView.image = nil;
    
    Product *product = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"%@", product);
    cell.nameLabel.text = product.descriptionProduct;
    cell.descriptionLabel.text = product.descriptionProduct;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceString = [numberFormatter stringFromNumber:product.price];
    cell.priceLabel.text = priceString;
    
    [cell.productImageView setImageWithURL:[NSURL URLWithString:product.snapshot]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ProductsHeaderCell *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"productsCollectionHeader" forIndexPath:indexPath];
    Product *product = [self.frc objectAtIndexPath:indexPath];
    
    headerCell.descriptionLabel.text = product.brand.descriptionBrand;
    return headerCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Product *product = [self.frc objectAtIndexPath:indexPath];
    [self.delegate didSelectProduct:product];
}

@end
