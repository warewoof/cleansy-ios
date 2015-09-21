//
//  AppDelegate.m
//  cleansy
//
//  Created by Frank on 6/25/14.
//  Copyright (c) 2014 Warewoof. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "AppointmentViewController.h"
#import "MenuTableViewController.h"

#import "DisplayFx.h"
#import "Global.h"
#import "Util.h"
#import "IntroViewController.h"

@interface AppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation AppDelegate
{
    IntroViewController *ivc;
}
@synthesize window, navController, currentModalView;

SWRevealViewController *mainRevealController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"appdelegate start");
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    

	
    
    ivc = [[IntroViewController alloc] init];
    [ivc setDelegate:self];

    //[frontViewController presentViewController:ivc animated:NO completion:nil];
    

    self.window.rootViewController = ivc;
   	[self.window makeKeyAndVisible];
    
    //[self introComplete:YES];
    
	return YES;
     
    
}

- (void) introComplete:(BOOL)complete
{
    NSLog(@"Recieved delegate call, introComplete");
    
    [ivc dismissViewControllerAnimated:YES completion:nil];
    
    MenuTableViewController *rearViewController = [[MenuTableViewController alloc] init];
    AppointmentViewController *frontViewController = [[AppointmentViewController alloc] init];
    navController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    [[UINavigationBar appearance] setBarTintColor:[Util colorWithHexString:TITLE_BAR_BG_COLOR]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [Util colorWithHexString:TITLE_BAR_TEXT_COLOR],
                                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:20.0f]
                                                            }];
    //[[UINavigationBar appearance] setTintColor:[Util colorWithHexString:TITLE_BAR_BG_COLOR]];
    [[UINavigationBar appearance] setTintColor:[Util colorWithHexString:SCREEN_BG_COLOR]];
    mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navController];
    
    mainRevealController.rearViewRevealWidth = 260;
    mainRevealController.rearViewRevealOverdraw = 0;
    mainRevealController.rearViewRevealDisplacement = 140;
    mainRevealController.bounceBackOnOverdraw = NO;
    mainRevealController.stableDragOnOverdraw = YES;
    [mainRevealController setFrontViewPosition:FrontViewPositionLeftSideMost];
    mainRevealController.delegate = self;

    
    self.window.rootViewController = mainRevealController;
    
   	[self.window makeKeyAndVisible];

 
}

- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}

-(BOOL)revealControllerPanGestureShouldBegin:(SWRevealViewController *)revealController
{
    /* only allow swipe when closing the menu */
    if ([mainRevealController frontViewPosition] == FrontViewPositionRight) {
        return YES;
    } else {
        return NO;
    }
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    // NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    // NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    // NSLog( @"%@", NSStringFromSelector(_cmd));
}

-(void)applicationWillResignActive:(UIApplication *)application
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
    /*
     // resets app on Home press
    if (currentModalView) {
        NSLog(@"%@", currentModalView);
        [currentModalView dismissViewControllerAnimated:NO completion:nil];
        currentModalView = nil;
    }
    [navController popToRootViewControllerAnimated:NO];
     */
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
   //[mainRevealController setFrontViewPosition:FrontViewPositionLeftSideMost animated:NO];
}
@end
