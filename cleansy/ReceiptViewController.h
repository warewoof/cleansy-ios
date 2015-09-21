#import <UIKit/UIKit.h>

@interface ReceiptViewController : UIViewController

@property (nonatomic) BOOL presentedAsHistory;
@property (nonatomic) NSString *cleanDate;
@property (nonatomic) NSString *orderDate;
@property (nonatomic) NSInteger bedroomCount;
@property (nonatomic) NSInteger bathroomCount;
@property (nonatomic) NSInteger cleanRate;
@property (nonatomic) NSString *street1;
@property (nonatomic) NSString *street2;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *zipcode;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *notes;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *confirmationCode;
@property (nonatomic) BOOL priceDiscounted;
@end
