//
//  MUChatKeyboardMoreView.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/30.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUChatKeyboardMoreView : UIView
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic,copy) void (^itemByTaped)(NSUInteger currentTag);
@end
