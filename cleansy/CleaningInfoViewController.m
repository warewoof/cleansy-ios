#import "CleaningInfoViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "Util.h"

@interface CleaningInfoViewController ()

@end

@implementation CleaningInfoViewController
{
    UIButton *exitButton;
    CGFloat screenHeight, screenWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    NSLog(@"CleaningInfoViewController loadView");
    
    // NavigationBar Settings //
    [self.navigationItem setTitle:@"Cleaning Packages"];
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
    
    /*
    SEL selector = @selector(clickedProceed:);
    UIButton *bottomButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                                          inController:self
                                                            buttonText:@"Submit"
                                                             textColor:[UIColor whiteColor]
                                                       backgroundColor:[DisplayFx colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    [self.view addSubview:bottomButton];
    */
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"This is a filler text for cleaning description of our different packages"
                                                      y_pos:screenHeight*0.2
                                                   pctWidth:0.8]];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"This is a filler text for cleaning description of our different packages"
                                                      y_pos:screenHeight*0.35
                                                   pctWidth:0.8]];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"This is a filler text for cleaning description of our different packages"
                                                      y_pos:screenHeight*0.5
                                                   pctWidth:0.8]];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"This is a filler text for cleaning description of our different packages"
                                                      y_pos:screenHeight*0.65
                                                   pctWidth:0.8]];
    
    [self.view addSubview:[DisplayFx themeContentTextItalic:@"This is a filler text for cleaning description of our different packages"
                                                      y_pos:screenHeight*0.8
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
