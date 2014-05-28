//
//  UIViewController+HRViewControllerCategory.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (HRViewControllerCategory)

- (void) showAlert:(NSString *) title withMessage:(NSString *)message;
- (void) showLoading;
- (void) hideLoading;

@end
