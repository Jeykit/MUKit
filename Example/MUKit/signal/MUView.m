//
//  MUView.m
//  elmsc
//
//  Created by zeng ping on 2017/7/6.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUView.h"

@interface MUView()
@property (nonatomic ,strong)UIView *infoView;
@end
@implementation MUView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _infoView = [[UIView alloc]initWithFrame:frame];
        _infoView.backgroundColor = [UIColor redColor];
        [self addSubview:_infoView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
Click_signal(infoView){//如果属性所在的视图实现了信号方法，则会拦截cell和控制器的信号
    NSLog(@"我是子视图的信号，控制器和cell的信号被我拦截了----------%@",NSStringFromClass([object class]));
    UIButton *view = (UIButton *)object;
    NSIndexPath *indexPath = view.indexPath;//如果是cell上的子视图则会有indexPath
    NSLog(@"%@---------%@-------%@",NSStringFromClass([object class]),indexPath,NSStringFromClass([view.viewController class]));
}
@end
