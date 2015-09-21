#import "CleaningViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "SWRevealViewController.h"
#import "CleaningViewController.h"
#import "QuoteViewController.h"
#import "OrderManager.h"
#import "MELetterCircleView.h"
#import "CleaningInfoViewController.h"
#import "AppDelegate.h"
#import "Util.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"

#define TAG_BTN_BED_LEFT 101
#define TAG_BTN_BED_RIGHT 102
#define TAG_BTN_BATH_LEFT 103
#define TAG_BTN_BATH_RIGHT 104
#define TAG_BED_COUNT_VIEW 105
#define TAG_BATH_COUNT_VIEW 106
#define TAG_CLEANING_RATE 107

@interface CleaningViewController ()

@end

@implementation CleaningViewController
{
    UIButton *menuButton, *addressButton, *scheduleButton, *nextButton, *previousButton;
    CGFloat screenHeight, screenWidth;
    UILabel *bedCounter;
    UILabel *bathCounter;
    UISegmentedControl *cleaningOption;
    OrderManager *order;
    bool requestingQuote;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"CleaningViewController viewDidLoad");
    SWRevealViewController *revealController = self.revealViewController;
    //[self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    bedCounter = (UILabel *)[self.view viewWithTag:TAG_BED_COUNT_VIEW];
    bathCounter = (UILabel *)[self.view viewWithTag:TAG_BATH_COUNT_VIEW];
    cleaningOption = (UISegmentedControl *)[self.view viewWithTag:TAG_CLEANING_RATE];
    requestingQuote = NO;
}

- (void)loadView
{
    NSLog(@"LoginView loadView");
    
    order = [OrderManager sharedManager];
    [order setCostQuote: 0];
    [order setTimeEstimate: 0];
    
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
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
     */
    
    self.navigationItem.title = @"cleansy";
    
    UIImage *menuImage = [UIImage imageNamed:@"menu.png"];
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setBounds:CGRectMake( 0, 0, 25, 25 )];
    [menuButton setImage:menuImage forState:UIControlStateNormal];
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuBtn];
    
    [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"cleaning information"
                                                              y_pos:screenHeight*.15 + 20
                                                         withAction:nil
                                                       inController:nil]];
    
    [self.view addSubview:[DisplayFx themeContentText:@"# of bedrooms" y_pos:screenHeight*.20 + 20]];
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"(bedrooms and studies only)"
                                                      y_pos:screenHeight*.23 + 20
                                                   pctWidth:0.7]];
    
    SEL selector = @selector(clickedRoomSelector:);
    [self.view addSubview:[DisplayFx themeRoomCountControlWithSelector:selector
                                                          inController:self
                                                                 y_pos:screenHeight*0.28+20
                                                               counterTag:TAG_BED_COUNT_VIEW
                                                                decTag:TAG_BTN_BED_LEFT
                                                                incTag:TAG_BTN_BED_RIGHT]];
  
    [self.view addSubview:[DisplayFx themeContentText:@"# of bathrooms" y_pos:screenHeight*.40 + 20]];
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"(including half bathrooms)"
                                                      y_pos:screenHeight*.43 + 20
                                                   pctWidth:0.7]];
        
    [self.view addSubview:[DisplayFx themeRoomCountControlWithSelector:selector
                                                          inController:self
                                                                 y_pos:screenHeight*0.48+20
                                                            counterTag:TAG_BATH_COUNT_VIEW
                                                                decTag:TAG_BTN_BATH_LEFT
                                                                incTag:TAG_BTN_BATH_RIGHT]];
    
    SEL infoSelector = @selector(clickedInfoButton:);
    [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"cleaning package"
                                                              y_pos:screenHeight*.65 + 20
                                                         withAction:infoSelector
                                                       inController:self]];
    
    SEL serviceSelector = @selector(clickedServiceLevel:);
    [self.view addSubview:[DisplayFx themeSelectorServiceLevelWithSelector:serviceSelector
                                                              inController:self
                                                                     y_pos:screenHeight*0.72+20
                                                                   viewTag:TAG_CLEANING_RATE]];

    SEL backSelector = @selector(clickPreviousButton:);
    previousButton = [DisplayFx bottomLeftBackButtonWithSelector:backSelector
                                   inController:self
                                backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BACKBTN_BG_COLOR]];
    [self.view addSubview:previousButton];
    
    SEL nextSelector = @selector(clickNextButton:);
    nextButton = [DisplayFx bottomRightButtonWithSelector:nextSelector
                                inController:self
                                  buttonText:@"NEXT"
                                   textColor:[UIColor whiteColor]
                             backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    [self.view addSubview:nextButton];
    
}

- (void)clickedRoomSelector:(UIButton *)sender
{
    NSLog(@"clickedRoomSelector");
    [Util PlayClickSound];
    int bedCount = (int) [bedCounter.text integerValue];
    int bathCount = (int) [bathCounter.text integerValue];
    
    switch (sender.tag) {
        case TAG_BTN_BED_LEFT:
            if (bedCount > 0) {
                --bedCount;
                [bedCounter setText:[NSString stringWithFormat:@"%d", bedCount]];
            }
            break;
        case TAG_BTN_BED_RIGHT:
            if (bedCount < 10) {
                ++bedCount;
                [bedCounter setText:[NSString stringWithFormat:@"%d", bedCount]];
            }
            break;
        case TAG_BTN_BATH_LEFT:
            if (bathCount > 0) {
                --bathCount;
                [bathCounter setText:[NSString stringWithFormat:@"%d", bathCount]];
            }
            break;
        case TAG_BTN_BATH_RIGHT:
            if (bathCount < 10) {
                ++bathCount;
                [bathCounter setText:[NSString stringWithFormat:@"%d", bathCount]];
            }
            break;
        default:
            break; 
    }
    
    order.bedroomCount = bedCount;
    order.bathroomCount = bathCount;
}

- (void)clickedServiceLevel:(UISegmentedControl *)sender
{
    NSLog(@"clickedServiceLevel");

    switch ([sender selectedSegmentIndex]) {
        case 0:
            order.cleaningRate = CLEANING_RATE_BASIC;
            break;
        case 1:
            order.cleaningRate = CLEANING_RATE_PREMIUM;
            break;
        default:
            NSLog(@"No option for: %d", (int)[sender selectedSegmentIndex]);
    }
}

-(void)clickedInfoButton:(UIView*)sender
{
    NSLog(@"clickedInfoButton");
    CleaningInfoViewController *civc = [[CleaningInfoViewController alloc] init];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = civc;
    UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:civc];
    [self presentViewController:navViewHolder animated:YES completion:nil];
}

- (void)clickNextButton:(UIButton *)sender
{
    NSLog(@"clickNextButton");

    if (!requestingQuote) {
        requestingQuote = YES;
        [self getQuoteFromServer];
    }
    
    
    //QuoteViewController *qvc = [[QuoteViewController alloc] init];
    //[self.navigationController pushViewController:qvc animated:YES];
}

- (void)clickPreviousButton:(UIButton *)sender
{
    NSLog(@"clickPreviousButton");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickMenuButton:(id)sender
{
    NSLog(@"clickMenuButton");
}


-(void)updateCleaningView
{
    [bedCounter setText:[NSString stringWithFormat:@"%ld", (long)order.bedroomCount]];
    [bathCounter setText:[NSString stringWithFormat:@"%ld", (long)order.bathroomCount]];
    if (order.cleaningRate == CLEANING_RATE_BASIC) {
        cleaningOption.selectedSegmentIndex = 0;
    } else {
        cleaningOption.selectedSegmentIndex = 1;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCleaningView];
}

#pragma mark AFNetworking Methods

- (void)getQuoteFromServer
{
    
    NSString *requestString = [NSString stringWithFormat:
                               @"http://sweepd.com/api/index.php?request=getrate&roomcount=%d&bathcount=%d&cleanrate=%d&appointment=%@&coupon=%@&zipcode=%@&address1=%@&address2=%@&addressnote=%@",
                               (int) order.bedroomCount,
                               (int) order.bathroomCount,
                               (int) order.cleaningRate,
                               [order getScheduleAsServerString],
                               order.couponCode,
                               order.addressZip,
                               order.addressStreet1,
                               order.addressStreet2,
                               order.addressNote];
    requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"requesting: %@", requestString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"return JSON: %@", res);
        
        int resultCode = [[res valueForKey:WS_RETURNCODE_KEY] intValue];
        
        if (resultCode == WS_SUCCESS) {
            NSLog(@"success");
            [order setCostQuote: [[res valueForKey:@"costquote"] floatValue]];
            [order setTimeQuote: [[res valueForKey:@"timequote"] floatValue]];
            [order setCouponDiscount:[[res valueForKey:@"coupondiscount"] floatValue]];
            [order setQuoteId:[res valueForKey:@"quoteID"]];
            QuoteViewController *qvc = [[QuoteViewController alloc] init];
            [self.view hideToastActivity];
            [self.navigationController pushViewController:qvc animated:YES];
        } else {
            NSLog(@"failed");
            NSString *errorDescription = [res valueForKey:WS_ERRORDESCRIPTION_KEY];
            [self.view hideToastActivity];
            [self.view makeToast:errorDescription];
        }
        requestingQuote = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        [self.view makeToast:@"Sorry, we could not process this request"];
        NSLog(@"%@", error);
        requestingQuote = NO;
    }];
    
    [self.view makeToastActivity];
    [operation start];
    
};

@end
