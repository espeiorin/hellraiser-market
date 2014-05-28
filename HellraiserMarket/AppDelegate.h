//
//  AppDelegate.h
//  HellraiserMarket
//
//  Created by Guilherme on 5/27/14.
//  Copyright (c) 2014 guidefreitas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;

- (CoreDataHelper*)cdh;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL) hasInternetConnection;
- (NSString *) restAuthToken;
- (void) showAlert:(NSString *) title withMessage:(NSString *)message;
- (void) showLoading:(UIView *) view;
- (void) hideLoading:(UIView *) view;
@end
