//
//  MUTextScroll.m
//  ZPApp
//
//  Created by Jekity on 2018/8/9.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUTextScroll.h"
#import "MUTextScrollView.h"

@interface MUTextScroll ()
@property (nonatomic,strong) MUTextScrollView *textView1;
@property (nonatomic,strong) MUTextScrollView *textView2;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *contentView1;
@property (nonatomic,strong) UIView *contentView2;
@property (nonatomic,assign) CGRect conentRect;
@end
@implementation MUTextScroll

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _conentRect = frame;
        self.backgroundColor = [UIColor clearColor];
        [self setupContent];
    }
    return self;
}
//初始化
- (void)setupContent{
    [self addSubview:self.imageView];
    [self addSubview:self.contentView1];
    [self addSubview:self.contentView2];
    
    
    //初始化文字轮播
    [self.contentView1 addSubview:self.textView1];
    [self.contentView2 addSubview:self.textView2];
    
}
- (UIImageView *)imageView{
    if (!_imageView) {
       
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 66., _conentRect.size.height)];
        _imageView.image = UIImageNamed(@"zptt");
    }
    return _imageView;
}
- (UIView *)contentView1{
    if (!_contentView1) {
        CGFloat x = CGRectGetMaxX(_imageView.frame)+10.;
        _contentView1 = [[UIView alloc]initWithFrame:CGRectMake(x, 0, CGRectGetWidth(_conentRect) - x, CGRectGetHeight(_conentRect)/2.)];
//        _contentView1.backgroundColor = [UIColor  redColor];
    }
    return _contentView1;
}

- (UIView *)contentView2{
    if (!_contentView2) {
        CGFloat x = CGRectGetMaxX(_imageView.frame)+10.;
        CGFloat y = CGRectGetHeight(_conentRect)/2.;
        _contentView2 = [[UIView alloc]initWithFrame:CGRectMake(x, y, CGRectGetWidth(_conentRect) - x, y)];
//        _contentView2.backgroundColor = [UIColor  blueColor];
    }
    return _contentView2;
}

- (MUTextScrollView *)textView1{
    if (!_textView1) {
        _textView1 = [[MUTextScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView1.frame), CGRectGetHeight(_contentView1.frame))];
    }
    return _textView1;
}

- (MUTextScrollView *)textView2{
    if (!_textView2) {
           _textView2 = [[MUTextScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_contentView1.frame), CGRectGetHeight(_contentView1.frame))];
    }
    return _textView2;
}
- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    if (titleArray.count == 0) {
        return;
    }
    NSUInteger count = titleArray.count/2;
    NSArray *subArray = [titleArray subarrayWithRange:NSMakeRange(0, count)];
    
    NSArray *subArray1 = [titleArray subarrayWithRange:NSMakeRange(count, titleArray.count - 1 - count)];
    self.textView1.tittleAray = subArray;
    self.textView2.tittleAray = subArray1;
}
@end
