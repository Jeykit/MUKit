//
//  UIImage+MUColor.h
//  Pods
//
//  Created by Jekity on 2017/9/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MUGradientType) {
    MUGradientTypeTopToBottom      = 0,//从上到小
    MUGradientTypeLeftToRight      = 1,//从左到右
    MUGradientTypeUpleftToLowright = 2,//左上到右下
    MUGradientTypeUprightToLowleft = 3,//右上到左下
};
@interface UIImage (MUColor)
+ (UIImage *)imageFromGradientColor:(NSArray*)colors gradientType:(MUGradientType)gradientType imageSize:(CGSize)imageSize;
+ (UIImage *)imageFromColor:(UIColor*)color;
+ (BOOL)imageEqualToImage:(UIImage*)image anotherImage:(UIImage *)anotherImage;
@end
