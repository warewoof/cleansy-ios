#import "SettingsViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "Util.h"
#import "OrderManager.h"

#define STRING_PERSONAL_INFO_PREF_YES @"Address and contact info saved"
#define STRING_PERSONAL_INFO_PREF_NO @"Address and contact info not saved"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
{
    UIButton *exitButton;
    CGFloat screenHeight, screenWidth;
    NSString *webAddress;
    NSArray *menuArray;
    UITableView* tableView;
    OrderManager *order;
    UISwitch *retainPreferencesToggle;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    NSLog(@"SettingsViewController loadView");
    
    order = [OrderManager sharedManager];
    
    
    // NavigationBar Settings //
    [self.navigationItem setTitle:@"SETTINGS"];
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
    contentView.backgroundColor = [Util colorWithHexString:@"ffffff"];
    [contentView setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    self.view = contentView;
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    NSLog(@"screenHeight:%f, screenWidth:%f", screenHeight, screenWidth);
    
    //tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.bounces = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //[tableView setBackgroundColor:[Util colorWithHexString:@"ffffff"]];
    //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    //[tableView reloadData];
    if ([tableView respondsToSelector:@selector(separatorInset)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [[UITableViewCell appearance] setTintColor:[Util colorWithHexString:TITLE_BAR_BG_COLOR_MODAL]];
    [self.view addSubview:tableView];
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

-(void)setWebAddress:(NSString*)url
{
    webAddress = url;
}

#pragma mark UITableViewDelegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60;
    } else {
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    //customView.backgroundColor = [UIColor redColor];
    UILabel *headerLabel = [[UILabel alloc] init];
    [headerLabel setFrame:CGRectInset(customView.frame, 15, 0)];
    //headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    headerLabel.font = [UIFont fontWithName:@"ArialMT" size:16.0];
    
    headerLabel.textColor = [UIColor grayColor];
    
    switch (section) {
        case 0:
        {
            [headerLabel setFrame:CGRectMake(15, 20, screenWidth-30, 40)];
            headerLabel.text = @"Personal information";
            break;
        }
        case 1:
        {
            headerLabel.text = @"Remember cleaning preferences";
            break;
        }
        default:
        {
            headerLabel.text = @"Empty";
            break;
        }
    }
    
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)varTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [varTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [Util colorWithHexString:TITLE_BAR_TEXT_COLOR];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14.0];
    [cell setBackgroundColor:[Util colorWithHexString:@"ffffff"]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [Util colorWithHexString:BOTTOM_BAR_BG_COLOR];
    [cell setSelectedBackgroundView:bgColorView];
    
    switch (indexPath.section) {
            
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text= [NSString stringWithFormat:@"%@",
                                          [order isPreferenceRetained]?STRING_PERSONAL_INFO_PREF_YES :STRING_PERSONAL_INFO_PREF_NO];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    retainPreferencesToggle = [[UISwitch alloc] init];
                    [retainPreferencesToggle addTarget:self action:@selector(retainPreferencesToggled) forControlEvents:UIControlEventValueChanged];
                    [retainPreferencesToggle setOn:[order isPreferenceRetained]];
                    cell.accessoryView = [[UIView alloc] initWithFrame:retainPreferencesToggle.frame];
                    [cell.accessoryView addSubview:retainPreferencesToggle];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text= @"Delete saved information";
                    break;
                }
            }
            break;
        }
        /*
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text= @"Save preferences";
                    if ([order isPreferenceRetained]) {
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    } else {
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    }
                    break;
                }
                case 1:
                {
                    cell.textLabel.text= @"Don't save preferences";
                    if (![order isPreferenceRetained]) {
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    } else {
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    }
                    break;
                }
            }
            break;
        }
         */
        default:
            break;
    }
    return cell;
}

- (void)retainPreferencesToggled
{
    NSLog(@"retainPreferencesToggled");
    if ([retainPreferencesToggle isOn]) {
        [order setPreferencesRetained:YES];
    } else {
        [order setPreferencesRetained:NO];
    }
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].textLabel.text = [NSString stringWithFormat:@"%@",
                                                                                                    [order isPreferenceRetained]?STRING_PERSONAL_INFO_PREF_YES :STRING_PERSONAL_INFO_PREF_NO];
}

-(void)tableView:(UITableView *)varTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int selectedRow = (int) indexPath.row;
    
    [varTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath - %@", indexPath);
    switch (indexPath.section) {
            
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                                    message:@"Are you sure you want to delete address and contact info saved in app?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Delete"
                                                          otherButtonTitles:@"Cancel", nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            /*
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [order setPreferencesRetained:YES];
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] setAccessoryType:UITableViewCellAccessoryNone];
                    //[tableView reloadData];
                    break;
                }
                case 1:
                {
                    [order setPreferencesRetained:NO];
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]] setAccessoryType:UITableViewCellAccessoryNone];
                    //[tableView reloadData];
                    break;
                }
            }
            break;
        }
             */
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSLog(@"Erasing data!");
        [order eraseData];
    }
}

@end
