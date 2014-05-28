//
//  BrandsTableViewController.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "BrandsTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+HRViewControllerCategory.h"
#import "UIImage+HRImage.h"

@interface BrandsTableViewController (){
    NSArray *brandsData;
    AppDelegate *mainDelegate;
}

@end

@implementation BrandsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void) changeTitleViewToSearchMode{
    NSLog(@"Searching mode");
}

- (void) changeTitleViewToOptions{
    float fontSize = 16.0f;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 100)];
    UIButton *brandsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [brandsButton setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1]
                           forState:UIControlStateNormal];
    [brandsButton setTitleColor:[UIColor colorWithRed:0 green:0.78 blue:0.94 alpha:1]
                       forState:UIControlStateSelected];
    brandsButton.frame = CGRectMake(10, 0, 100, 100);
    [brandsButton setTitle:@"Marca" forState:UIControlStateNormal];
    brandsButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [brandsButton addTarget:self action:@selector(brandButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [brandsButton setSelected:YES];
    
    UIButton *categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [categoryButton setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1]
                       forState:UIControlStateNormal];
    [categoryButton setTitleColor:[UIColor colorWithRed:0 green:0.78 blue:0.94 alpha:1]
                       forState:UIControlStateSelected];
    categoryButton.frame = CGRectMake(110, 0, 100, 100);
    [categoryButton setTitle:@"Categoria" forState:UIControlStateNormal];
    categoryButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [categoryButton addTarget:self action:@selector(categoryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitleColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1]
                         forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithRed:0 green:0.78 blue:0.94 alpha:1]
                         forState:UIControlStateSelected];
    searchButton.frame = CGRectMake(280, 30, 36, 36);
    searchButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [searchButton setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateHighlighted];
    [searchButton setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(searchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    [titleView addSubview:brandsButton];
    [titleView addSubview:categoryButton];
    [titleView addSubview:searchButton];
    
    self.navigationItem.titleView = titleView;
}

-(void) searchButtonTapped{
    NSLog(@"Search button tapped");
    [self showAlert:@"Ops" withMessage:@"Funcionalidade não implementada :)"];
}

-(void) categoryButtonTapped{
    NSLog(@"Category button tapped");
    [self showAlert:@"Ops" withMessage:@"Funcionalidade não implementada :)"];
}

-(void) brandButtonTapped{
    NSLog(@"Brand button tapped");
    [self showAlert:@"Ops" withMessage:@"Funcionalidade não implementada :)"];
}


- (void) configureFetch{
    NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Brand"];
    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    [request setFetchBatchSize:20];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_cdh.context sectionNameKeyPath:nil cacheName:nil];
    [request setFetchBatchSize:1];
    self.frc.delegate = self;
}

- (void) loadData{

    
    if([mainDelegate hasInternetConnection] == NO && [_marketService databaseIsEmpty] == YES){
        [self showAlert:@"Ops" withMessage:@"É necessário conectar na internet na primeira execução"];
        return;
    }
    
    [self performFetch];
    
    [self showLoading];
    [_marketService loadData:^(NSArray *objects, NSError *error) {
        [self hideLoading];
        if(error){
            NSString *friendlyErrorMessage = @"Ocorreu um problema ao sincronizar os dados com o servidor.";
            [mainDelegate showAlert:@"Ops" withMessage:friendlyErrorMessage];
        }
    }];
}

- (void) setupStyles{
    [self changeBorderColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!mainDelegate){
        mainDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    }
    
    if(!_cdh){
        _cdh = [mainDelegate cdh];
    }
    if(!_marketService){
        _marketService = [[MarketService alloc] init];
    }
    
    [self configureFetch];
    [self loadData];
    [self setupStyles];
    [self changeTitleViewToOptions];
}

- (void) viewWillAppear:(BOOL)animated{
    
}


- (void) changeBorderColor{
    CALayer *border = [CALayer layer];
    border.borderColor = [UIColor colorWithRed:0 green:0.76 blue:0.94 alpha:1].CGColor;
    border.borderWidth = 4;
    CALayer *layer = self.navigationController.navigationBar.layer;
    NSLog(@"Height: %f", layer.bounds.size.height);
    NSLog(@"Width: %f", layer.bounds.size.width);
    border.frame = CGRectMake(0, layer.bounds.size.height, layer.bounds.size.width, 4);
    [layer addSublayer:border];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandCellIdentifier" forIndexPath:indexPath];
    UIImageView *brandImage = (UIImageView *) [cell viewWithTag:2];
    UILabel *brandLabel = (UILabel *) [cell viewWithTag:4];
    brandLabel.text = @"";
    brandImage.image = nil;
    cell.backgroundColor = [UIColor clearColor];
    
    Brand *brand  = [self.frc objectAtIndexPath:indexPath];
    NSLog(@"%@", brand.image);
    CGSize imgFrame = brandImage.frame.size;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    [brandImage setImageWithURL:[NSURL URLWithString:brand.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(!error){
            brandLabel.text = @"";
            brandImage.image = nil;
            dispatch_async(queue, ^{
                //Esta parte do código não está otimizada.
                //Deveria fazer cache das imagens convertidas e reutilizar
                UIImage *gray = [UIImage convertToGreyscale:image];
                UIImage *noWhite = [UIImage changeWhiteColorTransparent:gray];
                UIImage *resizedImage = [UIImage imageWithImage:noWhite scaledToSize:imgFrame];

                dispatch_sync(dispatch_get_main_queue(), ^{
                    brandImage.image = resizedImage;
                });
            });
        }else{
            brandLabel.text = brand.name;
        }
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Brand *brand = [self.frc objectAtIndexPath:indexPath];
    [[self delegate] didSelectBrand:brand];
    
}




@end
