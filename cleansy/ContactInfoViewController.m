#import "ContactInfoViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "OrderManager.h"
#import "Util.h"
#import "UIView+Toast.h"


#define TAG_CNAME 100
#define TAG_CEMAIL 101
#define TAG_CPHONE 102


@interface ContactInfoViewController ()

@end

@implementation ContactInfoViewController
{
    UIButton* exitButton;
    UITextField *cnameText;
    UITextField *cemailText;
    UITextField *cphoneText;
    CGFloat screenHeight, screenWidth;
    OrderManager *order;
    CGFloat keyboardHeight;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    NSLog(@"ContactInfoViewController loadView");
    
    order = [OrderManager sharedManager];
    
    // NavigationBar Settings //
    [self.navigationItem setTitle:@"Contact"];
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
    /*
     CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
     UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
     contentView.backgroundColor = [DisplayFx colorWithHexString:TITLE_BAR_BG_COLOR];
     [contentView setUserInteractionEnabled:YES];
     [self.navigationController.navigationBar setUserInteractionEnabled:YES];
     self.view = contentView;
     */
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    NSLog(@"screenHeight:%f, screenWidth:%f", screenHeight, screenWidth);
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patternbackground"]];
    [bgImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight+20)];
    [self.view addSubview:bgImageView];
    
    SEL selector = @selector(clickedProceed:);
    UIButton *bottomButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                                          inController:self
                                                            buttonText:@"Submit"
                                                             textColor:[UIColor whiteColor]
                                                       backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    
    [self.view addSubview:bottomButton];
    
    cnameText = [DisplayFx textFieldWithHint:@"Name" y_pos:screenHeight*.2];
    cnameText.delegate = self;
    cnameText.tag = TAG_CNAME;
    if (order.customerName) {
        cnameText.text = order.customerName;
    }
    [self.view addSubview:cnameText];
    
    cemailText = [DisplayFx textFieldWithHint:@"Email" y_pos:screenHeight*.3];
    cemailText.delegate = self;
    cemailText.tag = TAG_CEMAIL;
    if (order.customerEmail) {
        cemailText.text = order.customerEmail;
    }
    [self.view addSubview:cemailText];
    
    cphoneText = [DisplayFx textFieldWithHint:@"Phone" y_pos:screenHeight*.4];
    cphoneText.delegate = self;
    cphoneText.tag = TAG_CPHONE;
    if (order.customerPhone) {
        cphoneText.text = order.customerPhone;
    }
    //[cphoneText addTarget:self action:@selector(reformatPhoneField) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:cphoneText];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"order receipt and booking details will be emaild, and we will call to confirm cleaning prior to our arrival"
                                                      y_pos:screenHeight*0.55
                                                   pctWidth:0.8]];
}

-(void) clickedExit:(UIButton *)sender
{
    NSLog(@"clickedExit");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) clickedProceed:(UIButton *)sender
{
    NSLog(@"clickedProceed");
    [self reformatPhoneField];
    
    if ([[Util trimString:cnameText.text] length] == 0) {
        [self.view makeToast:@"Please tell us your name"];
        return;
    };
    if (![Util NSStringIsValidEmail:[Util trimString:cemailText.text]]) {
        [self.view makeToast:@"Please enter a valid email address"];
        return;
    }
    
    
    if (![Util NSStringIsValidPhone:[Util trimString:cphoneText.text]]) {
        [self.view makeToast:@"Please enter a valid 10-digit phone number"];
        return;
    }
    
    order.customerName = [Util trimString:cnameText.text];
    order.customerEmail = [Util trimString:cemailText.text];
    order.customerPhone = [Util trimString:cphoneText.text];

    [order saveData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    //NSLog(@"handleSwipe called");
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        if ([cnameText isFirstResponder] || [cphoneText isFirstResponder] ||
            [cemailText isFirstResponder]) {
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
    [cnameText resignFirstResponder];
    [cemailText resignFirstResponder];
    [cphoneText resignFirstResponder];
    [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark TextFieldHandlers

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
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
    
    if (textField.tag == TAG_CEMAIL) {
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    
    if (textField.tag == TAG_CPHONE) {
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [self reformatPhoneField];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.frame.origin.y > screenHeight*0.5) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if (textField.tag == TAG_CPHONE) {
        [self reformatPhoneField];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"shouldChangeCharactersInRange");
    
    if ([string isEqualToString:@""]) return YES;
    
    if (textField.tag == TAG_CPHONE) {
        NSInteger spacerChars = ([[textField.text componentsSeparatedByString:@"-"] count] - 1) * -1;
        if ([textField.text length] + spacerChars >= 10) {
            return NO;
        }
        unichar c = [string characterAtIndex:0];
        if (([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c]))  {
            
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (void)reformatPhoneField
{
    NSMutableString *enterredText = [[NSMutableString alloc] initWithString:[cphoneText.text stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    if ([enterredText length] >= 7) {
        [enterredText insertString:@"-" atIndex:6];
        [enterredText insertString:@"-" atIndex:3];
    } else if ([enterredText length] >= 4) {
        [enterredText insertString:@"-" atIndex:3];
    }
    cphoneText.text = enterredText;
}

@end
