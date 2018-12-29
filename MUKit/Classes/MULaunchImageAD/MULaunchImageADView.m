//
//  MULaunchImageADView.m
//  AFNetworking
//
//  Created by Jekity on 2018/12/29.
//

#import "MULaunchImageADView.h"

@implementation MULaunchImageADView{
    
     NSTimer *countDownTimer;
    BOOL _isClicked;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _ADTime = 6;
        _isClicked = NO;
        
        __weak typeof(self)weskSelf = self;
        _carouselView = [[MUCarouselView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) configured:^(UIImageView *imageView, NSUInteger index, id model) {
            __strong typeof(weskSelf)self = weskSelf;
            if (self.ADConfigured) {
                self.ADConfigured(imageView, index, model);
            }
            
        }];
        [self addSubview:_carouselView];
        
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(CGRectGetWidth(frame) - 60, [UIApplication sharedApplication].statusBarFrame.size.height + 5., 60, 30);
        [_skipButton addTarget:self action:@selector(skipButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_skipButton];
        
         countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    return self;
}
- (void)onTimer {
    if (_ADTime == 0) {
        [countDownTimer invalidate];
        countDownTimer = nil;
        [self startcloseAnimation];
    }else{
        [self.skipButton setTitle:[NSString stringWithFormat:@"%@s | 跳过",@(_ADTime--)] forState:UIControlStateNormal];
        [self.skipButton sizeToFit];
        CGRect frame = self.skipButton.frame;
        frame.size.width += 10;
        frame.origin.x = CGRectGetWidth(self.frame) - frame.size.width - 10;
        self.skipButton.frame = frame;
        [self bringSubviewToFront:self.skipButton];
    }
}

#pragma mark - 开启关闭动画
- (void)startcloseAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.3];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnimation.duration
                                     target:self
                                   selector:@selector(closeAddImgAnimation)
                                   userInfo:nil
                                    repeats:NO];
}
#pragma mark - 关闭动画完成时处理事件
-(void)closeAddImgAnimation
{
    [countDownTimer invalidate];
    countDownTimer = nil;
    
    if (self.ADCallbackBlock) {
        self.ADCallbackBlock(_isClicked);
    }
    self.hidden = YES;
    [self removeFromSuperview];
}
- (void)skipButtonClick{
    
    [countDownTimer invalidate];
    countDownTimer = nil;
    _isClicked = YES;
    [self startcloseAnimation];
}
@end
