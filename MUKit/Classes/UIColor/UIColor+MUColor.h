//
//  UIColor+MUColor.h
//  Pods
//
//  Created by Jekity on 2017/9/15.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (MUColor)
+ (UIColor*) colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *)colorWithMixing:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;
+ (BOOL) colorEqualToColorMu:(UIColor*)color anotherColor:(UIColor*)anotherColor;
+ (NSString *)hexStringFromColor:(UIColor *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;
@end
