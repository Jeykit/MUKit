//
//  MUEmotionPageView.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUEmotionPageView.h"
#import "MUEmotionModel.h"





@interface MUEmotionPageView ()
@property(nonatomic,strong)UIButton *deleteBtn;
@end

@implementation MUEmotionPageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"emotion_delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
    return self;
}
#pragma mark--每一页的最后一个按钮---
-(void)deleteBtn:(UIButton *)button
{
    //可以发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[MUSelectEmotionKey]  = self.emotions[button.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:MUEmotionDidDeleteNotification object:nil userInfo:userInfo];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MUEmotionDidDeleteNotification object:nil];// 通知出去
    
}
-(void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    NSUInteger count = emotions.count;
    for (int i =0; i<count; i++) {
        UIButton *button =[[UIButton alloc]init];
        button.titleLabel.font =[UIFont systemFontOfSize:32.0];
        button.adjustsImageWhenHighlighted = NO;
        [self addSubview:button];
        button.tag = i;
        MUEmotionModel *model = emotions[i];
        if (model.code) {
            [button setTitle:model.code.emoji forState:UIControlStateNormal];
        } else if (model.face_name) {
            [button setImage:[UIImage imageNamed:model.face_name] forState:UIControlStateNormal];
        }

        [button addTarget:self action:@selector(emotionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat inset            = 15;
    NSUInteger count         = self.emotions.count;
    CGFloat btnW             = (self.width_Mu - 2*inset)/MUEMotionMaxCols;
    CGFloat btnH             = (self.height_Mu - 2*inset)/MUEmotionMaxRows;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = self.subviews[i + 1];//因为已经加了一个deleteBtn了
        btn.width_Mu            = btnW;
        btn.height_Mu           = btnH;
        btn.x_Mu                = inset + (i % MUEMotionMaxCols)*btnW;
        btn.y_Mu                = inset + (i / MUEMotionMaxCols)*btnH;
    }
    self.deleteBtn.width_Mu     = btnW;
    self.deleteBtn.height_Mu    = btnH;
    self.deleteBtn.x_Mu         = inset + (count%MUEMotionMaxCols)*btnW;
    self.deleteBtn.y_Mu         = inset + (count/MUEMotionMaxCols)*btnH;
}
#pragma mark---表情按钮的点击方法---
- (void)emotionBtnClicked:(UIButton *)button
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[MUSelectEmotionKey]  = self.emotions[button.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:MUEmotionDidSelectNotification object:nil userInfo:userInfo];
   
}
@end
