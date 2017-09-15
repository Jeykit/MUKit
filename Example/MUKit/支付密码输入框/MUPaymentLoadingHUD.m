//
//  MUPaymentLoadingHUD.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUPaymentLoadingHUD.h"


#define kLineWidth        4.0f
@implementation MUPaymentLoadingHUD{
    CADisplayLink *_link;
    CAShapeLayer *_animationLayer;
    
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _progress;
    
    UILabel  *_tipsLabel;
}

+(MUPaymentLoadingHUD*)showIn:(UIView*)view{
    [self hideIn:view];
    MUPaymentLoadingHUD *hud = [[MUPaymentLoadingHUD alloc] initWithFrame:view.bounds];
    hud.backgroundColor     = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
    [hud startAnimation];
    [view addSubview:hud];
    [view bringSubviewToFront:hud];
    return hud;
}

+(MUPaymentLoadingHUD *)hideIn:(UIView *)view{
    MUPaymentLoadingHUD *hud = nil;
    for (MUPaymentLoadingHUD *subView in view.subviews) {
        if ([subView isKindOfClass:[MUPaymentLoadingHUD class]]) {
            [subView stopAnimation];
            [subView removeFromSuperview];
            hud = subView;
        }
    }
    return hud;
}
-(void)startAnimation{
    _link.paused = false;
}
-(void)stopAnimation{
    _link.paused = true;
    _progress = 0;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configuredUI];
    }
    return self;
}

-(void)configuredUI{
    _tipsLabel               = [[UILabel alloc]init];
    _tipsLabel.text          = @"正在支付中...";
    _tipsLabel.textColor     = [UIColor blackColor];
    _tipsLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [_tipsLabel sizeToFit];
    [self addSubview:_tipsLabel];
    
    _animationLayer              = [CAShapeLayer layer];
    _animationLayer.bounds       = CGRectMake(0, 0, 60, 60);
    _animationLayer.position     = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0 - 24.);
    _animationLayer.fillColor    = [UIColor clearColor].CGColor;
    _animationLayer.strokeColor  = [UIColor blueColor].CGColor;
    _animationLayer.lineWidth    = kLineWidth;
    _animationLayer.lineCap      = kCALineCapRound;
    [self.layer addSublayer:_animationLayer];
    
     _tipsLabel.center        = CGPointMake(_animationLayer.position.x, _animationLayer.position.y + 30. + 24.);
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _link.paused = true;
    
}

-(void)displayLinkAction{
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}

-(void)updateAnimationLayer{
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _animationLayer.bounds.size.width/2.0f - kLineWidth/2.0f;
    CGFloat centerX = _animationLayer.bounds.size.width/2.0f;
    CGFloat centerY = _animationLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    _animationLayer.path = path.CGPath;
}

-(CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
}
@end
