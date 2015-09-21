//
//  AppDelegate.h
//  cleansy
//
//  Created by Frank on 6/25/14.
//  Copyright (c) 2014 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate : UIResponder <UIApplicationDelegate, IntroViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *navController;
@property (nonatomic) UIViewController *currentModalView;

@end
