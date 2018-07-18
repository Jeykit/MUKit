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
@property (nonatomic,weak) UIView *transformedView;
@property (nonatomic,weak) UITableView *adjustView;
@property (nonatomic,assign ,readonly) CGFloat keyboardHeightMU;
@property (nonatomic,copy) void (^sendMessageCallback)(NSString *message);
- (void)autoAdjustContentOffsetY;

@property (nonatomic,copy) void (^moreViewItemByClicked)(NSUInteger currentTag);
@end
