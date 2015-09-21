#import <Foundation/Foundation.h>

#define CLEANING_RATE_BASIC 0
#define CLEANING_RATE_PREMIUM 1
#define COUPON_TYPE_NONE 0
#define COUPON_TYPE_DOLLAR 1
#define COUPON_TYPE_PERCENTAGE 2

@interface OrderManager : NSObject

@property (nonatomic, retain) NSDate *transactionStart;
@property (nonatomic, retain) NSDate *transactionEnd;
@property (nonatomic, retain) NSString *addressStreet1;
@property (nonatomic, retain) NSString *addressStreet2;
@property (nonatomic, retain) NSString *addressCity;
@property (nonatomic, retain) NSString *addressState;
@property (nonatomic, retain) NSString *addressCountry;
@property (nonatomic, retain) NSString *addressZip;
@property (nonatomic, retain) NSString *addressNote;
@property (nonatomic, retain) NSString *customerPhone;
@property (nonatomic, retain) NSString *customerName;
@property (nonatomic, retain) NSString *customerEmail;
@property (nonatomic, retain) NSDate *scheduleDate;
@property (nonatomic) NSInteger bedroomCount;
@property (nonatomic) NSInteger bathroomCount;
@property (nonatomic) bool addressSet;
@property (nonatomic) bool scheduleSet;
@property (nonatomic) bool cleaningSet;
@property (nonatomic) bool contactSet;
@property (nonatomic) bool registrationSet;
@property (nonatomic) NSInteger cleaningRate;
@property (nonatomic) CGFloat costQuote;
@property (nonatomic) CGFloat timeEstimate;
@property (nonatomic) NSString *quoteId;
@property (nonatomic, retain) NSString *couponCode;
@property (nonatomic) CGFloat couponDiscount;   // amount discounted
@property (nonatomic, retain) NSString *finalPaymentDisplayed;
@property (nonatomic) NSString *confirmationCode;


+ (id)sharedManager;
- (void)saveData;
- (void)loadData;
- (void)eraseData;
- (BOOL)isAddressSet;
- (BOOL)isScheduleSet;
- (BOOL)isContactSet;
- (NSString*)getScheduleAsString;
- (NSString*)getScheduleAsServerString;
- (NSString*)getScheduleDateAsString;
- (NSString*)getScheduleTimeAsString;
- (NSString*)getTransactionTimeAsString;
- (NSDate*)getInitialDate;
- (CGFloat)getQuote;
- (CGFloat)getCouponDiscount;
- (NSString*)getQuoteString;
- (CGFloat)getTimeQuote;
- (NSString*)getTimeQuoteString;
- (NSString*)getCleanDescriptionString;
- (BOOL)isPreferenceRetained;
- (void)setPreferencesRetained:(BOOL) option;
- (void)setCostQuote:(CGFloat)serverCostQuote;
- (void)setTimeQuote:(CGFloat)serverTimeQuote;
- (void)setCouponDiscount:(CGFloat)serverCouponDiscount;

@end