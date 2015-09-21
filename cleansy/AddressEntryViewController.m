#import "AddressEntryViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "OrderManager.h"
#import "Util.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"

#define TAG_AD1 100
#define TAG_AD2 101
#define TAG_ZIP 102
#define TAG_NOT 103

@interface AddressEntryViewController ()

@end

@implementation AddressEntryViewController
{
    UIButton *exitButton;
    UITextField *aStreetText;
    UITextField *aStreet2Text;
    UITextField *aZipText;
    UITextField *aNotesText;
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
    NSLog(@"AppointmentViewController loadView");
    
    order = [OrderManager sharedManager];
    
    // NavigationBar Settings //
    [self.navigationItem setTitle:@"Enter Address"];
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
    //contentView.backgroundColor = [Util colorWithHexString:SCREEN_BG_COLOR];
    contentView.backgroundColor = [UIColor whiteColor];
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
    
    /*
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patternbackground"]];
    [bgImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight+20)];
    [self.view addSubview:bgImageView];
     */
    
    SEL selector = @selector(clickedProceed:);
    UIButton *bottomButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                                          inController:self
                                                            buttonText:@"Submit"
                                                             textColor:[UIColor whiteColor]
                                                       backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    
    [self.view addSubview:bottomButton];
    
    aStreetText = [DisplayFx textFieldWithHint:@"Street Address" y_pos:screenHeight*.2];
    aStreetText.delegate = self;
    aStreetText.tag = TAG_AD1;
    if (order.addressStreet1) {
        aStreetText.text = order.addressStreet1;
    }
    [self.view addSubview:aStreetText];
    
    aStreet2Text = [DisplayFx textFieldWithHint:@"Building#/Apt#/Unit#" y_pos:screenHeight*.3];
    aStreet2Text.delegate = self;
    aStreet2Text.tag = TAG_AD2;
    if (order.addressStreet2) {
        aStreet2Text.text = order.addressStreet2;
    }
    [self.view addSubview:aStreet2Text];
    
    aZipText = [DisplayFx textFieldWithHint:@"Zip Code" y_pos:screenHeight*.4];
    aZipText.delegate = self;
    aZipText.tag = TAG_ZIP;
    if (order.addressZip) {
        aZipText.text = order.addressZip;
    }
    [self.view addSubview:aZipText];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"any additional notes such as gate information, key location (if no one is home), presence of large pets, problem areas, etc."
                                                      y_pos:screenHeight*0.55
                                                   pctWidth:0.8]];
    
    aNotesText = [DisplayFx textFieldWithHint:@"Additional Notes" y_pos:screenHeight*.7];
    aNotesText.delegate = self;
    aNotesText.tag = TAG_NOT;
    if (order.addressNote) {
        aNotesText.text = order.addressNote;
    }
    [self.view addSubview:aNotesText];
}

-(void) clickedExit:(UIButton *)sender
{
    NSLog(@"clickedExit");
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) clickedProceed:(UIButton *)sender
{
    NSLog(@"clickedProceed");
    if ([[Util trimString:aStreetText.text] length] == 0) {
        [self.view makeToast:@"Please enter a valid address"];
        return;
    };
    if (![Util NSStringIsValidZipcode:[Util trimString:aZipText.text]]) {
        [self.view makeToast:@"Please enter a valid 5-digit zip code"];
        return;
    };
    
    order.addressStreet1 = [Util trimString:aStreetText.text];
    order.addressStreet2 = [Util trimString:aStreet2Text.text];
    order.addressNote =  [Util trimString:aNotesText.text];
    if (!(([[Util trimString:aZipText.text] isEqualToString:order.addressZip]) &&       // edit data does not match saved data, perform lookup
          ([order.addressCity length] != 0) &&
          ([order.addressState length] != 0))) {
        order.addressZip = [Util trimString:aZipText.text];
        order.addressCity = @"";
        order.addressState = @"";
        order.addressCountry = @"";
        responseData = [NSMutableData data];
        [self checkServiceCoverage:order.addressZip];
    } else {
        [order saveData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    //NSLog(@"handleSwipe called");
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        [(UIScrollView*)self.view setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        if (([aStreetText isFirstResponder] || [aStreet2Text isFirstResponder] ||
             [aZipText isFirstResponder] || [aNotesText isFirstResponder])) {
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
    [aStreetText resignFirstResponder];
    [aStreet2Text resignFirstResponder];
    [aZipText resignFirstResponder];
    [aNotesText resignFirstResponder];
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
    
    if ((textField.tag == TAG_AD1) || (textField.tag == TAG_AD2)) {
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    }
        
    if (textField.tag == TAG_ZIP) {
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }
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

- (void)checkServiceCoverage:(NSString*)zipcode
{
    //NSString *requestString = [NSString stringWithFormat:@"http://sweepd.com/api/index.php?request=verifyservicezip&zipcode=%@", zipcode];
    NSString *requestString = [NSString stringWithFormat:@"http://sweepd.com/servicesapp/api/Order/1"];
    
    requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"requesting: %@", requestString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success: %@", operation.responseString);
        
        //RXMLElement *rootXML = [RXMLElement elementFromXMLString:operation.responseString encoding:NSUTF8StringEncoding];
        
        
        //NSLog(@"success+1: %@",[rootXML child:@"ID"].text);
        //NSLog(@"success+2: %@",[rootXML attribute:@"Zip"]);
        
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"success+3: %@",[res valueForKey:@"Appointment"]);
        NSLog(@"success+4: %@",[res valueForKey:@"ZipCode"]);
        
        int resultCode = [[res valueForKey:WS_RETURNCODE_KEY] intValue];
        
        if (resultCode == WS_SUCCESS) {
            NSLog(@"success");
            order.addressCity = [res valueForKey:@"city"];
            order.addressState = [res valueForKey:@"state"];
            order.addressCountry = [res valueForKey:@"country"];
            [order saveData];
            [self.view hideToastActivity];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"failed");
            NSString *errorDescription = [res valueForKey:WS_ERRORDESCRIPTION_KEY];
            [self.view hideToastActivity];
            [self.view makeToast:errorDescription];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        [self.view makeToast:@"Sorry, we could not find this zip code"];
    }];
    
    [self.view makeToastActivity];
    [operation start];
    
};

@end
