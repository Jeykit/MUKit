//
//  MUChatKeyboardFaceMenuView.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MUmotionMenuButtonType) {
    MUEmotionMenuButtonTypeEmoji = 100,
    MUEmotionMenuButtonTypeCustom,
    MUEmotionMenuButtonTypeGif
};
@interface MUChatKeyboardFaceMenuView : UIView

@property (nonatomic,copy) void (^menuButtonByclicked)(MUmotionMenuButtonType type);
@end
