//
//  MUSwitchView.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUSwitchView.h"
#import "MUSinglePaymentView.h"

@interface MUSwitchView()
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, assign)NSUInteger enableCount;
@property(nonatomic, strong)MUSinglePaymentView *leftView;
@property(nonatomic, strong)MUSinglePaymentView *rightView;
@end
@implementation MUSwitchView
-(instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count{
    
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.contentSize = CGSizeMake(frame.size.width * 2., 0);
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled                  = YES;
        _enableCount = count;
        [self addSubview:_scrollView];
    }
    return self;
}
-(void)setFirstModelArray:(NSArray *)firstModelArray{
    _firstModelArray = firstModelArray;
    if (!_leftView) {
        _leftView = [[MUSinglePaymentView alloc]initWithFrame:self.bounds data:firstModelArray];
        [_scrollView addSubview:_leftView];
    }
    
}

-(void)setSecondModelArray:(NSArray *)secondModelArray{
    _secondModelArray = secondModelArray;
    if (!_rightView) {
        _rightView = [[MUSinglePaymentView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) data:secondModelArray];
        [_scrollView addSubview:_rightView];
    }
    
}
-(void)setFirstRenderBlock:(void (^)(UITableViewCell *, NSIndexPath *, id))firstRenderBlock{
    _firstRenderBlock  =firstRenderBlock;
    if (self.leftView) {
        _leftView.renderBlock = firstRenderBlock;
    }
}
-(void)setFirstSelectedBlock:(void (^)(UITableViewCell *, NSIndexPath *, id))firstSelectedBlock{
    _firstSelectedBlock = firstSelectedBlock;
    if (_leftView) {
        _leftView.selectedBlock = firstSelectedBlock;
    }
}
-(void)setSecondRenderBlock:(void (^)(UITableViewCell *, NSIndexPath *, id))secondRenderBlock{
    _secondRenderBlock = secondRenderBlock;
    if (_rightView) {
        _rightView.renderBlock = secondRenderBlock;
    }
}
-(void)setSecondSelectedBlock:(void (^)(UITableViewCell *, NSIndexPath *, id))secondSelectedBlock{
    _secondSelectedBlock = secondSelectedBlock;
    if (_rightView) {
        _rightView.selectedBlock = secondSelectedBlock;
    }
}

-(void)goForward{
    
    if (self.scrollView.contentOffset.x != self.frame.size.width) {
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width , 0) animated:YES];
    }
}
-(void)back{
    if (self.scrollView.contentOffset.x != 0) {
        [self.scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    }
}
@end
