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
+ (NSArray *)faceWithCustoming;
+ (void)downLoaFace;
+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight;

+ (NSMutableAttributedString *)customingEmojiWithAttributeString:(NSMutableAttributedString *)attributeString
                                                         message:(NSString *)message
                                                            font:(UIFont *)font
                                                      lineHeight:(CGFloat)lineHeight;

+ (NSMutableAttributedString *)customingFaceWithAttributeString:(NSMutableAttributedString *)attributeString
                                                        message:(NSString *)message
                                                           font:(UIFont *)font
                                                     lineHeight:(CGFloat)lineHeight
                                                       textView:(UITextView*)textView;

+ (NSMutableAttributedString *)customingImgageMD5WithAttributeString:(NSMutableAttributedString *)attributeString
                                                             message:(NSString *)message
                                                           notLoaded:(BOOL)notLoaded
                                                           count:(NSUInteger *)count
                                                            textView:(UITextView*)textView;

+ (NSMutableAttributedString *)customingImgageURLWithAttributeString:(NSMutableAttributedString *)attributeString
                                                             message:(NSString *)message
                                                               textView:(UITextView*)textView;
@end
