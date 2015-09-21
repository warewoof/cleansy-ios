//
//  IntroViewController.h
//  cleansy
//
//  Created by Frank on 8/20/14.
//  Copyright (c) 2014 Warewoof. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewControllerDelegate

@required
- (void)introComplete:(BOOL)complete;
@end

@interface IntroViewController : UIViewController  <UIScrollViewDelegate>

@property (nonatomic, assign) id delegate;

@end
