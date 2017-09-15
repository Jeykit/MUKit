//
//  MUPaymentSuccessHUD.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUPaymentSuccessHUD.h"


#define kLineWidth        4.0f
#define kCircleDuriation  0.5f
#define kCheckDuration    0.2f
@implementation MUPaymentSuccessHUD{
     CALayer *_animationLayer;
    UILabel  *_tipsLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configuredUI];
    }
    return self;
}

+(MUPaymentSuccessHUD *)showIn:(UIView *)view{
    [self hideIn:view];
    MUPaymentSuccessHUD *hud = [[MUPaymentSuccessHUD alloc]initWithFrame:view.bounds];
    hud.backgroundColor     = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
    [hud startAnimation];
    [view addSubview:hud];
    return hud;
}
+(MUPaymentSuccessHUD *)hideIn:(UIView *)view{
    MUPaymentSuccessHUD *hud = nil;
    for (MUPaymentSuccessHUD *subView in view.subviews) {
        if ([subView isKindOfClass:[MUPaymentSuccessHUD class]]) {
            [subView stopAnimation];
            [subView removeFromSuperview];
            hud = subView;
        }
    }
    return hud;
}
-(void)stopAnimation{
    for (CALayer *layer in _animationLayer.sublayers) {
        [layer removeAllAnimations];
    }
}
-(void)startAnimation{
    [self circleAnimation];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * kCircleDuriation * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [self checkAnimation];
    });
}
- (void)configuredUI {
    _tipsLabel               = [[UILabel alloc]init];
    _tipsLabel.text          = @"支付成功";
    _tipsLabel.textColor     = [UIColor blackColor];
    _tipsLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [_tipsLabel sizeToFit];
    [self addSubview:_tipsLabel];
    
    _animationLayer          = [CALayer layer];
    _animationLayer.bounds   = CGRectMake(0, 0, 60, 60);
    _animationLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 24.);
    [self.layer addSublayer:_animationLayer];
    
    _tipsLabel.center        = CGPointMake(_animationLayer.position.x, _animationLayer.position.y + 30. + 24.);
}
//画圆
- (void)circleAnimation {
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame        = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor    =  [[UIColor clearColor] CGColor];
    circleLayer.strokeColor  = [UIColor blueColor].CGColor;
    circleLayer.lineWidth    = kLineWidth;
    circleLayer.lineCap      = kCALineCapRound;
    
    
    CGFloat lineWidth  = 5.0f;
    CGFloat radius     = _animationLayer.bounds.size.width/2.0f - lineWidth/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:circleLayer.position radius:radius startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:true];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration  = kCircleDuriation;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue   = @(1.0f);
    circleAnimation.delegate  = self;
    [circleAnimation setValue:@"circleAnimation" forKey:@"animationName"];
    [circleLayer addAnimation:circleAnimation forKey:nil];
}

//对号
- (void)checkAnimation {
    
    CGFloat a = _animationLayer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*2.7/10,a*5.4/10)];
    [path addLineToPoint:CGPointMake(a*4.5/10,a*7/10)];
    [path addLineToPoint:CGPointMake(a*7.8/10,a*3.8/10)];
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.path        = path.CGPath;
    checkLayer.fillColor   = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor blueColor].CGColor;
    checkLayer.lineWidth   = kLineWidth;
    checkLayer.lineCap     = kCALineCapRound;
    checkLayer.lineJoin    = kCALineJoinRound;
    [_animationLayer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration          = kCircleDuriation;
    checkAnimation.fromValue         = @(0.0f);
    checkAnimation.toValue           = @(1.0f);
    checkAnimation.delegate          = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
