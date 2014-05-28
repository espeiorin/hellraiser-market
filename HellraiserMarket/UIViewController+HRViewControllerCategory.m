//
//  UIViewController+HRViewControllerCategory.m
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import "UIViewController+HRViewControllerCategory.h"

@implementation UIViewController (HRViewControllerCategory)

- (void) showAlert:(NSString *) title withMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) showLoading{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void) hideLoading{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end


