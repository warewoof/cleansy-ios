#import "ScheduleSelectViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "OrderManager.h"
#import "Util.h"
#import "UIView+Toast.h"

@interface ScheduleSelectViewController ()

@end

@implementation ScheduleSelectViewController

@synthesize exitButton;
CGFloat screenHeight, screenWidth;
UIDatePicker *datePicker;
OrderManager *order;

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
    [self.navigationItem setTitle:@"Schedule"];
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
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [Util colorWithHexString:SCREEN_BG_COLOR];
    [contentView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    self.view = contentView;
    
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
    
    CGRect pickerFrame = CGRectMake(0,screenHeight*0.2, 0, 0);

    
    datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    datePicker.minuteInterval = 30;
    datePicker.minimumDate = [order getInitialDate];
    [datePicker addTarget:self action:@selector(updatedDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    if (order.isScheduleSet) {
        [datePicker setDate:order.scheduleDate];
    }
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"Cleanings can be booked as far as one month in advance.  We send email at early as 48 hours prior to our arrive. Our cleaners will contact you prior to their arrival."
                                                      y_pos:screenHeight*0.7
                                                   pctWidth:0.8]];
    [self setNextAvailableDate];
    
}

-(void) clickedExit:(UIButton *)sender
{
    NSLog(@"clickedExit");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) clickedProceed:(UIButton *)sender
{
    NSLog(@"clickedProceed");
    
    NSLog(@"value: %@",datePicker.date);
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:datePicker.date];
    NSInteger currentHour = [components hour];
    
    if (currentHour < 8 || currentHour > 18) {// || currentHour == 21 && (currentMinute > 0 || currentSecond > 0))) {
        NSLog(@"Reseting valid date");
        [self.view makeToast:@"Our cleaning hours are between 8AM and 6PM daily"];
        [self setNextAvailableDate];
        /*if (currentHour > 18) {
            [components setDay:([components day]+1)];
        }
        [components setHour:8];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [datePicker setDate:[calendar dateFromComponents:components]] ;
         */
        
    } else {
    
        order.scheduleDate = datePicker.date;
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (void)setNextAvailableDate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:datePicker.date];
    NSInteger currentHour = [components hour];
    
    if (currentHour < 8 || currentHour > 18) {// || currentHour == 21 && (currentMinute > 0 || currentSecond > 0))) {
        NSLog(@"Reseting valid date");
        if (currentHour > 18) {
            [components setDay:([components day]+1)];
        }
        [components setHour:8];
        
        //        [datePicker setDate:[order getInitialDate]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        [datePicker setDate:[calendar dateFromComponents:components]] ;
        
    }
}

- (void)updatedDate:(id)sender
{

}

/*
#pragma mark TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y > screenHeight*0.5) {
        [self animateTextField: textField up: YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.frame.origin.y > screenHeight*0.5) {
        [self animateTextField: textField up: NO];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
*/
@end
