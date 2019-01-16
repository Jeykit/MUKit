//
//  UITagView.m
//  ZPApp
//
//  Created by Jekity on 2018/8/14.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUTagView.h"

@interface MUTagView ()
@property (nonatomic,assign) CGRect contentRect;
@property (nonatomic,strong) NSArray *innerArray;


@end
@implementation MUTagView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _margain    = 6.;
        _itemHeight = 16;
        _contentRect  = frame;
        _maxNumberOfLine = 0;
    }
    return self;
}
- (void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    if (modelArray.count == 0)return;
    _innerArray = [modelArray copy];
    [self setupLayoutViews];
    
}
-(void)setupLayoutViews{
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (NSUInteger i = 0; i < self.innerArray.count; i++) {
        
        UILabel *label = [self labelWithIndex:i model:self.innerArray[i]];
        if (!label) {
            continue;
        }
        CGFloat width = self.itemWidth > 0?self.itemWidth:label.frame.size.width + _margain;
        label.tag = i;
        if (x + width + 12 > _contentRect.size.width) {
            y += (_itemHeight + _margain);//换行
            x = 0; //0位置开始
            NSUInteger lines = y/(_itemHeight + _margain);
            if (self.maxNumberOfLine > 0 && lines > (self.maxNumberOfLine-1) ) {
                y -= (_itemHeight + _margain);//换行
                break ;
            }
        }
        
        label.frame = CGRectMake(x, y, width, _itemHeight);
        [self addSubview:label];
        x += width + _margain;//宽度+间隙
    }
    if (self.innerArray.count>0) {
        _needHeight = y+_itemHeight;
    }
    CGRect frame = self.frame;
    frame.size.height = _needHeight;
    self.frame = frame;
    
}


- (UILabel *)labelWithIndex:(NSUInteger)index model:(id)model{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.cornerRadius = 3;
    label.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10];
    
    if ([model isKindOfClass:[NSString class]]) {
        NSString *str = model;
        if (str.length > 0) {
            label.text = model;
        }else{
            return nil;
        }
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapedLabel:)];
    [label addGestureRecognizer:tapGesture];
    if (self.configured) {
        self.configured(label, index, model);
    }
    [label sizeToFit];
    return label;
}

- (void)tapedLabel:(UITapGestureRecognizer *)gesture{
    if (self.TapedLabel) {
        UILabel *label = (UILabel *)gesture.view;
        self.TapedLabel(label, label.tag ,self.innerArray[label.tag]);
    }
}

@end
