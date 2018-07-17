//
//  MUChatKeyboardMoreViewItem.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/30.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUChatKeyboardMoreViewItem : UIView
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;

- (void)addTarget:(id)target action:(SEL)action
 forControlEvents:(UIControlEvents)controlEvents;

/**
 *  创建一个ICChatBoxMoreViewItem
 *
 *  @param title     item的标题
 *  @param imageName item的图片
 *
 *  @return item
 */
+ (MUChatKeyboardMoreViewItem *)createChatBoxMoreItemWithTitle:(NSString *)title
                                                imageName:(NSString *)imageName;
@end
