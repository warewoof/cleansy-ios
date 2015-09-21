#import "ReceiptViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "SWRevealViewController.h"
#import "SocialViewController.h"
#import "OrderManager.h"
#import "Util.h"
#import "HistoryManager.h"

@interface ReceiptViewController ()

@end

@implementation ReceiptViewController
{
    UIButton *menuButton;
    UIButton *addressButton;
    UIButton *scheduleButton;
    UIButton *nextButton;
    CGFloat screenHeight, screenWidth;
    OrderManager *order;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ReceiptViewController viewDidLoad");
    if (!_presentedAsHistory ) {
        SWRevealViewController *revealController = self.revealViewController;
        //[self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)loadView
{
    NSLog(@"ReceiptViewController loadView");
    

    
    self.view = [[UIView alloc] init];
    
    // UIViewController Settings //
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [Util colorWithHexString:@"ffffff"];
    [contentView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    //[contentView addGestureRecognizer:revealController.panGestureRecognizer];
    
    self.view = contentView;
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    NSLog(@"screenHeight:%f, screenWidth:%f", screenHeight, screenWidth);
    
    
    
    if (!_presentedAsHistory ) {
        
        order = [OrderManager sharedManager];
        order.transactionEnd = [NSDate date];
        //[HistoryManager addHistoryItem:order];
        [order loadData];
        
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
        
        SEL selector = @selector(clickNextButton:);
        nextButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                                  inController:self
                                                    buttonText:@"SHARE"
                                                     textColor:[UIColor whiteColor]
                                               backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
        [self.view addSubview:nextButton];
    } else {
        self.navigationItem.title = _orderDate;
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
    
    [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"Thank you"
                                                              y_pos:screenHeight*.15 + 20
                                                         withAction:nil
                                                       inController:nil]];
    if (_presentedAsHistory) {
        
        
        [self.view addSubview:[DisplayFx themeHistoryText:@"Payment has been received, and a receipt has been emailed to you.  We appreciate your business."
                                                    y_pos:screenHeight*0.25]];
        
        [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"Order details"
                                                                  y_pos:screenHeight*0.4
                                                             withAction:nil
                                                           inController:nil]];
        
        
        
        int lineGap = 17;
        int lineCounter = 0;
        CGFloat detailStartY = 0.45;
        
        detailStartY = detailStartY +0.02;
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"Scheduled for: %@", _cleanDate]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"%s cleaning for %ld Bedroom, %ld Bathroom",
                                                                 _cleanRate == CLEANING_RATE_BASIC ? "Basic" : "Premium",
                                                                 (long)_bedroomCount,
                                                                 (long)_bathroomCount]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        detailStartY = detailStartY + 0.02;
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"%@%@",
                                                                 _street1,
                                                                 [_street2 length] == 0 ? @"" : [NSString stringWithFormat:@", %@", _street2]]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"%@, %@ %@",
                                                                 _city,
                                                                 _state,
                                                                 _zipcode]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:_phone
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        if ([_notes length] != 0) {
            [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"Note: %@", _notes]
                                                              y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                           pctWidth:0.8]];
        }
        
        detailStartY = detailStartY + 0.02;
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"Order placed: %@", _orderDate]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"Price paid: %@ %@",
                                                                 _price,
                                                                 _priceDiscounted ? @"(with discount applied)" : @""]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];

        [self.view addSubview:[DisplayFx themeHistoryText:[NSString stringWithFormat:@"This order number is:  %@", _confirmationCode]
                                                    y_pos:screenHeight*detailStartY+lineGap*++lineCounter]];
        
    } else {
        [self.view addSubview:[DisplayFx themeHistoryText:@"Payment has been received, and a receipt has been emailed to you.  We appreciate your business."
                                                    y_pos:screenHeight*0.25]];
        
        [self.view addSubview:[DisplayFx themeHistoryText:@"Our cleaners will call to reconfirm prior to their arrival. For any issues or questions please call us at 800-555-2828."
                                                    y_pos:screenHeight*0.38]];
        
        [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"Order details"
                                                                  y_pos:screenHeight*0.53
                                                             withAction:nil
                                                           inController:nil]];
        
        int lineGap = 17;
        int lineCounter = 0;
        CGFloat detailStartY = 0.58;
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"Scheduled for: %@", _cleanDate]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"%s cleaning for %ld Bedroom, %ld Bathroom",
                                                                 _cleanRate == CLEANING_RATE_BASIC ? "Basic" : "Premium",
                                                                 (long)_bedroomCount,
                                                                 (long)_bathroomCount]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        detailStartY = detailStartY + 0.02;
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"%@%@",
                                                                 _street1,
                                                                 [_street2 length] == 0 ? @"" : [NSString stringWithFormat:@", %@", _street2]]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"%@, %@ %@",
                                                                 _city,
                                                                 _state,
                                                                 _zipcode]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:_phone
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        detailStartY = detailStartY + 0.02;
        
        [self.view addSubview:[DisplayFx themeContentTextItalic:[NSString stringWithFormat:@"Price paid: $%@ %@",
                                                                 _price,
                                                                 _priceDiscounted ? @"with discount applied" : @""]
                                                          y_pos:screenHeight*detailStartY+lineGap*lineCounter++
                                                       pctWidth:0.8]];
        
        
        [self.view addSubview:[DisplayFx themeHistoryText:[NSString stringWithFormat:@"Order confirmation number is: %@", _confirmationCode]
                                                    y_pos:screenHeight*detailStartY+lineGap*++lineCounter]];
    }
    
    
}

-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    
}

- (void)clickAddressButton:(UIButton *)sender
{
    NSLog(@"clickAddressButton");
}

- (void)clickScheduleButton:(UIButton *)sender
{
    NSLog(@"clickScheduleButton");
}

- (void)clickNextButton:(UIButton *)sender
{
    NSLog(@"clickNextButton");
    
    SocialViewController *svc = [[SocialViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
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

-(void)clickedExit
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
