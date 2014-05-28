//
//  ProductCell.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UICollectionViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
