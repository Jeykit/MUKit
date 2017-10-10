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
@end
