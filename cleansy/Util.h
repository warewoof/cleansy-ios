
#import <Foundation/Foundation.h>


@interface Util : NSObject

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+(UIImage*)imageWithImage:(UIImage*)image scaledAspectToSize:(CGSize)newSize;
+(CGSize)image:(UIImage*)image fitToSize:(CGSize)newSize;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSString*)trimString:(NSString*)string;
+(NSString*)floatToPriceString:(CGFloat)floatVal;
+(BOOL) NSStringIsValidZipcode:(NSString *)checkString;
+(BOOL) NSStringIsValidEmail:(NSString *)checkString;
+(BOOL) NSStringIsValidPhone:(NSString *)checkString;
+(void) PlayClickSound;
@end