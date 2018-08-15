//
//  UITagView.m
//  ZPApp
//
//  Created by Jekity on 2018/8/14.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "UITagView.h"

@interface UITagView ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic,assign) CGRect contentRect;
@property (nonatomic,assign) CGFloat itemHeight;
@end
@implementation UITagView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _contentRect  =frame;
        _itemHeight = 16.;
    }
    return self;
}
-(void)setupLayoutViews{
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < self.titles.count; i++) {
        
        UILabel *label = [self labelWithTitle:self.titles[i]];
        CGFloat width = label.frame.size.width + 4.;
        
        if (x + width + 15 > _contentRect.size.width) {
            y += (_itemHeight + 4);//换行
            x = 0; //15位置开始
        }
        
        label.frame = CGRectMake(x, y, width, _itemHeight);
        [self addSubview:label];
        x += width + 4.;//宽度+间隙
    }
    _needHeight = y+_itemHeight;
}


- (UILabel *)labelWithTitle:(NSString *)title{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    [label sizeToFit];
    label.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    label.textColor = [UIColor lightGrayColor];
//    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.cornerRadius = 3;
//    label.layer.borderWidth = 0.5;
    label.layer.masksToBounds = YES;
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)setTextArray:(NSArray *)textArray{
    _textArray = textArray;
    if (textArray.count == 0) {
        return;
    }
    _titles = textArray;
    [self setupLayoutViews];
}

@end
