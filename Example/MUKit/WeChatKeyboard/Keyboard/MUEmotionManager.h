//
//  MUEmotionManager.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUEmotionManager : NSObject
+(NSArray *)emojiEmotionWithURL:(NSString *)urlPath;
+(NSArray *)customEmotionWithURL:(NSString *)urlPath;
+(NSArray *)gifEmotionWithURL:(NSString *)urlPath;
+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight;
@end
