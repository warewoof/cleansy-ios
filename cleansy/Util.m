#import "Util.h"
#import <AudioToolbox/AudioServices.h>

@implementation Util


+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithImage:(UIImage*)image scaledAspectToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    float aspectRatio;
    if (image.size.width > image.size.height) {     // scale constraint width
        aspectRatio = image.size.width / image.size.height;
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.width / aspectRatio)];
    } else {    // scale constraint height
        aspectRatio = image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, newSize.height / aspectRatio, newSize.height)];
    }
    
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(CGSize)image:(UIImage *)image fitToSize:(CGSize)newSize {
    
    float aspectRatio;
    float fitWidth;
    float fitHeight;
    if (image.size.width > image.size.height) {     // scale constraint width
        aspectRatio = image.size.width / image.size.height;
        fitWidth = newSize.width;
        fitHeight = newSize.width / aspectRatio;
    } else {    // scale constraint height
        aspectRatio = image.size.height / image.size.width;
        fitWidth = newSize.height / aspectRatio;
        fitHeight = newSize.height;
    }
    
    return CGSizeMake(fitWidth, fitHeight);
    
}

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

+(NSString*)trimString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(NSString*)floatToPriceString:(CGFloat)floatVal
{
    return [NSString stringWithFormat:@"%d", (int)floatVal];
}

+(BOOL) NSStringIsValidZipcode:(NSString *)checkString
{
    if ([checkString length] != 5) {
        return NO;
    }
   
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([checkString rangeOfCharacterFromSet:notDigits].location == NSNotFound);
        
        //return [checkString rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound;
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(BOOL) NSStringIsValidPhone:(NSString *)checkString
{
    if ([checkString length] < 10) {
        return NO;
    }
    NSString *phoneRegex = @"[0-9\\-+.()]+";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:checkString];
}

+(void) PlayClickSound {

    SystemSoundID soundID;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"Tock2" ofType:@"aiff"];
    NSURL *pathURL = [NSURL fileURLWithPath: path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
