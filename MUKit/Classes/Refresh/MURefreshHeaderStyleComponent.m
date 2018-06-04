//
//  MURefreshHeaderStyleComponent.m
//  MUKit
//
//  Created by Jekity on 2018/6/4.
//

#import "MURefreshHeaderStyleComponent.h"


@interface MURefreshHeaderStyleComponent()

@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (strong, nonatomic) MUReplicatorLayer * replicatorLayer;
@end
@implementation MURefreshHeaderStyleComponent

- (void)setupProperties{
    [super setupProperties];
    self.animationStyle = self.replicatorLayer.animationStyle;
    [self.layer addSublayer:self.replicatorLayer];
    [self addSubview:self.indicator];
}
- (void)setAnimationStyle:(MUReplicatorLayerAnimationStyle)animationStyle{
    if (_animationStyle != animationStyle) {
        _animationStyle = animationStyle;
        self.replicatorLayer.animationStyle = animationStyle;
        [self setNeedsLayout];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (self.animationStyle) {
        case MUReplicatorLayerAnimationStyleAllen:
        case MUReplicatorLayerAnimationStyleDot:
        case MUReplicatorLayerAnimationStyleWoody:
        case MUReplicatorLayerAnimationStyleCircle:
        case MUReplicatorLayerAnimationStyleArc:
        case MUReplicatorLayerAnimationStyleTriangle:
            self.replicatorLayer.frame = CGRectMake(0, 0, self.width_Mu, self.height_Mu);
            self.replicatorLayer.indicatorShapeLayer.backgroundColor = [UIColor purpleColor].CGColor;
            [self.indicator removeFromSuperview];
            break;
         case MUReplicatorLayerAnimationStyleNone:
            self.indicator.center = CGPointMake(self.width_Mu/2., self.height_Mu/2.);
            [self.replicatorLayer removeFromSuperlayer];
            break;
        default:
            self.indicator.center = CGPointMake(self.width_Mu/2., self.height_Mu/2.);
            [self.replicatorLayer removeFromSuperlayer];
            break;
    }
}
- (void)kafkaDidScrollWithProgress:(CGFloat)progress max:(const CGFloat)max{
#define kOffset 0.7
    if (progress >= 0.8) {
        progress = (progress-kOffset)/(max - kOffset);
    }
    switch (self.animationStyle) {
        case MUReplicatorLayerAnimationStyleWoody:{
            break;
        }
        case MUReplicatorLayerAnimationStyleAllen:{
            
            break;
        }
        case MUReplicatorLayerAnimationStyleCircle:{
            
            break;
        }
        case MUReplicatorLayerAnimationStyleDot:{
            
            break;
        }
        case MUReplicatorLayerAnimationStyleArc:{
            self.replicatorLayer.indicatorShapeLayer.strokeEnd = progress;
            break;
        }
        case MUReplicatorLayerAnimationStyleTriangle:{
            
            break;
        }
            default:
            break;
    }
}

- (void)MURefreshStateDidChange:(MURefreshingState)state{
    [super MURefreshStateDidChange:state];
    switch (state) {
        case MURefreshStateNone:
        case MURefreshStateScrolling:break;
        case MURefreshStateReady:{
            self.replicatorLayer.opacity = 1.;
            break;
        }
        case MURefreshStateRefreshing:{
            [self.indicator startAnimating];
            [self.replicatorLayer startAnimating];
            break;
        }
        case MURefreshStateWillEndRefresh:{
            [self.indicator stopAnimating];
            [self.replicatorLayer stopAnimating];
            break;
        }
    }
}
- (MUReplicatorLayer *)replicatorLayer{
    if (!_replicatorLayer) {
        _replicatorLayer = [MUReplicatorLayer layer];
    }
    return _replicatorLayer;
}

#pragma mark - getter
- (UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = NO;
    }
    return _indicator;
}
@end
