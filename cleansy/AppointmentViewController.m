#import "AppointmentViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "SWRevealViewController.h"
#import "CleaningViewController.h"
#import "AddressEntryViewController.h"
#import "ScheduleSelectViewController.h"
#import "AppDelegate.h"
#import "OrderManager.h"
#import "UIView+Toast.h"
#import "Util.h"

#import "ContactInfoViewController.h"

@interface AppointmentViewController ()

@end

@implementation AppointmentViewController
{
    UIButton *menuButton, *addressButton, *scheduleButton, *nextButton;
    CGFloat screenHeight, screenWidth;
    OrderManager *order;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"AppointmentViewController viewDidLoad");
    SWRevealViewController *revealController = self.revealViewController;
    //[self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)loadView
{
    NSLog(@"AppointmentViewController loadView");
    
    order = [OrderManager sharedManager];
    [order loadData];
    
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
    
    [self.view  addSubview:[DisplayFx themeSectionLabelWithHighlight:@"Where would you like us to clean?"
                                                               y_pos:screenHeight*0.15+20
                                                          withAction:nil
                                                        inController:nil]];
    
    SEL addressSelector = @selector(clickAddressButton:);
    addressButton = [DisplayFx themeButtonDisplayText:@"" y_pos:screenHeight*0.25 selector:addressSelector inController:self];
    [self.view addSubview:addressButton];
    
    [self.view  addSubview:[DisplayFx themeSectionLabelWithHighlight:@"When would you like us to clean?"
                                                               y_pos:screenHeight*0.5+20
                                                          withAction:nil
                                                        inController:nil]];
    
    SEL scheduleSelector = @selector(clickScheduleButton:);
    scheduleButton = [DisplayFx themeButtonDisplayText:@"" y_pos:screenHeight*.60 selector:scheduleSelector inController:self];
    [self.view addSubview:scheduleButton];
    
    
    SEL selector = @selector(clickNextButton:);
    nextButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                              inController:self
                                                buttonText:@"NEXT"
                                                 textColor:[UIColor whiteColor]
                                           backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    [self.view addSubview:nextButton];
    
}



- (void)clickAddressButton:(UIButton *)sender
{
    NSLog(@"clickAddressButton");
    
    AddressEntryViewController *aevc = [[AddressEntryViewController alloc] init];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = aevc;
    UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:aevc];
    [self presentViewController:navViewHolder animated:YES completion:nil];
    
}

- (void)clickScheduleButton:(UIButton *)sender
{
    NSLog(@"clickScheduleButton");
    ScheduleSelectViewController *ssvc = [[ScheduleSelectViewController alloc] init];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = ssvc;
    UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:ssvc];
    [self presentViewController:navViewHolder animated:YES completion:nil];
}

- (void)clickNextButton:(UIButton *)sender
{
    
    NSLog(@"clickNextButton");
    /*
    ContactInfoViewController *civc = [[ContactInfoViewController alloc] init];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = civc;
    UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:civc];
    [self presentViewController:navViewHolder animated:YES completion:nil];
    */
    
    if (![order isAddressSet]) {
        [self.view makeToast:@"Please enter your address"];
        return;
    }
    if (![order isScheduleSet]) {
        [self.view makeToast:@"Please choose a cleaning time"];
        return;
    }
    CleaningViewController *cvc = [[CleaningViewController alloc] init];
    [self.navigationController pushViewController:cvc animated:YES];
     
}

- (void)clickMenuButton:(id)sender
{
    NSLog(@"clickMenuButton");
}

-(void)updateAddressButton
{
    
    [addressButton removeFromSuperview];
    
    NSString *displayAddressText = @"Enter your address";
    if ([order isAddressSet])
    {
        displayAddressText = [NSString stringWithFormat:@"%@\n", order.addressStreet1];
        if ([order.addressStreet2 length] != 0) {
            displayAddressText = [displayAddressText stringByAppendingString:[NSString stringWithFormat:@"%@\n", order.addressStreet2]];
        }
        if (([order.addressCity length] != 0) && ([order.addressState length] != 0)) {
            displayAddressText = [displayAddressText stringByAppendingString:
                                  [NSString stringWithFormat:@"%@, %@ ",
                                   order.addressCity,
                                   order.addressState]];
        }
        
        displayAddressText = [displayAddressText stringByAppendingString:order.addressZip];
        int maxNoteLength = 20;
        if ([order.addressNote length] != 0) {
            if ([order.addressNote length] <= maxNoteLength) {
                displayAddressText = [displayAddressText stringByAppendingString:[NSString stringWithFormat:@"\n%@",order.addressNote]];
            } else {
                NSString *displayNote = [order.addressNote substringToIndex:maxNoteLength];
                displayAddressText = [displayAddressText stringByAppendingString:[NSString stringWithFormat:@"\n%@...",displayNote]];
            }
            
        }
    }
    SEL addressSelector = @selector(clickAddressButton:);
    addressButton = [DisplayFx themeButtonDisplayText:displayAddressText
                                                y_pos:screenHeight*0.25
                                             selector:addressSelector
                                         inController:self];
    [self.view addSubview:addressButton];
}


-(void)updateScheduleButton
{
    [scheduleButton removeFromSuperview];
    
    NSString *displayText = @"Choose cleaning time";
    if ([order isScheduleSet]) {
        displayText = [order getScheduleAsString];
    }
    
    SEL scheduleSelector = @selector(clickScheduleButton:);
    scheduleButton = [DisplayFx themeButtonDisplayText:displayText
                                                 y_pos:screenHeight*.60
                                              selector:scheduleSelector
                                          inController:self];
    [self.view addSubview:scheduleButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateAddressButton];
    [self updateScheduleButton];
}

@end
