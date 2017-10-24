//
//  MUNavigationBackItem.m
//  AFNetworking
//
//  Created by Jekity on 2017/10/24.
//

#import "MUNavigationBackItem.h"

@implementation MUNavigationBackItem{
    UIView    *_customView;
    UIView    *_barView1;
    UIView    *_barView2;
}

-(instancetype)initWithCustomView:(UIView *)customView{
    if (self = [super initWithCustomView:customView]) {
        _customView = customView;
        _barView1 = [self configuredView:_barView1];
        _barView2 = [self configuredView:_barView2];
        
        [customView addSubview:_barView1];
        [customView addSubview:_barView2];
        
        [self updateLayout];
    }
    return self;
}
+(instancetype)sharedInstanced{
    
    static __weak MUNavigationBackItem * instance;
    MUNavigationBackItem * strongInstance = instance;
    @synchronized (self) {
        if (strongInstance == nil) {
            UIView *_customView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 18., 44.)];
            strongInstance = [[[self class]alloc]initWithCustomView:_customView];
            instance       = strongInstance;
        }
    }
    return strongInstance;
}
-(UIView *)configuredView:(UIView *)view{
    view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:.4 alpha:1.];
    //    view.backgroundColor = self.tintColor;
    view.userInteractionEnabled = NO;
    view.layer.allowsEdgeAntialiasing = YES;
    return view;
}



- (void)updateLayout
{
    float barWidth, barHeight = 1.5, barX, bar1Y, bar2Y;
    
    barWidth = _customView.frame.size.height / 4;
    barX = (_customView.frame.size.width - barWidth) / 2 - barWidth / 2;
    bar1Y = (_customView.frame.size.height - barHeight) / 2 + barWidth / 2 * sin(M_PI_4);
    bar2Y = (_customView.frame.size.height - barHeight) / 2 - barWidth / 2 * sin(M_PI_4);
    
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
