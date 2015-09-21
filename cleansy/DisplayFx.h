#import <Foundation/Foundation.h>


@interface DisplayFx : NSObject

//+(UIColor*)colorWithHexString:(NSString*)hex;


+(UIView*)themeSectionLabelWithHighlight:(NSString*)displayText
                                   y_pos:(CGFloat)y_pos
                              withAction:(SEL)selector
                            inController:(UIViewController*)controller;

+(UILabel*)customTextLabel:(NSString*)displayText
                     y_pos:(CGFloat)y_pos
                  widthPct:(CGFloat)widthPct
                   leftPct:(CGFloat)leftPad
                      font:(UIFont*)font
                 textColor:(UIColor*)textColor;

+(UILabel*)themeContentText:(NSString*)displayText y_pos:(CGFloat)y_pos;
+(UILabel*)themeHistoryText:(NSString*)displayText y_pos:(CGFloat)y_pos;
+(UILabel*)themeContentTextItalic:(NSString*)displayText
                            y_pos:(CGFloat)y_pos
                            pctWidth:(CGFloat)pctWidth;

+(UILabel*)debugMessageText:(NSString*)displayText
                            y_pos:(CGFloat)y_pos
                         pctWidth:(CGFloat)pctWidth;

+(UIView*)themeRoomCountControlWithSelector:(SEL)selector
                               inController:(UIViewController*)controller
                                      y_pos:(CGFloat)y_pos
                                    counterTag:(int)viewTag
                                     decTag:(int)decTag
                                     incTag:(int)incTag;

+(UIView*)themeSelectorServiceLevelWithSelector:(SEL)selector
                                   inController:(UIViewController*)controller
                                          y_pos:(CGFloat)y_pos
                                        viewTag:(int)tag;

+(UILabel*)themeQuoteText:(NSString*)displayText y_pos:(CGFloat)y_pos;

+(UIButton*)themeButtonDisplayText:(NSString*)displayText
                             y_pos:(CGFloat)y_pos
                          selector:(SEL)selector
                      inController:(UIViewController*)controller;

+(UIButton*)themeButtonDisplayText:(NSString*)displayText
                             y_pos:(CGFloat)y_pos
                          widthPct:(CGFloat)widthPct
                          selector:(SEL)selector
                      inController:(UIViewController*)controller;

+(UIButton*)couponButtonDisplayText:(NSString*)displayText
                             y_pos:(CGFloat)y_pos
                          selector:(SEL)selector
                      inController:(UIViewController*)controller;


+(UIButton*)customButtonDisplayText:(NSString*)displayText
                              y_pos:(CGFloat)y_pos
                            bgColor:(UIColor*)bgColor
                          fontColor:(UIColor*)fontColor
                        borderColor:(UIColor*)borderColor
                           widthPct:(CGFloat)buttonWidth
                            leftPct:(CGFloat)paddingLeft
                           selector:(SEL)selector
                       inController:(UIViewController*)controller;

+(UIButton*)bottomSingleButtonWithSelector:(SEL)selector
                           inController:(UIViewController*)controller
                             buttonText:(NSString*)buttonText
                              textColor:(UIColor *)textColor
                        backgroundColor:(UIColor*)backgroundColor;

+(UIButton*)bottomLeftBackButtonWithSelector:(SEL)selector
                                inController:(UIViewController*)controller
                             backgroundColor:(UIColor*)backgroundColor;

+(UIButton*)bottomRightButtonWithSelector:(SEL)selector
                              inController:(UIViewController*)controller
                                buttonText:(NSString*)buttonText
                                 textColor:(UIColor *)textColor
                           backgroundColor:(UIColor*)backgroundColor;

+(UITextField*)textFieldWithHint:(NSString*)hintText y_pos:(CGFloat)y_pos;

@end
