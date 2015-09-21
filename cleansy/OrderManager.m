#import "OrderManager.h"

@implementation OrderManager
/*
@synthesize addressStreet1, addressStreet2, addressZip, addressNote, customerPhone, customerName, customerEmail;
@synthesize scheduleDate, bedroomCount, bathroomCount, transactionStart, transactionEnd, addressSet, scheduleSet, cleaningSet;
@synthesize contactSet, registrationSet, cleaningRate, costQuote, timeEstimate;
@synthesize addressCity, addressCountry, addressState;
@synthesize couponCode, couponCostQuote, finalPaymentDisplayed;
*/
#define UD_ADD1 @"addressStreet1"
#define UD_ADD2 @"addressStreet2"
#define UD_ZIP @"addressZip"
#define UD_CITY @"addressCity"
#define UD_STATE @"addressState"
#define UD_COUNTRY @"addressCountry"
#define UD_NOTE @"addressNote"
#define UD_CNAME @"customerName"
#define UD_CNO @"customerNumber"
#define UD_CEMAIL @"customerEmail"
#define UD_PREF_SAVE @"cleanPreferencesSaved"

#pragma mark Singleton Methods

+ (id)sharedManager {
    static OrderManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        [self initVars];
    }
    return self;
}

-(void)initVars
{
    _transactionStart = [NSDate date];
    _transactionEnd = nil;
    _addressStreet1 = nil;
    _addressStreet2 = nil;
    _addressCity = nil;
    _addressState = nil;
    _addressCountry = nil;
    _addressZip = nil;
    _addressNote = nil;
    _customerPhone = nil;
    _customerName = nil;
    _customerEmail = nil;
    _scheduleDate = nil;
    _bedroomCount = 1;
    _bathroomCount = 1;
    _addressSet = NO;
    _scheduleSet = NO;
    _cleaningSet = NO;
    _contactSet = NO;
    _registrationSet = NO;
    _cleaningRate = CLEANING_RATE_BASIC;
    _costQuote = 0;
    _timeEstimate = 0;
    _couponCode = @"";
    _couponDiscount = 0;
    _finalPaymentDisplayed = nil;
}

-(void)saveData
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (![self isPreferenceRetained]) {
        NSLog(@"Preferences not saved, due to user setting!");
        return;
    }
    if (standardUserDefaults) {
        [standardUserDefaults setObject:_addressStreet1 forKey:UD_ADD1];
        [standardUserDefaults setObject:_addressStreet2 forKey:UD_ADD2];
        [standardUserDefaults setObject:_addressZip forKey:UD_ZIP];
        [standardUserDefaults setObject:_addressCity forKey:UD_CITY];
        [standardUserDefaults setObject:_addressState forKey:UD_STATE];
        [standardUserDefaults setObject:_addressCountry forKey:UD_COUNTRY];
        [standardUserDefaults setObject:_addressNote forKey:UD_NOTE];
        [standardUserDefaults setObject:_customerName forKey:UD_CNAME];
        [standardUserDefaults setObject:_customerPhone forKey:UD_CNO];
        [standardUserDefaults setObject:_customerEmail forKey:UD_CEMAIL];
        [standardUserDefaults synchronize];
    }
}

-(void)loadData
{
    [self initVars];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    _addressStreet1 = [standardUserDefaults stringForKey:UD_ADD1];
    _addressStreet2 = [standardUserDefaults stringForKey:UD_ADD2];
    _addressZip = [standardUserDefaults stringForKey:UD_ZIP];
    _addressCity = [standardUserDefaults stringForKey:UD_CITY];
    _addressState = [standardUserDefaults stringForKey:UD_STATE];
    _addressCountry = [standardUserDefaults stringForKey:UD_COUNTRY];
    _addressNote = [standardUserDefaults stringForKey:UD_NOTE];
    _customerName = [standardUserDefaults stringForKey:UD_CNAME];
    _customerPhone = [standardUserDefaults stringForKey:UD_CNO];
    _customerEmail = [standardUserDefaults stringForKey:UD_CEMAIL];
}

-(void)eraseData
{
    [self initVars];
    [self saveData];
}

-(BOOL)isAddressSet
{
    if (([_addressStreet1 length] != 0) && ([_addressZip length] != 0)) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isScheduleSet
{
    if (_scheduleDate) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isContactSet
{
    if (([_customerName length]!=0) && ([_customerEmail length]!=0) && ([_customerPhone length]!=0)) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)getScheduleAsString
{
    NSString *scheduleString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"cccc, MMM d"];
    scheduleString = [[dateFormatter stringFromDate:_scheduleDate] stringByAppendingString:@"\n"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mma"];
    scheduleString = [scheduleString stringByAppendingString:[timeFormatter stringFromDate:_scheduleDate]];
    return scheduleString;
}

-(NSString*)getScheduleAsServerString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm-a"];
    return [dateFormatter stringFromDate:_scheduleDate];
}


- (NSString*)getScheduleDateAsString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"cccc, MMM d"];
    return [dateFormatter stringFromDate:_scheduleDate];
}

- (NSString*)getScheduleTimeAsString
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mma"];
    return [timeFormatter stringFromDate:_scheduleDate];
}


- (NSString*)getTransactionTimeAsString;
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"yyyy-MM-dd hh:mma"];
    return [timeFormatter stringFromDate:_transactionEnd];
}

-(NSDate*)getInitialDate
{
    return [self nextHourDateForDate:[NSDate date]];
}

-(NSDate*)nextHourDateForDate:(NSDate*)date
{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    NSTimeInterval current = timestamp - fmod(timestamp, 3600);
    NSTimeInterval next = current + 3600*5; // set for four hours later
    
    return [NSDate dateWithTimeIntervalSince1970:next];
}

-(void)setCostQuote:(CGFloat)serverCostQuote
{
    _costQuote = serverCostQuote;
}

-(CGFloat)getQuote
{
    return _costQuote;
}

- (void)setCouponDiscount:(CGFloat)serverCouponDiscount {
    _couponDiscount = serverCouponDiscount;
}

-(CGFloat)getCouponDiscount
{
    return _couponDiscount;
}

-(NSString*)getQuoteString
{
    /*
    if (costEstimate < 100 ) {
        return [NSString stringWithFormat:@"%2.0f", [self getQuote]];
    } else {
        return [NSString stringWithFormat:@"%3.0f", [self getQuote]];
    }*/
    return [NSString stringWithFormat:@"%d", (int)_costQuote];
}

-(void)setTimeQuote:(CGFloat)serverTimeQuote
{
    _timeEstimate = serverTimeQuote;
}

-(CGFloat)getTimeQuote
{
    //return 1 + (bedroomCount*0.5) + (bathroomCount*0.5) + (cleaningRate == CLEANING_RATE_BASIC ? 0 : 1);
    return _timeEstimate;
}

-(NSString*)getTimeQuoteString
{
    return [NSString stringWithFormat:@"%.1f", [self getTimeQuote]];
}

-(NSString*)getCleanDescriptionString
{
    if (_cleaningRate == CLEANING_RATE_BASIC) {
        return @"Basic";
    } else {
        return @"Premium";
    }
}

-(BOOL)isPreferenceRetained
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:UD_PREF_SAVE];    // result reversed so default is YES
}

-(void)setPreferencesRetained:(BOOL) option
{
    [[NSUserDefaults standardUserDefaults] setBool:!option forKey:UD_PREF_SAVE];    // result reversed so default is YES
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end