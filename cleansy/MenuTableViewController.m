#import "MenuTableViewController.h"
#import "DisplayFx.h"
#import "MenuDefaultViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Global.h"
#import "SocialViewController.h"
#import "SettingsViewController.h"
#import "RecentHistoryViewController.h"
#import "Util.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController
{
    NSArray *menuArray;
    UITableView* tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    menuArray = [NSArray arrayWithObjects: @"SUPPORT", @"SHARE", @"HISTORY", @"ABOUT", nil];
    
    tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.bounces = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [tableView setBackgroundColor:[Util colorWithHexString:MENU_ITEM_BG_COLOR]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    //[tableView reloadData];
    [self.view addSubview:tableView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}


#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 70)];
    UIView *topSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 20)];
    [topSpacerView setBackgroundColor:[Util colorWithHexString:MENU_BG_COLOR]];
    [view addSubview:topSpacerView];
    UIView *bottomSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 260, 5)];
    [bottomSpacerView setBackgroundColor:[Util colorWithHexString:MENU_ITEM_BG_COLOR]];
    [view addSubview:bottomSpacerView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 260, 45)];

    /*
    [label setFont:[UIFont fontWithName:@"ArialMT" size:22.0]];
    NSString *string =@"Menu";
    [label setText:string];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
     */
    [label setBackgroundColor:[Util colorWithHexString:MENU_BG_COLOR]];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)varTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [varTableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text= [NSString stringWithFormat:@"     %@", [menuArray objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [Util colorWithHexString:MENU_ITEM_TEXT_COLOR];
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:18.0];
    [cell.textLabel setFrame:CGRectMake(50, 0, 210, 60)];
    //[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell setBackgroundColor:[Util colorWithHexString:MENU_ITEM_BG_COLOR]];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [Util colorWithHexString:MENU_ITEM_BG_HIGHLIGHT_COLOR];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)tableView:(UITableView *)varTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectedRow = (int) indexPath.row;
    
    [varTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"didSelectRowAtIndexPath - %@", indexPath);
    
    MenuDefaultViewController *mdvc = [[MenuDefaultViewController alloc] init];
    [mdvc setViewTitle:[menuArray objectAtIndex:selectedRow]];
    
    switch (selectedRow) {
        case 0:
        {
            [mdvc setWebAddress:@"https://homejoy.zendesk.com/hc/en-us"];
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = mdvc;
            UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:mdvc];
            [self presentViewController:navViewHolder animated:YES completion:nil];
            break;
        }
        case 1:
        {
            SocialViewController *svc = [[SocialViewController alloc] init];
            svc.presentedAsModal = YES;
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = svc;
            UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:svc];
            [self presentViewController:navViewHolder animated:YES completion:nil];
            break;
        }
        /*
        case 2:
        {
            SettingsViewController *svc = [[SettingsViewController alloc] init];
            UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:svc];
            [self presentViewController:navViewHolder animated:YES completion:nil];
            break;
        }
        */
        case 2:
        {
            RecentHistoryViewController *rcvc = [[RecentHistoryViewController alloc] init];
            UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:rcvc];
            [self presentViewController:navViewHolder animated:YES completion:nil];
            break;
        }
        case 3:
        {
            [mdvc setWebAddress:@"http://www.handybook.com/about"];
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = mdvc;
            UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:mdvc];
            [self presentViewController:navViewHolder animated:YES completion:nil];
            break;
        }
        default:
        {
            [mdvc setWebAddress:@""];
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).currentModalView = mdvc;
            UINavigationController *navViewHolder = [[UINavigationController alloc] initWithRootViewController:mdvc];
            [self presentViewController:navViewHolder animated:YES completion:nil];
            break;
        }
    }
    
    /*
    SWRevealViewController *rootController = (SWRevealViewController*)[[(AppDelegate*) [[UIApplication sharedApplication]delegate] window] rootViewController];
    [rootController setFrontViewPosition:FrontViewPositionLeftSideMost animated:YES];
     */
    
}
@end
