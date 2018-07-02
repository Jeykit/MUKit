//
//  MUChatKeyboardFaceMenuView.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUChatKeyboardFaceMenuView.h"





@interface MUChatKeyboardFaceMenuView ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *sendButton;
@property(nonatomic,strong)UIButton *selectedBtn;
@end

@implementation MUChatKeyboardFaceMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupButton:[@"0x1f603" emoji] butonType:MUEmotionMenuButtonTypeEmoji];
        [self setupButton:@"Custom" butonType:MUEmotionMenuButtonTypeCustom];
    }
    return self;
}

- (void)setupButton:(NSString *)title butonType:(MUmotionMenuButtonType)type{
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    btn.tag                  = type; // 不要把0作为tag值
    
    [btn setBackgroundImage:[UIImage imageFromColorMu:[UIColor whiteColor]]forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageFromColorMu:[UIColor colorWithRed:241./255. green:241./255. blue:244./255. alpha:1.]] forState:UIControlStateSelected];
    if ([title isEqualToString:@"Custom"]) {
        [btn setImage:[UIImage imageNamed:@"[吓]"] forState:UIControlStateNormal];
    } else {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:26.5];
        btn.selected = YES;
        self.selectedBtn = btn;
    }
    [self.scrollView addSubview:btn];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count      = self.scrollView.subviews.count;
    //    CGFloat btnW          = self.width/(count+1);
    CGFloat btnW          = 60;
    self.scrollView.frame = CGRectMake(0, 0, self.width_Mu-btnW, self.height_Mu);
    self.sendButton.frame    = CGRectMake(self.width_Mu-btnW, 0, btnW, self.height_Mu);
    CGFloat btnH          = self.height_Mu;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = self.scrollView.subviews[i];
        btn.y_Mu                    = 0;
        btn.width_Mu                = (int)btnW;// 去除小缝隙
        btn.height_Mu               = btnH;
        btn.x_Mu                   = (int)btnW * i;
    }
}
#pragma mark---发送  menu 菜单的发送按钮----
- (void)sendBtnClicked:(UIButton *)sendBtn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MUEmotionDidSendNotification object:nil];
}

- (void)btnClicked:(UIButton *)button
{
    self.selectedBtn.selected = NO;
    button.selected           = YES;
    self.selectedBtn         = button;
    
    if (self.menuButtonByclicked) {
        self.menuButtonByclicked(button.tag);
    }
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setScrollsToTop:NO];
        [self addSubview:_scrollView];
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
    }
    return _scrollView;
}
- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton= [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_sendButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1.0]];
        [_sendButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self addSubview:_sendButton];
        [_sendButton addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
@end
