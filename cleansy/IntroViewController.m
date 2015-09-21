#import "IntroViewController.h"
#import "Util.h"
#import "Global.h"
#import "DisplayFx.h"
#import "DDPageControl.h"


@interface IntroViewController ()

@end

@implementation IntroViewController
{
    UIButton *nextButton;
    CGFloat screenHeight, screenWidth;
    UIScrollView *scrollView;
    DDPageControl *pageControl;
    int numberOfPages;
}

@synthesize delegate;

// Method used to call to our delegate and let it do the work.
- (void)introComplete
{
    // Sanity check, did they set the delegate?
    if([self delegate] != nil)
        [[self delegate] introComplete:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    numberOfPages = 5;
    
    screenHeight = self.view.frame.size.height;
    screenWidth = self.view.frame.size.width;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)] ;
    [scrollView setUserInteractionEnabled:YES];
    [scrollView setPagingEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.opaque = NO;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
    [bgImageView setFrame:CGRectMake(0, 0, screenWidth, screenHeight+20)];
    [self.view addSubview:bgImageView];
    
    [self.view addSubview:scrollView];
    
#pragma mark intro screen 1 settings
    
    CGFloat currentPageYStart = screenHeight * 0;
    
    UILabel *labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:@"cleansy"];
    [labelView setTextAlignment:NSTextAlignmentRight];
    [labelView setTextColor:[UIColor blackColor]];
    [labelView setFont:[UIFont fontWithName: @"HelveticaNeue" size: 30.0f]];
    CGSize maxSize = CGSizeMake(screenWidth*0.8, CGFLOAT_MAX);
    CGSize requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(screenWidth - requiredSize.width - 30,
                                   screenHeight*0.42 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView];
    
    labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:@"swipe ▲ to learn more"];
    [labelView setTextAlignment:NSTextAlignmentRight];
    [labelView setTextColor:[UIColor whiteColor]];
    [labelView setFont:[UIFont fontWithName: @"HelveticaNeue" size: 14.0f]];
    maxSize = CGSizeMake(screenWidth*0.8, CGFLOAT_MAX);
    requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(screenWidth - requiredSize.width - 30,
                                   screenHeight*0.6 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView];

    
#pragma mark intro screen 2 settings
    
    currentPageYStart = screenHeight * 1;
    
    CGFloat extraLeftOffset = screenWidth*0.15;
    CGFloat extraTopOffset = screenHeight*0.14;
    
    NSLog(@"screenWidth: %f screenHeight: %f", screenWidth, screenHeight);
    //CGSize imageDisplaySize = CGSizeMake(screenWidth*0.7, screenWidth*0.7);
    CGSize imageDisplaySize = CGSizeMake(200, 200);
    //UIImage *image = [Util imageWithImage:[UIImage imageNamed:@"introcircle1"] scaledAspectToSize:imageDisplaySize];
    UIImage *image = [UIImage imageNamed:@"introcircle1"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect rect = imageView.frame;
    rect.size.height = imageDisplaySize.height;
    rect.size.width = imageDisplaySize.width;
    rect.origin.x = (((screenWidth - extraLeftOffset) - image.size.width) *0.5) + extraLeftOffset;
    rect.origin.y = extraTopOffset + currentPageYStart;
    imageView.frame = rect;
    [scrollView addSubview:imageView];
    
    labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:@"set an address and time"];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setTextColor:[UIColor whiteColor]];
    [labelView setFont:[UIFont fontWithName: @"HelveticaNeue" size: 17.0f]];
    maxSize = CGSizeMake(screenWidth*0.7, CGFLOAT_MAX);
    requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                   extraTopOffset + image.size.height + 25 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView];
    
    UILabel *labelView2 = [[UILabel alloc] init];
    labelView2.lineBreakMode = NSLineBreakByWordWrapping;
    labelView2.numberOfLines = 0;
    [labelView2 setText:@"type in the address of the location you want cleaned and the time you want us to start"];
    [labelView2 setTextAlignment:NSTextAlignmentCenter];
    [labelView2 setTextColor:[Util colorWithHexString:@"ffffcc"]];
    [labelView2 setFont:[UIFont fontWithName: @"HelveticaNeue" size: 15.0f]];
    maxSize = CGSizeMake(screenWidth*0.55, CGFLOAT_MAX);
    requiredSize = [labelView2 sizeThatFits:maxSize];
    [labelView2 setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                   extraTopOffset + image.size.height + 67 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView2];
    
#pragma mark intro screen 3 settings
    
    currentPageYStart = screenHeight * 2;
    
    image = [UIImage imageNamed:@"introcircle2"];
    imageView = [[UIImageView alloc] initWithImage:image];
    rect = imageView.frame;
    rect.size.height = imageDisplaySize.height;
    rect.size.width = imageDisplaySize.width;
    rect.origin.x = (((screenWidth - extraLeftOffset) - image.size.width) *0.5) + extraLeftOffset;
    rect.origin.y = extraTopOffset + currentPageYStart;
    imageView.frame = rect;
    [scrollView addSubview:imageView];
    
    labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:@"provide the details"];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setTextColor:[UIColor whiteColor]];
    [labelView setFont:[UIFont fontWithName: @"HelveticaNeue" size: 17.0f]];
    maxSize = CGSizeMake(screenWidth*0.7, CGFLOAT_MAX);
    requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                   extraTopOffset + image.size.height + 25 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView];
    
    labelView2 = [[UILabel alloc] init];
    labelView2.lineBreakMode = NSLineBreakByWordWrapping;
    labelView2.numberOfLines = 0;
    [labelView2 setText:@"let us know how many rooms need to be cleaned and what type of cleaning service you want"];
    [labelView2 setTextAlignment:NSTextAlignmentCenter];
    [labelView2 setTextColor:[Util colorWithHexString:@"ffffcc"]];
    [labelView2 setFont:[UIFont fontWithName: @"HelveticaNeue" size: 15.0f]];
    maxSize = CGSizeMake(screenWidth*0.55, CGFLOAT_MAX);
    requiredSize = [labelView2 sizeThatFits:maxSize];
    [labelView2 setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                    extraTopOffset + image.size.height + 67 + currentPageYStart,
                                    requiredSize.width,
                                    requiredSize.height)];
    [scrollView addSubview:labelView2];

#pragma mark intro screen 4 settings
    
    currentPageYStart = screenHeight * 3;
    
    image = [UIImage imageNamed:@"introcircle3"];
    imageView = [[UIImageView alloc] initWithImage:image];
    rect = imageView.frame;
    rect.size.height = imageDisplaySize.height;
    rect.size.width = imageDisplaySize.width;
    rect.origin.x = (((screenWidth - extraLeftOffset) - image.size.width) *0.5) + extraLeftOffset;
    rect.origin.y = extraTopOffset + currentPageYStart;
    imageView.frame = rect;
    [scrollView addSubview:imageView];
    
    labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:@"get a quote"];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setTextColor:[UIColor whiteColor]];
    [labelView setFont:[UIFont fontWithName: @"HelveticaNeue" size: 17.0f]];
    maxSize = CGSizeMake(screenWidth*0.7, CGFLOAT_MAX);
    requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                   extraTopOffset + image.size.height + 25 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView];
    
    labelView2 = [[UILabel alloc] init];
    labelView2.lineBreakMode = NSLineBreakByWordWrapping;
    labelView2.numberOfLines = 0;
    [labelView2 setText:@"you will get a price before making your appointment. no hidden charges or fees"];
    [labelView2 setTextAlignment:NSTextAlignmentCenter];
    [labelView2 setTextColor:[Util colorWithHexString:@"ffffcc"]];
    [labelView2 setFont:[UIFont fontWithName: @"HelveticaNeue" size: 15.0f]];
    maxSize = CGSizeMake(screenWidth*0.55, CGFLOAT_MAX);
    requiredSize = [labelView2 sizeThatFits:maxSize];
    [labelView2 setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                    extraTopOffset + image.size.height + 67 + currentPageYStart,
                                    requiredSize.width,
                                    requiredSize.height)];
    [scrollView addSubview:labelView2];

#pragma mark intro screen 5 settings
    
    currentPageYStart = screenHeight * 4;
    
    image = [UIImage imageNamed:@"introcircle4"];
    imageView = [[UIImageView alloc] initWithImage:image];
    rect = imageView.frame;
    rect.size.height = imageDisplaySize.height;
    rect.size.width = imageDisplaySize.width;
    rect.origin.x = (((screenWidth - extraLeftOffset) - image.size.width) *0.5) + extraLeftOffset;
    rect.origin.y = extraTopOffset + currentPageYStart;
    imageView.frame = rect;
    [scrollView addSubview:imageView];
    
    labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:@"confirm payment"];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setTextColor:[UIColor whiteColor]];
    [labelView setFont:[UIFont fontWithName: @"HelveticaNeue" size: 17.0f]];
    maxSize = CGSizeMake(screenWidth*0.7, CGFLOAT_MAX);
    requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                   extraTopOffset + image.size.height + 25 + currentPageYStart,
                                   requiredSize.width,
                                   requiredSize.height)];
    [scrollView addSubview:labelView];
    
    labelView2 = [[UILabel alloc] init];
    labelView2.lineBreakMode = NSLineBreakByWordWrapping;
    labelView2.numberOfLines = 0;
    [labelView2 setText:@"submit your payment safely with paypal.  it’s that simple"];
    [labelView2 setTextAlignment:NSTextAlignmentCenter];
    [labelView2 setTextColor:[Util colorWithHexString:@"ffffcc"]];
    [labelView2 setFont:[UIFont fontWithName: @"HelveticaNeue" size: 15.0f]];
    maxSize = CGSizeMake(screenWidth*0.55, CGFLOAT_MAX);
    requiredSize = [labelView2 sizeThatFits:maxSize];
    [labelView2 setFrame:CGRectMake(((screenWidth - extraLeftOffset - requiredSize.width) *0.5) + extraLeftOffset,
                                    extraTopOffset + image.size.height + 67 + currentPageYStart,
                                    requiredSize.width,
                                    requiredSize.height)];
    [scrollView addSubview:labelView2];
    

    
    [scrollView setContentSize:CGSizeMake([scrollView bounds].size.width, screenHeight + currentPageYStart)];
    /*
    NSUInteger nimages = 0;

  	CGFloat cy = 0;
	for (; ; nimages++) {
		NSString *imageName = [NSString stringWithFormat:@"intro%d.jpg", (nimages + 1)];
		UIImage *image = [UIImage imageNamed:imageName];
		if (image == nil) {
			break;
		}
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		
		CGRect rect = imageView.frame;
		rect.size.height = image.size.height;
		rect.size.width = image.size.width;
		rect.origin.x = ((scrollView.frame.size.width - image.size.width) / 2);
		rect.origin.y = ((scrollView.frame.size.height - image.size.height) / 2) + cy;
        
		imageView.frame = rect;
        
		[scrollView addSubview:imageView];
        
		//cx += scrollView.frame.size.width;
        cy += scrollView.frame.size.height;
	}
	[scrollView setContentSize:CGSizeMake([scrollView bounds].size.width, cy)];
    */
    
    pageControl = [[DDPageControl alloc] init];
    [pageControl setIndicatorDiameter:2.0f];
    [pageControl setIndicatorSpace:4.0f];
    [pageControl setOffColor:[Util colorWithHexString:INTRO_PAGECONTROL_OFF]];
    [pageControl setOnColor:[Util colorWithHexString:INTRO_PAGECONTROL_ON]];
    pageControl.numberOfPages = numberOfPages;
    pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2);
    [pageControl setFrame:CGRectMake(screenWidth-40, screenHeight-90, 40, 90)];
    [pageControl setHidden:YES];
    [self.view addSubview:pageControl];
    
	
    
    SEL selector = @selector(clickedNextButton:);
    nextButton = [DisplayFx bottomSingleButtonWithSelector:selector
                                              inController:self
                                                buttonText:@"START"
                                                 textColor:[UIColor whiteColor]
                                           backgroundColor:[Util colorWithHexString:BOTTOM_BAR_BACKBTN_BG_COLOR]];
    [self.view addSubview:nextButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    CGFloat pageHeight = _scrollView.frame.size.height;
    int page = floor((_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    pageControl.currentPage = page;
    if (page == 0) {
        [pageControl setHidden:YES];
    } else {
        [pageControl setHidden:NO];
    }
    
    
}

-(void) clickedNextButton:(UIButton *)sender
{
    NSLog(@"clickedNext");

    if([self delegate] != nil)
        [[self delegate] introComplete:YES];
}

@end