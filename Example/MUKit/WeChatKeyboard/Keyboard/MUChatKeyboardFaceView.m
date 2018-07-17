//
//  MUChatKeyboardFaceView.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUChatKeyboardFaceView.h"
#import "MUEmotionListView.h"
#import "MUChatKeyboardFaceMenuView.h"
#import "MUEmotionManager.h"

@interface MUChatKeyboardFaceView()

@property(nonatomic,weak)MUEmotionListView *showingListView;
@property(nonatomic,strong)MUEmotionListView *emojiListView;
@property(nonatomic,strong)MUEmotionListView *customListView;
@property(nonatomic,strong)MUEmotionListView *gifListView;
@property(nonatomic,strong)MUChatKeyboardFaceMenuView *menuView;

@end

@implementation MUChatKeyboardFaceView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.menuView = [[MUChatKeyboardFaceMenuView alloc]init];
        [self addSubview:self.menuView];
        self.showingListView = self.emojiListView;
        [self addSubview:self.showingListView];
        self.backgroundColor =[UIColor grayColor];
        
        
        [self resultBlock];
        
    }
    return self;
}

- (void) resultBlock{
    weakify(self)
    self.menuView.menuButtonByclicked = ^(MUmotionMenuButtonType type) {
        normalize(self)
        [self.showingListView removeFromSuperview];
        switch (type) {
            case MUEmotionMenuButtonTypeEmoji:
                [self addSubview:self.emojiListView];
                break;
            case MUEmotionMenuButtonTypeCustom:
                [self addSubview:self.customListView];
                break;
            case MUEmotionMenuButtonTypeGif:
                [self addSubview:self.gifListView];
                break;
            default:
                break;
        }
        self.showingListView = [self.subviews lastObject];
        [self setNeedsLayout];
    };
    
  
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.menuView.width_Mu = self.width_Mu;
    self.menuView.height_Mu = 36.;
    self.menuView.x_Mu = 0;
    self.menuView.y_Mu = self.height_Mu - self.menuView.height_Mu;
    
    self.showingListView.x_Mu = self.showingListView.y_Mu = 0;
    self.showingListView.width_Mu = self.width_Mu;
    self.showingListView.height_Mu = self.menuView.y_Mu;
    
}
-(MUEmotionListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView =[[MUEmotionListView alloc]init];
        _emojiListView.emotions  = [MUEmotionManager emojiEmotionWithURL:nil];
    }
    return _emojiListView;
}
-(MUEmotionListView *)customListView{
    if (!_customListView) {
        _customListView =[[MUEmotionListView alloc]init];
//        _customListView.emotions = [MUEmotionManager customEmotionWithURL:nil];
        _customListView.emotions = [MUEmotionManager faceWithCustoming];
        
        
    }
    return _customListView;
}
-(MUEmotionListView *)gifListView{
    if (!_gifListView) {
        _gifListView =[[MUEmotionListView alloc]init];
    }
    return _gifListView;
}


@end
