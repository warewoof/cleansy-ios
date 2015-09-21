/*
 #import "HistoryManager.h"


#define HISTORY_OBJECT_0 @"historyKey1Object"
#define HISTORY_OBJECT_1 @"historyKey2Object"
#define HISTORY_OBJECT_2 @"historyKey3Object"
#define HISTORY_OBJECT_3 @"historyKey4Object"
#define HISTORY_OBJECT_4 @"historyKey0Object"
#define HISTORY_CURRENT_INDEX @"historyCurrentIndex"

@implementation HistoryManager



+ (void)addHistoryItem:(OrderManager *) order
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:[HistoryManager serializeObject:order] forKey:[HistoryManager getCurrentWriteIndexKey]];

        NSInteger index = [standardUserDefaults integerForKey:HISTORY_CURRENT_INDEX];
        [standardUserDefaults setInteger:(++index % 5) forKey:HISTORY_CURRENT_INDEX];   // increment write index key
        
        [standardUserDefaults synchronize];
    }
}


+ (NSMutableArray*)getHistoryList
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyList = [[NSMutableArray alloc] init];
    NSArray *keys;
    switch ([standardUserDefaults integerForKey:HISTORY_CURRENT_INDEX]) {
        case 0:
            keys = [NSArray arrayWithObjects: HISTORY_OBJECT_4, HISTORY_OBJECT_3, HISTORY_OBJECT_2, HISTORY_OBJECT_1, HISTORY_OBJECT_0, nil];
            break;
        case 1:
            keys = [NSArray arrayWithObjects: HISTORY_OBJECT_0, HISTORY_OBJECT_4, HISTORY_OBJECT_3, HISTORY_OBJECT_2, HISTORY_OBJECT_1, nil];
            break;
        case 2:
            keys = [NSArray arrayWithObjects: HISTORY_OBJECT_1, HISTORY_OBJECT_0, HISTORY_OBJECT_4, HISTORY_OBJECT_3, HISTORY_OBJECT_2, nil];
            break;
        case 3:
            keys = [NSArray arrayWithObjects: HISTORY_OBJECT_2, HISTORY_OBJECT_1, HISTORY_OBJECT_0, HISTORY_OBJECT_4, HISTORY_OBJECT_3, nil];
            break;
        case 4:
            keys = [NSArray arrayWithObjects: HISTORY_OBJECT_3, HISTORY_OBJECT_2, HISTORY_OBJECT_1, HISTORY_OBJECT_0, HISTORY_OBJECT_4, nil];
            break;
        default:
            break;
    }
    
    for (NSString *key in keys) {
        if ([standardUserDefaults objectForKey:key] != nil) {
            [historyList addObject:[HistoryManager inflateObject:[standardUserDefaults objectForKey:key]]];
        }
    }
    return historyList;
}

+ (NSString *)getCurrentWriteIndexKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [standardUserDefaults integerForKey:HISTORY_CURRENT_INDEX];
    
    switch (index) {
        case 0:
            return HISTORY_OBJECT_0;
            break;
        case 1:
            return HISTORY_OBJECT_1;
            break;
        case 2:
            return HISTORY_OBJECT_2;
            break;
        case 3:
            return HISTORY_OBJECT_3;
            break;
        case 4:
            return HISTORY_OBJECT_4;
            break;
        default:
            return HISTORY_OBJECT_1;
            break;
    }
}

+ (NSMutableArray *)serializeObject:(OrderManager *)order
{
    NSMutableArray *serialObj = [[NSMutableArray alloc] init];
    [serialObj insertObject:order.addressStreet1 atIndex:0];
    [serialObj insertObject:order.addressStreet2 atIndex:1];
    [serialObj insertObject:order.addressCity atIndex:2];
    [serialObj insertObject:order.addressState atIndex:3];
    [serialObj insertObject:order.addressZip atIndex:4];
    [serialObj insertObject:order.addressNote atIndex:5];
    [serialObj insertObject:order.customerPhone atIndex:6];
    [serialObj insertObject:order.scheduleDate atIndex:7];
    [serialObj insertObject:order.transactionEnd atIndex:8];
    [serialObj insertObject:[NSNumber numberWithInteger:order.bedroomCount] atIndex:9];
    [serialObj insertObject:[NSNumber numberWithInteger:order.bathroomCount] atIndex:10];
    [serialObj insertObject:[NSNumber numberWithInteger:order.cleaningRate] atIndex:11];
    [serialObj insertObject:order.finalPaymentDisplayed atIndex:12];
    
    return serialObj;
}

+ (OrderManager *)inflateObject:(NSMutableArray *) serialObj
{
    OrderManager *order = [[OrderManager alloc] init];
   // int i = 0;
    order.addressStreet1 = [serialObj objectAtIndex:0];
    order.addressStreet2 = [serialObj objectAtIndex:1];
    order.addressCity = [serialObj objectAtIndex:2];
    order.addressState = [serialObj objectAtIndex:3];
    order.addressZip = [serialObj objectAtIndex:4];
    order.addressNote = [serialObj objectAtIndex:5];
    order.customerPhone = [serialObj objectAtIndex:6];
    order.scheduleDate = [serialObj objectAtIndex:7];
    order.transactionEnd = [serialObj objectAtIndex:8];
    order.bedroomCount = [[serialObj objectAtIndex:9] integerValue];
    order.bathroomCount = [[serialObj objectAtIndex:10] integerValue];
    order.cleaningRate = [[serialObj objectAtIndex:11] integerValue];
    order.finalPaymentDisplayed = [serialObj objectAtIndex:12];
    
    return order;
}


@end
 */
