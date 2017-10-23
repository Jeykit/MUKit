//
//  MUPopupLeftBarItem.m
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import "MUPopupLeftBarItem.h"

@implementation MUPopupLeftBarItem{
    UIControl *_customView;
    UIView    *_barView1;
    UIView    *_barView2;
}

-(instancetype)initWithTarget:(id)target action:(SEL)action{
    
    _customView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 18., 44.)];
    if (self = [super initWithCustomView:_customView]) {
        [_customView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        _barView1 = [self configuredView:_barView1];
        _barView2 = [self configuredView:_barView2];
        
        [_customView addSubview:_barView1];
        [_customView addSubview:_barView2];
    }
    return self;
}

-(UIView *)configuredView:(UIView *)view{
    view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:.4 alpha:1.];
//    view.backgroundColor = self.tintColor;
    view.userInteractionEnabled = NO;
    view.layer.allowsEdgeAntialiasing = YES;
    return view;
}

-(void)setType:(MUPopupLeftBarItemType)type{
    [self setType:type animated:NO];
}
-(void)setType:(MUPopupLeftBarItemType)type animated:(BOOL)animated{
    _type = type;
    if (animated) {
        
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:1. initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self updateLayout];
        } completion:nil];
    }else{
         [self updateLayout];
    }
}

- (void)updateLayout
{
    float barWidth, barHeight = 1.5, barX, bar1Y, bar2Y;
    switch (self.type) {
        case MUPopupLeftBarItemCross: {
            barWidth = _customView.frame.size.height * 2 / 5;
            barX = (_customView.frame.size.width - barWidth) / 2;
            bar1Y = (_customView.frame.size.height - barHeight) / 2;
            bar2Y = bar1Y;
        }
            break;
        case MUPopupLeftBarItemArrow: {
            barWidth = _customView.frame.size.height / 4;
            barX = (_customView.frame.size.width - barWidth) / 2 - barWidth / 2;
            bar1Y = (_customView.frame.size.height - barHeight) / 2 + barWidth / 2 * sin(M_PI_4);
            bar2Y = (_customView.frame.size.height - barHeight) / 2 - barWidth / 2 * sin(M_PI_4);
        }
            break;
        default:
            break;
    }
    _barView1.transform = CGAffineTransformIdentity;
    _barView2.transform = CGAffineTransformIdentity;
    
    _barView1.frame = CGRectMake(barX, bar1Y, barWidth, barHeight);
    _barView2.frame = CGRectMake(barX, bar2Y, barWidth, barHeight);
    
    _barView1.transform = CGAffineTransformMakeRotation(M_PI_4);
    _barView2.transform = CGAffineTransformMakeRotation(-M_PI_4);
}
- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    _barView1.backgroundColor = tintColor;
    _barView2.backgroundColor = tintColor;
}
@end
