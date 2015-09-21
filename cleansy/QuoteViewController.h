#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

//@interface QuoteViewController : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, UIPopoverControllerDelegate>
@interface QuoteViewController : UIViewController <PayPalPaymentDelegate>

-(void)dismissPaypalView;

//@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;


@end
