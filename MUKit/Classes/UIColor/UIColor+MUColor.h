//
//  UIColor+MUColor.h
//  Pods
//
//  Created by Jekity on 2017/9/15.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (MUColor)


// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor*) colorWithHex:(long)hexColor;


// 透明度固定为1，以0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;


// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
/**
 @param color 以#开头的16进制颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color;

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
/**
 @param color 以#开头的16进制颜色
 @param alpha 透明度 0-1
 */
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;



/**
 颜色混合
 @param fromColor 原色
 @param toColor 添加的颜色
 @param percent 百分比
 */
+ (UIColor *)colorWithMixing:(UIColor *)fromColor
                     toColor:(UIColor *)toColor
                     percent:(CGFloat)percent;


//判断两个颜色是否相等
+ (BOOL) colorEqualToColorMu:(UIColor*)color anotherColor:(UIColor*)anotherColor;

//获取 以#开头的16进制颜色 字符串
+ (NSString *)hexStringFromColor:(UIColor *)color;
@end
