#import "DisplayFx.h"
#import "Global.h"
#import "MELetterCircleView.h"

@implementation DisplayFx



+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return  [UIColor grayColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(UIView*)themeSectionLabelWithHighlight:(NSString*)displayText
                                   y_pos:(CGFloat)y_pos
                              withAction:(SEL)selector
                            inController:(UIViewController*)controller
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, y_pos-20, screenWidth, 40)];
    
    UILabel* textLabelHighlight = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth*.05, 20, screenWidth*.9, 2)];
    [textLabelHighlight setBackgroundColor:[DisplayFx colorWithHexString:BOTTOM_BAR_BG_COLOR]];
    [tempView addSubview:textLabelHighlight];
    
    CGSize expectedLabelSize = [displayText sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 14.0f]}];
    CGFloat expectedLabelWidth = ceilf(expectedLabelSize.width);
    CGFloat expectedLabelHeight = ceilf(expectedLabelSize.height);
    UILabel* textLabelBackground = [[UILabel alloc] init];
    if (selector) {
        [textLabelBackground setFrame:CGRectMake(screenWidth*.15, 20 - (expectedLabelHeight/2), expectedLabelWidth+36, expectedLabelHeight)];
    } else {
        [textLabelBackground setFrame:CGRectMake(screenWidth*.15, 20 - (expectedLabelHeight/2), expectedLabelWidth+16, expectedLabelHeight)];
    }
    [textLabelBackground setBackgroundColor:[UIColor whiteColor]];
    [tempView addSubview:textLabelBackground];
    
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth*.15+8, 20-expectedLabelHeight/2, expectedLabelWidth, expectedLabelHeight)];
    [text setText:displayText];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setTextColor:[DisplayFx colorWithHexString:BUTTON_TEXT_COLOR]];
    [text setFont:[UIFont fontWithName: @"HelveticaNeue" size: 14.0f]];
    [tempView addSubview:text];
    
    if (selector) {
        MELetterCircleView *info = [[MELetterCircleView alloc] init];
        [info setFrame:CGRectMake(screenWidth*.15 + expectedLabelWidth + 12, 11, 20, 20)];
        [info setBackgroundColor:[UIColor whiteColor]];
        [info setText:@"?"];
        info.circleColor = [DisplayFx colorWithHexString:BOTTOM_BAR_BG_COLOR];
        [tempView addSubview:info];
        
        UIButton *invisibleButton = [[UIButton alloc] init ];
        [invisibleButton setFrame:CGRectMake(screenWidth*.15, 5, expectedLabelWidth+40, 30)];
        [invisibleButton setEnabled:YES];
        [invisibleButton setUserInteractionEnabled:YES];
        [invisibleButton setBackgroundColor:[UIColor clearColor]];
        [invisibleButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
        
        [tempView addSubview:invisibleButton];
    }
    
    return tempView;
}

+(UILabel*)customTextLabel:(NSString*)displayText
                     y_pos:(CGFloat)y_pos
                  widthPct:(CGFloat)widthPct
                   leftPct:(CGFloat)leftPad
                      font:(UIFont*)font
                 textColor:(UIColor*)textColor
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    UILabel *labelView = [[UILabel alloc] init];
    labelView.lineBreakMode = NSLineBreakByWordWrapping;
    labelView.numberOfLines = 0;
    [labelView setText:displayText];
    [labelView setTextAlignment:NSTextAlignmentLeft];
    [labelView setTextColor:textColor];
    [labelView setFont:font];
    CGSize maxSize = CGSizeMake(screenWidth*widthPct, CGFLOAT_MAX);
    CGSize requiredSize = [labelView sizeThatFits:maxSize];
    [labelView setFrame:CGRectMake(screenWidth*leftPad, y_pos, requiredSize.width, requiredSize.height)];
    
    return labelView;
}


+(UILabel*)themeContentText:(NSString*)displayText y_pos:(CGFloat)y_pos
{
    return [self customTextLabel:displayText
                           y_pos:y_pos
                        widthPct:0.7
                         leftPct:0.15
                            font:[UIFont fontWithName: @"ArialMT" size: 13.0f]
                       textColor:[self colorWithHexString:LABEL_TEXT_COLOR]];
}

+(UILabel*)themeHistoryText:(NSString*)displayText y_pos:(CGFloat)y_pos
{
    return [self customTextLabel:displayText
                           y_pos:y_pos
                        widthPct:0.8
                         leftPct:0.1
                            font:[UIFont fontWithName: @"ArialMT" size: 13.0f]
                       textColor:[self colorWithHexString:LABEL_TEXT_COLOR]];
}

+(UILabel*)themeContentTextItalic:(NSString*)displayText
                            y_pos:(CGFloat)y_pos
                            pctWidth:(CGFloat)pctWidth
{
    return [self customTextLabel:displayText
                           y_pos:y_pos
                        widthPct:pctWidth
                         leftPct:(1-pctWidth)/2
                            font:[UIFont fontWithName: @"Arial-ItalicMT" size: 13.0f]
                       textColor:[self colorWithHexString:LABEL_TEXT_COLOR]];
}

+(UILabel*)debugMessageText:(NSString*)displayText
                      y_pos:(CGFloat)y_pos
                   pctWidth:(CGFloat)pctWidth
{
    return [self customTextLabel:displayText
                           y_pos:y_pos
                        widthPct:pctWidth
                         leftPct:(1-pctWidth)/2
                            font:[UIFont fontWithName: @"ArialMT" size: 13.0f]
                       textColor:[UIColor redColor]];
}

+(UIView*)themeRoomCountControlWithSelector:(SEL)selector
                                inController:(UIViewController*)controller
                                       y_pos:(CGFloat)y_pos
                                    counterTag:(int)viewTag
                                     decTag:(int)decTag
                                     incTag:(int)incTag
{
    UIColor *borderColor = [DisplayFx colorWithHexString:BUTTON_BORDER_COLOR];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth*0.15, y_pos, screenWidth*0.7, 40.0)];
    
    
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setTag:decTag];
    [leftButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"-" forState:UIControlStateNormal];
    [leftButton setFrame:CGRectMake(0, 0, 50.0, 40.0)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton setBackgroundColor:[DisplayFx colorWithHexString:BUTTON_BG_COLOR]];
    [leftButton setTitleColor:[DisplayFx colorWithHexString:BUTTON_TEXT_COLOR] forState:UIControlStateNormal];
    [[leftButton layer] setCornerRadius:5.0f];
    [[leftButton layer] setBorderWidth:1.0f];
    [[leftButton layer] setBorderColor:[borderColor CGColor]];
    [tempView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] init];
    rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setTag:incTag];
    [rightButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(screenWidth*0.7-50, 0, 50.0, 40.0)];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [rightButton setBackgroundColor:[DisplayFx colorWithHexString:BUTTON_BG_COLOR]];
    [rightButton setTitleColor:[DisplayFx colorWithHexString:BUTTON_TEXT_COLOR] forState:UIControlStateNormal];
    [[rightButton layer] setCornerRadius:5.0f];
    [[rightButton layer] setBorderWidth:1.0f];
    [[rightButton layer] setBorderColor:[borderColor CGColor]];
    [tempView addSubview:rightButton];
    
    UILabel *counterDisplay = [[UILabel alloc] init];
    [counterDisplay setTag:viewTag];
    [counterDisplay setText:@"1"];
    [counterDisplay setTextAlignment:NSTextAlignmentCenter];
    [counterDisplay setFrame:CGRectMake(40, 0, screenWidth*0.7-80, 40.0)];
    [counterDisplay setBackgroundColor:[UIColor whiteColor]];
    [counterDisplay setTextColor:[DisplayFx colorWithHexString:BUTTON_TEXT_COLOR]];
    [[counterDisplay layer] setBorderWidth:1.0f];
    [[counterDisplay layer] setBorderColor:[borderColor CGColor]];
    [tempView addSubview:counterDisplay];
    
    return tempView;
}

+(UIView*)themeSelectorServiceLevelWithSelector:(SEL)selector
                                   inController:(UIViewController*)controller
                                          y_pos:(CGFloat)y_pos
                                        viewTag:(int)tag
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(screenWidth*0.15, y_pos, screenWidth*0.7, 40)];
    
    UISegmentedControl *subCat = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Basic", @"Premium", nil]];
    [subCat setTag:tag];
    [subCat setBackgroundColor:[UIColor whiteColor]];
    [subCat setFrame:CGRectMake(0, 0, screenWidth*0.7, 40)];
    [subCat setSelectedSegmentIndex:0];
    [subCat addTarget:controller action:selector forControlEvents: UIControlEventValueChanged];
    UISegmentedControl *bcg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" ", @" ", nil]];

    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [DisplayFx colorWithHexString:BOTTOM_BAR_BG_COLOR],NSForegroundColorAttributeName,
                                                             [UIFont fontWithName:@"ArialMT" size:15.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor blackColor],NSForegroundColorAttributeName,
                                                             [UIFont fontWithName:@"ArialMT" size:15.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    
    UIColor *subColor = [DisplayFx colorWithHexString:BUTTON_BG_COLOR];
    [subCat setTintColor:subColor];
    [bcg setFrame:CGRectMake(0, 0, screenWidth*0.7, 40)];

    [bcg setTintColor:[DisplayFx colorWithHexString:BUTTON_BORDER_COLOR]];
    [bcg setUserInteractionEnabled:NO];
    [bcg setSelectedSegmentIndex:-1];

    [header addSubview:subCat];
    [header addSubview:bcg];
    
    return header;
}




+(UILabel*)themeQuoteText:(NSString*)displayText y_pos:(CGFloat)y_pos
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    CGFloat fontSize = 60.0f;
    CGSize expectedLabelSize = [displayText sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"Arial-ItalicMT" size: fontSize]}];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth*0.15, y_pos, screenWidth*0.7, expectedLabelSize.height)];
    [labelView setText:displayText];
    [labelView setTextAlignment:NSTextAlignmentLeft];
    [labelView setTextColor:[DisplayFx colorWithHexString:LABEL_TEXT_COLOR]];
    [labelView setFont:[UIFont fontWithName: @"Arial-ItalicMT" size: fontSize]];
    return labelView;
}

+(UIButton*)themeButtonDisplayText:(NSString*)displayText
                             y_pos:(CGFloat)y_pos
                          selector:(SEL)selector
                      inController:(UIViewController*)controller
{
    return [DisplayFx customButtonDisplayText:displayText
                                        y_pos:y_pos
                                      bgColor:[DisplayFx colorWithHexString:BUTTON_BG_COLOR]
                                    fontColor:[DisplayFx colorWithHexString:BUTTON_TEXT_COLOR]
                                  borderColor:[DisplayFx colorWithHexString:BUTTON_BORDER_COLOR]
                                     widthPct:0.8
                                      leftPct:0.1
                                     selector:selector
                                 inController:controller];
}

+(UIButton*)themeButtonDisplayText:(NSString*)displayText
                             y_pos:(CGFloat)y_pos
                          widthPct:(CGFloat)widthPct
                          selector:(SEL)selector
                      inController:(UIViewController*)controller
{
    return [DisplayFx customButtonDisplayText:displayText
                                        y_pos:y_pos
                                      bgColor:[DisplayFx colorWithHexString:BUTTON_BG_COLOR]
                                    fontColor:[DisplayFx colorWithHexString:BUTTON_TEXT_COLOR]
                                  borderColor:[DisplayFx colorWithHexString:BUTTON_BORDER_COLOR]
                                     widthPct:widthPct
                                      leftPct:(1-widthPct)/2
                                     selector:selector
                                 inController:controller];
}

+(UIButton*)couponButtonDisplayText:(NSString*)displayText
                              y_pos:(CGFloat)y_pos
                           selector:(SEL)selector
                       inController:(UIViewController*)controller
{
    return [DisplayFx customButtonDisplayText:displayText
                                        y_pos:y_pos
                                      bgColor:[UIColor whiteColor]
                                    fontColor:[DisplayFx colorWithHexString:TITLE_BAR_TEXT_COLOR]
                                  borderColor:[DisplayFx colorWithHexString:TITLE_BAR_BG_COLOR]
                                     widthPct:0.7
                                      leftPct:0.15
                                     selector:selector
                                 inController:controller];
}

+(UIButton*)customButtonDisplayText:(NSString*)displayText
                             y_pos:(CGFloat)y_pos
                            bgColor:(UIColor*)bgColor
                          fontColor:(UIColor*)fontColor
                        borderColor:(UIColor*)borderColor
                           widthPct:(CGFloat)buttonWidth
                            leftPct:(CGFloat)paddingLeft
                           selector:(SEL)selector
                       inController:(UIViewController*)controller
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    
    UIButton *button = [[UIButton alloc] init];
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:displayText forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor];
    [button setTitleColor:fontColor forState:UIControlStateNormal];
    [[button layer] setCornerRadius:5.0f];
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[borderColor CGColor]];
    CGSize maxSize = CGSizeMake(screenWidth*buttonWidth, CGFLOAT_MAX);
    CGSize requiredSize = [button sizeThatFits:maxSize];
    if (requiredSize.height < 40.0) {
        requiredSize.height = 40.0;
    }
    [button setFrame:CGRectMake(screenWidth*paddingLeft, y_pos, screenWidth*buttonWidth, requiredSize.height)];
    return button;
}

+(UIButton*)bottomSingleButtonWithSelector:(SEL)selector
                           inController:(UIViewController*)controller
                             buttonText:(NSString*)buttonText
                              textColor:(UIColor *)textColor
                        backgroundColor:(UIColor*)backgroundColor
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    CGFloat screenHeight = screenSize.size.height;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, screenHeight-45.0, screenWidth, 45.0)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [button setBackgroundColor:backgroundColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    return button;
}

+(UIButton*)bottomLeftBackButtonWithSelector:(SEL)selector
                            inController:(UIViewController*)controller
                         backgroundColor:(UIColor*)backgroundColor
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    CGFloat screenHeight = screenSize.size.height;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [button setImage:[UIImage imageNamed:@"backarrow"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, screenHeight-45, screenWidth*0.3, 45.0)];
    [button setBackgroundColor:backgroundColor];
    return button;
}

+(UIButton*)bottomRightButtonWithSelector:(SEL)selector
                             inController:(UIViewController*)controller
                               buttonText:(NSString*)buttonText
                                textColor:(UIColor *)textColor
                          backgroundColor:(UIColor*)backgroundColor
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    CGFloat screenHeight = screenSize.size.height;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setFrame:CGRectMake(screenWidth*0.3, screenHeight-45.0, screenWidth*0.7, 45.0)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [button setBackgroundColor:backgroundColor];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    return button;
}

+(UITextField*)textFieldWithHint:(NSString*)hintText y_pos:(CGFloat)y_pos
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(screenWidth*0.10,
                                                                           y_pos,
                                                                           screenWidth*0.8,
                                                                           40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = hintText;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}



@end