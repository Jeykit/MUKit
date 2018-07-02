//
//  MUChatKeyboardView.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MUChatKeyboardView : UIView

//是否显示键盘
@property (nonatomic,assign ,getter=isShowKeyboard) BOOL showKeyboard;

@property (nonatomic,copy) void (^sendMessageCallback)(NSString *message);

@property (nonatomic,copy) void (^changedFrameCallback)(CGRect frame);
@end
