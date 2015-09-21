#import "RecentHistoryViewController.h"
#import "DisplayFx.h"
#import "Global.h"
#import "Util.h"
#import "OrderManager.h"
#import "ReceiptViewController.h"
#import "HistoryManager.h"
#import "UIView+Toast.h"
#import "AFNetworking.h"

@interface RecentHistoryViewController ()

@end

@implementation RecentHistoryViewController
{
    UIButton *exitButton;
    CGFloat screenHeight, screenWidth;
    NSString *webAddress;
    NSArray *menuArray;
    UITableView* tableView;
    //OrderManager *order;
    UISwitch *retainPreferencesToggle;
    //NSMutableArray *historyList;
    NSDictionary *customerOrderHistory;
    bool historyReceived;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    NSLog(@"RecentCleaningsViewController loadView");
    
     //historyList = [HistoryManager getHistoryList];
    
    // NavigationBar Settings //
    [self.navigationItem setTitle:@"HISTORY"];
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
    
    tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.bounces = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    if ([tableView respondsToSelector:@selector(separatorInset)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [[UITableViewCell appearance] setTintColor:[Util colorWithHexString:TITLE_BAR_BG_COLOR_MODAL]];
    [self.view addSubview:tableView];
    
    
    [self getOrderHistory:@"emailplaceholder"];
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
    switch (section) {
        case 0:
            //return historyList.count;
            return [customerOrderHistory count];
            break;

        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 60;
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
            headerLabel.text = @"Recent bookings";
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
            NSDictionary *orderDetail = [customerOrderHistory objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row+1]];
            
            //cell.textLabel.text = [NSString stringWithFormat:@"Booking %@", [((OrderManager *)[historyList objectAtIndex:indexPath.row]) getTransactionTimeAsString]];
            cell.textLabel.text = [NSString stringWithFormat:@"Cleaning %@", [orderDetail objectForKey:@"appointment"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)varTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int selectedRow = (int) indexPath.row;
    
    [varTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath - %@", indexPath);
    switch (indexPath.section) {
            
        case 0:
        {
            //OrderManager *storedOrder = [historyList objectAtIndex:indexPath.row];
            NSDictionary *orderDetail = [customerOrderHistory objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row+1]];
            
            ReceiptViewController *rvc = [[ReceiptViewController alloc] init];
            rvc.confirmationCode = [orderDetail objectForKey:@"confirmationcode"];
            rvc.street1 = [orderDetail objectForKey:@"street1"];
            rvc.street2 = [orderDetail objectForKey:@"street2"];
            rvc.city = [orderDetail objectForKey:@"city"];
            rvc.state = [orderDetail objectForKey:@"state"];
            rvc.zipcode = [orderDetail objectForKey:@"zipcode"];
            rvc.bedroomCount = [[orderDetail objectForKey:@"bedcount"] integerValue];
            rvc.bathroomCount = [[orderDetail objectForKey:@"bathcount"] integerValue];
            rvc.cleanDate = [orderDetail objectForKey:@"appointment"];
            rvc.orderDate = [orderDetail objectForKey:@"orderdate"];

            //rvc.notes = @"address note";
            rvc.phone = [orderDetail objectForKey:@"phone"];
            rvc.price = [orderDetail objectForKey:@"ordertotal"];
            rvc.priceDiscounted = [[orderDetail objectForKey:@"discountamount"] floatValue] > 0 ? YES : NO;
            rvc.presentedAsHistory = YES;
            [self.navigationController pushViewController:rvc animated:YES];
            break;
        }
    }
}

#pragma mark AFNetworking Methods

- (void)getOrderHistory:(NSString*)email
{
    NSString *requestString = [NSString stringWithFormat: @"http://sweepd.com/api/index.php?request=getorderhistory&email=%@", email];
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
            historyReceived = YES;
            customerOrderHistory = [res objectForKey:@"orders"];
            //NSLog(@"Count: %i", [[res objectForKey: @"orders"] count]);
            for(id key in customerOrderHistory) {
                NSLog(@"item key: %@", key);
                //id value = [customerOrderHistory objectForKey:key];
                //NSLog(@"item: %@", (NSString*)value);
            }
            [tableView reloadData];
            [self.view hideToastActivity];
        } else {
            NSLog(@"failed");
            NSString *errorDescription = [res valueForKey:WS_ERRORDESCRIPTION_KEY];
            [self.view hideToastActivity];
            [self.view makeToast:errorDescription]; // "we cannot provide confirmation at this time even though payment succeeded"
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view hideToastActivity];
        [self.view makeToast:@"Sorry, we could not process this request"];
    }];
    
    [self.view makeToastActivity];
    [operation start];
    
};

@end
