#import <UIKit/UIKit.h>

@interface MELetterCircleView : UIView

/**
 * The text to display in the view. This should be limited to
 * just a few characters.
 */
@property (nonatomic, strong) NSString *text;

@end



@interface MELetterCircleView ()

@property (nonatomic, strong) UIColor *circleColor;

@end