#import "SocialViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "SWRevealViewController.h"
#import "CleaningViewController.h"
#import "QuoteViewController.h"
#import "OrderManager.h"
#import "Util.h"
#import "UIView+Toast.h"
#import <Social/Social.h>

#define TAG_BTN1 101
#define TAG_BTN2 102
#define TAG_BTN3 103
#define TAG_BTN4 104
#define TAG_BTN5 105

@interface SocialViewController ()

@end

@implementation SocialViewController
{
    CGFloat screenHeight, screenWidth;
    OrderManager *order;
    UIButton *menuButton;
    UIButton *addressButton;
    UIButton *scheduleButton;
    UIButton *nextButton;
    UIButton *previousButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"SocialViewController viewDidLoad");
    if (!_presentedAsModal) {
        SWRevealViewController *revealController = self.revealViewController;
        //[self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)loadView
{
    NSLog(@"LoginView loadView");
    
    order = [OrderManager sharedManager];
    
    self.view = [[UIView alloc] init];
    
    // UIViewController Settings //
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [Util colorWithHexString:SCREEN_BG_COLOR];
    [contentView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    
    self.view = contentView;
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    NSLog(@"screenHeight:%f, screenWidth:%f", screenHeight, screenWidth);
    
    /*
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patternbackground"]];
    [bgImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight+20)];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
     */
    
    [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"Share with friends"
                                                              y_pos:screenHeight*.15 + 20
                                                         withAction:nil
                                                       inController:nil]];
    
    if (!_presentedAsModal) {
        self.navigationItem.title = @"cleansy";
        
        UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setBounds:CGRectMake( 0, 0, 25, 25 )];
        [menuButton setImage:menuImage forState:UIControlStateNormal];
        UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:menuBtn];
        
        SEL backSelector = @selector(clickPreviousButton:);
        previousButton = [DisplayFx bottomLeftBackButtonWithSelector:backSelector
                                                         inController:self
                                                      backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BACKBTN_BG_COLOR]];
        [self.view addSubview:previousButton];
        
        SEL selector = @selector(clickNextButton:);
        nextButton = [DisplayFx bottomRightButtonWithSelector:selector
                                                  inController:self
                                                    buttonText:@"CLOSE"
                                                     textColor:[UIColor whiteColor]
                                               backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
        [self.view addSubview:nextButton];
    } else {
        [self.navigationItem setTitle:@"SHARING"];
        [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:TITLE_BAR_BG_COLOR_MODAL]];
        [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                           NSForegroundColorAttributeName: [Util colorWithHexString:TITLE_BAR_TEXT_COLOR_MODAL],
                                                                           NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:20.0f]
                                                                           }];
        UIImage *exitImage = [UIImage imageNamed:@"exit-512.png"];
        menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setBounds:CGRectMake( 0, 0, 25, 25 )];
        [menuButton setImage:exitImage forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(clickedExit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *exitNavButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
        [self.navigationItem setLeftBarButtonItem:exitNavButton];
    }
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"Your friend can get $20 off their first cleaning with this code.  And for each friend that uses this code we will send you a coupon for $20 off your next cleaning."
                                                      y_pos:screenHeight*0.25
                                                   pctWidth:0.8]];
    
    [self.view addSubview:[DisplayFx customTextLabel:@"SD234S"
                                               y_pos:screenHeight*0.43
                                            widthPct:0.8
                                             leftPct:0.1
                                                font:[UIFont fontWithName: @"Arial-BoldItalicMT" size:22]
                                           textColor:[Util colorWithHexString:@"505050"]]];
    /*
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"SD234S"
                                                      y_pos:screenHeight*0.4
                                                   pctWidth:0.8]];
    */
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"Share with your friends"
                                                      y_pos:screenHeight*0.55
                                                   pctWidth:0.8]];
    
    float snIconHeight = screenHeight * 0.65;
    UIImage *sn1 = [UIImage imageNamed:@"facebook256.png"];
    UIImage *sn2 = [UIImage imageNamed:@"twitter256.png"];
    UIImage *sn3 = [UIImage imageNamed:@"google256.png"];
    UIImage *sn4 = [UIImage imageNamed:@"sms256.png"];
    UIButton *sn1btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sn2btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sn3btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *sn4btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sn1btn setTag:TAG_BTN1];
    [sn2btn setTag:TAG_BTN2];
    [sn3btn setTag:TAG_BTN3];
    [sn4btn setTag:TAG_BTN4];
    [sn1btn addTarget:self action:@selector(clickedShareIcon:) forControlEvents:UIControlEventTouchUpInside];
    [sn2btn addTarget:self action:@selector(clickedShareIcon:) forControlEvents:UIControlEventTouchUpInside];
    [sn3btn addTarget:self action:@selector(clickedShareIcon:) forControlEvents:UIControlEventTouchUpInside];
    [sn4btn addTarget:self action:@selector(clickedShareIcon:) forControlEvents:UIControlEventTouchUpInside];
    [sn1btn setFrame:CGRectMake( screenWidth/5-25, snIconHeight, 50, 50 )];
    [sn2btn setFrame:CGRectMake( screenWidth/5*2-25, snIconHeight, 50, 50 )];
    [sn3btn setFrame:CGRectMake( screenWidth/5*3-25, snIconHeight, 50, 50 )];
    [sn4btn setFrame:CGRectMake( screenWidth/5*4-25, snIconHeight, 50, 50 )];
    [sn1btn setImage:sn1 forState:UIControlStateNormal];
    [sn2btn setImage:sn2 forState:UIControlStateNormal];
    [sn3btn setImage:sn3 forState:UIControlStateNormal];
    [sn4btn setImage:sn4 forState:UIControlStateNormal];
    [self.view addSubview:sn1btn];
    [self.view addSubview:sn2btn];
    [self.view addSubview:sn3btn];
    [self.view addSubview:sn4btn];
}

- (void)clickNextButton:(UIButton *)sender
{
    NSLog(@"clickNextButton");
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickPreviousButton:(UIButton *)sender
{
    NSLog(@"clickPreviousButton");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickedExit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickMenuButton:(id)sender
{
    NSLog(@"clickMenuButton");
}

- (void)clickedShareIcon:(id)sender
{
    UIButton *shareButton = sender;
    NSLog(@"clickedShareIcon tag:%ld",(long)shareButton.tag);
    
    switch (shareButton.tag) {
        case TAG_BTN1:  // facebook
        {
            
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultCancelled) {
                        
                        NSLog(@"Cancelled");
                        
                    } else
                        
                    {
                        NSLog(@"Done");
                    }
                    
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler =myBlock;
                
                [controller setInitialText:@"Use this code with Cleansy and we can both get $20 off our next cleaning! SD234S"];
                
                [controller addURL:[NSURL URLWithString:@"http://www.sweepd.com"]];
                
                [controller addImage:[UIImage imageNamed:@"Icon-76@2x.png"]];
                
                [self presentViewController:controller animated:YES completion:Nil];
                
            }
            else{
                NSLog(@"Facebook account not set up");
                [self.view makeToast:@"Sorry, your device has to be logged into Facebook to share.  Please check Settings->Facebook" duration:3.5];

                //[self shareLinkWithShareDialog];
            }

            
            break;
        }
        case TAG_BTN2:  // twitter
        {
            
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultCancelled) {
                        
                        NSLog(@"Cancelled");
                        
                    } else
                        
                    {
                        NSLog(@"Done");
                    }
                    
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler =myBlock;
                
                [controller setInitialText:@"Use this code with Cleansy and we can both get $20 off our next cleaning! SD234S"];
                
                [controller addURL:[NSURL URLWithString:@"http://www.sweepd.com"]];
                
                [controller addImage:[UIImage imageNamed:@"Icon-76@2x.png"]];
                
                [self presentViewController:controller animated:YES completion:Nil];
                
            }
            else{
                NSLog(@"Twitter account not set up");
                [self.view makeToast:@"Sorry, your device has to be logged into Twitter to share.  Please check Settings->Twitter" duration:3.5];
            }
            
            break;
        }
        case TAG_BTN3:  // google
        {
            NSURL *url = [NSURL URLWithString:@"https://m.google.com/app/plus/x/?v=compose&content=this_is_a_test"];
            [[UIApplication sharedApplication] openURL:url];
            
            break;
        }

            
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
}

#pragma mark Facebook Handler
/*
- (void)shareLinkWithShareDialog
{
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"http://www.sweepd.com/"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Cleansy", @"name",
                                       @"GUse this code with Cleansy and we can both get $20 off our next cleaning! SD234S", @"caption",
                                       @"Use this code with Cleansy and we can both get $20 off our next cleaning! SD234S", @"description",
                                       @"http://www.sweepd.com/", @"link",
                                       @"http://www.sweepd.com/favicon.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
 */

@end
