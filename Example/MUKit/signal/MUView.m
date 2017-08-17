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
//Click_signal(infoView){
//     NSLog(@"子视图------333333----%@",NSStringFromClass([object class]));
//    UIButton *view = (UIButton *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"%@---------%@-------%@",NSStringFromClass([object class]),indexPath,NSStringFromClass([view.viewController class]));
//}
@end
