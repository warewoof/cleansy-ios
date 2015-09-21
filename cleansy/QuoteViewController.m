#import "QuoteViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "SWRevealViewController.h"
#import "ReceiptViewController.h"
#import "AppDelegate.h"
#import "ContactInfoViewController.h"
#import "OrderManager.h"
#import "UIView+Toast.h"
#import "CouponEntryViewController.h"
#import "UICountingLabel.h"
#import "Util.h"
#import "AFNetworking.h"

// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface QuoteViewController ()

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation QuoteViewController
{
    UIButton *menuButton;
    UIButton *contactButton;
    UIButton *scheduleButton;
    UIButton *nextButton;
    UIButton *previousButton;
    CGFloat screenHeight, screenWidth;
    OrderManager *order;
    UIButton *couponButton;
    UICountingLabel *quoteLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"QuoteViewController viewDidLoad");
    SWRevealViewController *revealController = self.revealViewController;
    //[self.navigationController.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentQuoteView = self;
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // self.successView.hidden = YES;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
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
    
    [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"price"
                                                              y_pos:screenHeight*.15 + 20
                                                         withAction:nil
                                                       inController:nil]];

    CGFloat fontSize = 60.0f;
    UIFont *font = [UIFont fontWithName: @"Arial-ItalicMT" size: fontSize];
    CGSize expectedDollarLabelSize = [@"$" sizeWithAttributes:@{NSFontAttributeName: font}];
    UILabel *dollarSignLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth*0.15,
                                                                        screenHeight*0.2+20,
                                                                        expectedDollarLabelSize.width,
                                                                        expectedDollarLabelSize.height)];
    [dollarSignLabel setText:@"$"];
    [dollarSignLabel setTextAlignment:NSTextAlignmentCenter];
    [dollarSignLabel setTextColor:[Util colorWithHexString:LABEL_TEXT_COLOR]];
    [dollarSignLabel setFont:font];
    [self.view addSubview:dollarSignLabel];
    
    CGSize expectedLabelSize = [[NSString stringWithFormat:@"%d", (int)[order getQuote]] sizeWithAttributes:@{NSFontAttributeName: font}];
    quoteLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(screenWidth*0.15 + expectedDollarLabelSize.width,
                                                                   screenHeight*0.2+20,
                                                                   screenWidth*0.7,
                                                                   expectedLabelSize.height)];
    [quoteLabel setText:[NSString stringWithFormat:@"%d", (int)[order getQuote]]];
    [quoteLabel setFont:font];
    [quoteLabel setTextAlignment:NSTextAlignmentLeft];
    quoteLabel.format = @"%d";
    quoteLabel.method = UILabelCountingMethodEaseInOut;
    [self.view addSubview:quoteLabel];
    [quoteLabel setTextColor:[Util colorWithHexString:LABEL_TEXT_COLOR]];
    
    NSString *timeQuotation = [NSString stringWithFormat:@"estimated time will be %@ hour(s)", [order getTimeQuoteString]];
    [self.view addSubview:[DisplayFx themeContentTextItalic:timeQuotation
                                                      y_pos:screenHeight*.36 + 20
                                                   pctWidth:0.7]];
    
    SEL couponSelector = @selector(clickCouponButton:);
    couponButton = [DisplayFx couponButtonDisplayText:@"Use a coupon"
                                                y_pos:screenHeight*0.42+20
                                             selector:couponSelector
                                         inController:self];
    [self updateCouponButton];
    [self.view addSubview:couponButton];
    
    
    [self.view addSubview:[DisplayFx themeSectionLabelWithHighlight:@"contact information"
                                                              y_pos:screenHeight*.58 + 20
                                                         withAction:nil
                                                       inController:nil]];
    
    SEL contactSelector = @selector(clickContactButton:);
    contactButton = [DisplayFx themeButtonDisplayText:@"Enter contact information"
                                                 y_pos:screenHeight*.65 + 20
                                              widthPct:0.7
                                              selector:contactSelector
                                          inController:self];
    [self.view addSubview:contactButton];
    
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

- (void)clickContactButton:(UIButton *)sender
{
    NSLog(@"clickRegisterButton");
    ContactInfoViewController *civc = [[ContactInfoViewController alloc] init];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = civc;
    UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:civc];
    [self presentViewController:navViewHolder animated:YES completion:nil];
}

- (void)clickNextButton:(UIButton *)sender
{
    NSLog(@"clickNextButton");
    
    if (![order isContactSet]) {
        [self.view makeToast:@"Please enter contact information"];
        return;
    }
    
    //order.finalPaymentDisplayed = [NSString stringWithFormat:@"$%d", (int)[order getQuote]];
    order.finalPaymentDisplayed = [quoteLabel text];
    
    if (([order getQuote] - [order getCouponDiscount]) <= 0) {
        [self transactionSuccess];
        return;
    }
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@ hour(s) %@ cleaning", [order getTimeQuoteString], [order getCleanDescriptionString]]
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:[Util floatToPriceString:
                                                                                           ([order getQuote] - [order getCouponDiscount])]]
                                    withCurrency:@"USD"
                                         withSku:@"B90"];
    PayPalItem *item2 = [PayPalItem itemWithName:@"Cleaning products"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"CLN-MAT"];

    NSArray *items = @[item1, item2];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = [NSString stringWithFormat:@"%@ hour(s) %@ cleaning", [order getTimeQuoteString], [order getCleanDescriptionString]];
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = YES;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];

    
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = paymentViewController;


    [self presentViewController:paymentViewController animated:YES completion:nil];
}

-(void)dismissPaypalView
{
    NSLog(@"dismissPaypalView");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickPreviousButton:(UIButton *)sender
{
    NSLog(@"clickPreviousButton");
    [self.navigationController popViewControllerAnimated:YES];
}
/*
- (void)clickMenuButton:(id)sender
{
    NSLog(@"clickMenuButton");
}
 */

- (void)clickCouponButton:(id)sender
{
    NSLog(@"clickCouponButton");
    CouponEntryViewController *cevc = [[CouponEntryViewController alloc] init];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = cevc;
    UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:cevc];
    [self presentViewController:navViewHolder animated:YES completion:nil];
}

-(void)updateContactButton
{
    [contactButton removeFromSuperview];
    
    NSString *displayContactText = @"Enter contact information";
    if ([order isContactSet])
    {
        displayContactText = [order.customerName stringByAppendingString:@"\n"];
        displayContactText = [[displayContactText stringByAppendingString:order.customerEmail] stringByAppendingString:@"\n"];
        displayContactText = [displayContactText stringByAppendingString:order.customerPhone];
    }
    SEL selector = @selector(clickContactButton:);
    contactButton = [DisplayFx themeButtonDisplayText:displayContactText
                                                y_pos:screenHeight*.65 + 20
                                              widthPct:0.7
                                             selector:selector
                                         inController:self];
 
    [self.view addSubview:contactButton];
}

-(void)updateCouponButton
{
    if ([order getCouponDiscount] > 0) {
        NSString *couponSavedText = [Util floatToPriceString:[order getCouponDiscount]];
        [couponButton setTitle:[NSString stringWithFormat:@"Coupon saves $%@!", couponSavedText] forState:UIControlStateNormal];
    } else {
        [couponButton setTitle:@"Use a coupon" forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateContactButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    if ([order getCouponDiscount] > 0) {
        if ([quoteLabel.text floatValue] != ([order getQuote] - [order getCouponDiscount])) {
            [quoteLabel countFrom:[order getQuote] to:([order getQuote] - [order getCouponDiscount]) withDuration:1.0f];
            [self performSelector:@selector(updateCouponButton) withObject:nil afterDelay:1.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    } else {
        [quoteLabel countFrom:[order getQuote] to:([order getQuote] - [order getCouponDiscount]) withDuration:0.5f];
        [self updateCouponButton];
    }
}



#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Manually Canceled");
    self.resultText = nil;
    [self transactionFail];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {

    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);

    NSString *confirmationCode = [[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"];
    
    NSLog(@"Confirmation Code: %@", confirmationCode);
    
    [self sendPaymentConfirmationCode:confirmationCode];
    
}

#pragma mark AFNetworking Methods

- (void)sendPaymentConfirmationCode:(NSString*)confirmationCode
{

    
    NSString *requestString = [NSString stringWithFormat:
                               @"http://sweepd.com/api/index.php?request=storeorder&email=%@&name=%@&phone=%@&quoteid=%@&paypalconfirmation=%@",
                               order.customerEmail,
                               order.customerName,
                               order.customerPhone,
                               order.quoteId,
                               confirmationCode];
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
            order.confirmationCode = [res valueForKey:@"confirmationcode"];
        } else {
            NSLog(@"failed");
            NSString *errorDescription = [res valueForKey:WS_ERRORDESCRIPTION_KEY];
            [self.view makeToast:errorDescription]; // "we cannot provide confirmation at this time even though payment succeeded"
            order.confirmationCode = @"N/A";
        }
        [self transactionSuccess];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"Sorry, we could not process this request"];
    }];
    
    [operation start];
    
};

#pragma mark - Helpers

- (void)transactionSuccess {
    NSLog(@"transactionSuccess");
    
    ReceiptViewController *rvc = [[ReceiptViewController alloc] init];
    rvc.street1 = order.addressStreet1;
    rvc.street2 = order.addressStreet2;
    rvc.city = order.addressCity;
    rvc.state = order.addressState;
    rvc.zipcode = order.addressZip;
    rvc.bedroomCount = order.bedroomCount;
    rvc.bathroomCount = order.bathroomCount;
    rvc.cleanDate = [NSString stringWithFormat:@"%@ %@", [order getScheduleDateAsString], [order getScheduleTimeAsString]];
    rvc.orderDate = [order getTransactionTimeAsString];
    rvc.notes = order.addressNote;
    rvc.phone = order.customerPhone;
    rvc.price = order.finalPaymentDisplayed;
    rvc.confirmationCode = order.confirmationCode;
    if ([order getCouponDiscount] > 0) {
        rvc.priceDiscounted = YES;
    }
    rvc.presentedAsHistory = NO;
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)transactionFail {
    NSLog(@"transactionFail");
}

@end