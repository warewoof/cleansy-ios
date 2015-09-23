#import "CouponEntryViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "OrderManager.h"
#import "UIView+Toast.h"
#import "Util.h"
#import "AFNetworking.h"

#define TAG_CNAME 100
#define TAG_CEMAIL 101
#define TAG_CPHONE 102


@interface CouponEntryViewController ()

@end

@implementation CouponEntryViewController
{
    UIButton* exitButton;
    UITextField *couponTextField;
    CGFloat screenHeight, screenWidth;
    OrderManager *order;
    CGFloat keyboardHeight;
    NSMutableData *responseData;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    NSLog(@"CouponEntryViewController loadView");
    
    order = [OrderManager sharedManager];
    
    // NavigationBar Settings //
    [self.navigationItem setTitle:@"Enter Coupon"];
    [self.navigationController.navigationBar setBarTintColor:[Util colorWithHexString:TITLE_BAR_BG_COLOR_MODAL]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: [Util colorWithHexString:TITLE_BAR_TEXT_COLOR_MODAL],
                                                                       NSFontAttributeName: [UIFont fontWithName:@"ArialMT" size:20.0f]
                                                                       }];
    
    UIImage *exitImage = [UIImage imageNamed:@"exit-512.png"];
    exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setBounds:CGRectMake( 0, 0, 25, 25 )];
    [exitButton setImage:exitImage forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(clickedExit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *exitNavButton = [[UIBarButtonItem alloc] initWithCustomView:exitButton];
    [self.navigationItem setLeftBarButtonItem:exitNavButton];
    
    
    // UIViewController Settings //
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    contentView.showsVerticalScrollIndicator=NO;
    contentView.scrollEnabled=YES;
    contentView.userInteractionEnabled=YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [contentView addGestureRecognizer:swipe];
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [contentView addGestureRecognizer:swipe];
    contentView.backgroundColor = [Util colorWithHexString:SCREEN_BG_COLOR];
    [contentView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    self.view = contentView;
    self.automaticallyAdjustsScrollViewInsets = NO; // for scrollview
    
    keyboardHeight = 216;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    NSLog(@"screenHeight:%f, screenWidth:%f", screenHeight, screenWidth);
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patternbackground"]];
    [bgImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight+20)];
    [self.view addSubview:bgImageView];
    
    SEL selector = @selector(clickedProceed:);
    UIButton *bottomButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                                          inController:self
                                                            buttonText:@"Apply"
                                                             textColor:[UIColor whiteColor]
                                                       backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    [self.view addSubview:bottomButton];
    
    couponTextField = [DisplayFx textFieldWithHint:@"Coupon code" y_pos:screenHeight*.35];
    couponTextField.delegate = self;
    couponTextField.tag = TAG_CNAME;
    UIFont *font = [UIFont fontWithName: @"Arial-ItalicMT" size: 20];
    [couponTextField setFont:font];
    if ([order.couponCode length] != 0) {
        [couponTextField setText:order.couponCode];
    }
    [self.view addSubview:couponTextField];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"coupon usage description text goes here"
                                                      y_pos:screenHeight*0.48
                                                   pctWidth:0.78]];
    
    [self.view addSubview:[DisplayFx debugMessageText:@"To test - enter a number (ex. 20) for straight dollar discount, or a decimal for percentage (ex. 0.2 is 20% discount)"
                                                      y_pos:screenHeight*0.6
                                                   pctWidth:0.78]];
    
}

-(void) clickedExit:(UIButton *)sender
{
    NSLog(@"clickedExit");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) clickedProceed:(UIButton *)sender
{
    NSLog(@"clickedProceed");
    
   [self getCouponQuoteFromServer];

/*    if ([couponTextField.text length] != 0) {
        
        [self getCouponQuoteFromServer];

    } else {
        [self.view makeToast:@"Please enter a coupon to apply"];
    }*/
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        if ([couponTextField isFirstResponder]) {
            [(UIScrollView*)self.view setContentOffset:CGPointMake(0, keyboardHeight) animated:YES];
        }
        
    }
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    keyboardHeight = keyboardFrame.size.height;
}

-(void)dismissKeyboard {
    [couponTextField resignFirstResponder];
    [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark TextFieldHandlers

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y > screenHeight*0.5) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, keyboardHeight) animated:YES];
    }
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        textField.returnKeyType = UIReturnKeyNext;
    } else {
        textField.returnKeyType = UIReturnKeyDone;
    }
    
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.frame.origin.y > screenHeight*0.5) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark AFNetworking Methods

- (void)getCouponQuoteFromServer
{
    NSString *requestString = [NSString stringWithFormat:
                               @"http://sweepd.com/api/index.php?request=getrate&roomcount=%d&bathcount=%d&cleanrate=%d&appointment=%@&coupon=%@&zipcode=%@&address1=%@&address2=%@&addressnote=%@",
                               (int) order.bedroomCount,
                               (int) order.bathroomCount,
                               (int) order.cleaningRate,
                               [order getScheduleAsServerString],
                               [Util trimString:couponTextField.text],
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
            [order setTimeEstimate: [[res valueForKey:@"timequote"] floatValue]];
            [order setCouponDiscount:[[res valueForKey:@"coupondiscount"] floatValue]];
            [order setCouponCode:[Util trimString:couponTextField.text]];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.view hideToastActivity];
        } else {
            NSLog(@"failed");
            NSString *errorDescription = [res valueForKey:WS_ERRORDESCRIPTION_KEY];
            [self.view hideToastActivity];
            [self.view makeToast:errorDescription];
        }       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /*
        [self.view hideToastActivity];
        [self.view makeToast:@"Sorry, coupon code not found"];
         */
        NSLog(@"success");
        [order setCostQuote: 100.0];
        [order setTimeEstimate: 2.0];
        [order setCouponDiscount:20.0];
        [order setCouponCode:[Util trimString:couponTextField.text]];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view hideToastActivity];
    }];
    [self.view makeToastActivity];
    [operation start];
    
};

@end
