//
//  MUReplicatorLayer.m
//  AFNetworking
//
//  Created by Jekity on 2018/6/4.
//

#import "MUReplicatorLayer.h"
#import "UIView+MUNormal.h"
#import <objc/runtime.h>

static char kLeftDotKey;
static char kRightDotKey;
@implementation MUReplicatorLayer
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupProperties];
    }
    return self;
}

- (void)setupProperties{
    [self addSublayer:self.replicatorLayer];
    [self.replicatorLayer addSublayer:self.indicatorShapeLayer];
    self.animationStyle = MUReplicatorLayerAnimationStyleNone;
    self.indicatorShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.indicatorShapeLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
}

- (void)setAnimationStyle:(MUReplicatorLayerAnimationStyle)animationStyle{
    if (_animationStyle != animationStyle) {
        _animationStyle = animationStyle;
        [self setNeedsLayout];
    }
}

- (void)layoutSublayers{
    [super layoutSublayers];
    
    self.replicatorLayer.frame = self.bounds;
    
    CGFloat padding = 10.;
    switch (self.animationStyle) {
        case MUReplicatorLayerAnimationStyleWoody:{
            CGFloat h = self.heightMu / 3.0;
            CGFloat w = 3.0;
            CGFloat x = self.widthMu / 2. - (2.5 * w + padding * 2);
            CGFloat y = self.heightMu/2.-h/2.0;
            self.indicatorShapeLayer.frame = CGRectMake(x, y, w, h);
            self.indicatorShapeLayer.cornerRadius = 1.;
            self.indicatorShapeLayer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
            
            self.replicatorLayer.instanceCount = 5;
            self.replicatorLayer.instanceDelay = 0.3/5;
            self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(padding, 0.0, 0.0);
            self.replicatorLayer.instanceBlueOffset = -0.01;
            self.replicatorLayer.instanceGreenOffset = -0.01;
            break;
        }
        case MUReplicatorLayerAnimationStyleAllen:{
            CGFloat h = self.heightMu / 3.0;
            CGFloat w = 3.0;
            CGFloat x = self.widthMu / 2. - (2.5 * w + padding * 2);
            CGFloat y = self.heightMu/2.-h/2.0;
            self.indicatorShapeLayer.frame = CGRectMake(x, y, w, h);
            self.indicatorShapeLayer.cornerRadius = 1.;
            
            self.replicatorLayer.instanceCount = 5;
            self.replicatorLayer.instanceDelay = 0.3/5;
            self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(padding, 0.0, 0.0);
            self.replicatorLayer.instanceBlueOffset = -0.01;
            self.replicatorLayer.instanceGreenOffset = -0.01;
            break;
        }
        case MUReplicatorLayerAnimationStyleCircle:{
            self.indicatorShapeLayer.frame = CGRectMake(self.widthMu/2. - 2., 10, 4., 4.);
            self.indicatorShapeLayer.cornerRadius = 2.;
            self.indicatorShapeLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
            
            self.replicatorLayer.instanceCount = 12;
            self.replicatorLayer.instanceDelay = 0.8/12;
            CGFloat angle = (2 * M_PI)/self.replicatorLayer.instanceCount;
            self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 0.1);
            self.replicatorLayer.instanceBlueOffset = -0.01;
            self.replicatorLayer.instanceGreenOffset = -0.01;
            break;
        }
        case MUReplicatorLayerAnimationStyleDot:{
            CGFloat innerPadding = 30.;
            CGFloat h = 4.0;;
            CGFloat w = 4.0;
            CGFloat x = self.widthMu / 2. - (1.5 * w + innerPadding * 1);
            CGFloat y = self.heightMu/2.- h/2.0;
            self.indicatorShapeLayer.frame = CGRectMake(x, y, w, h);
            self.indicatorShapeLayer.cornerRadius = 2.;
            
            self.replicatorLayer.instanceCount = 3;
            self.replicatorLayer.instanceDelay = 0.5/3;
            self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(innerPadding, 0.0, 0.0);
            break;
        }
        case MUReplicatorLayerAnimationStyleArc:{
            CGFloat h = self.heightMu - 10.;;
            CGFloat w = h;
            CGFloat x = self.widthMu/2. - 0.5 * w;
            CGFloat y = self.heightMu/2.- h/2.0;
            self.indicatorShapeLayer.frame = CGRectMake(x, y, w, h);
            self.indicatorShapeLayer.fillColor = [UIColor clearColor].CGColor;
            self.indicatorShapeLayer.lineWidth = 3.;
            self.indicatorShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
            UIBezierPath *arcPath = [UIBezierPath bezierPath];
            [arcPath addArcWithCenter:CGPointMake(w/2.0, h/2.)
                               radius:h/2.
                           startAngle:M_PI/2.3
                             endAngle:-M_PI/2.3
                            clockwise:NO];
            self.indicatorShapeLayer.path = arcPath.CGPath;
            self.indicatorShapeLayer.strokeEnd = 0.1;
            self.replicatorLayer.instanceCount = 2;
            self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 0, 0, 0.1);
            break;
        }
        case MUReplicatorLayerAnimationStyleTriangle:{
            self.indicatorShapeLayer.frame = CGRectMake(self.replicatorLayer.widthMu/2., 5., 8., 8.);
            self.indicatorShapeLayer.cornerRadius = self.indicatorShapeLayer.widthMu/2.;
            CGPoint topPoint = self.indicatorShapeLayer.position;
            CGPoint leftPoint = CGPointMake(topPoint.x-15, topPoint.y+23);
            CGPoint rightPoint = CGPointMake(topPoint.x+15, topPoint.y+23);
            
            CAShapeLayer *leftCircle = [self leftCircle];
            CAShapeLayer *rightCircle = [self rithtCircle];
            if (leftCircle)
                [leftCircle removeFromSuperlayer];
            if (rightCircle)
                [rightCircle removeFromSuperlayer];
            
            leftCircle.sizeMu = self.indicatorShapeLayer.sizeMu;
            leftCircle.position = leftPoint;
            leftCircle.cornerRadius = self.indicatorShapeLayer.cornerRadius;
            [self.replicatorLayer addSublayer:leftCircle];
            
            rightCircle.sizeMu = self.indicatorShapeLayer.sizeMu;
            rightCircle.position = rightPoint;
            rightCircle.cornerRadius = self.indicatorShapeLayer.cornerRadius;
            [self.replicatorLayer addSublayer:rightCircle];
            break;
        }
        case MUReplicatorLayerAnimationStyleNone:
            
            break;
    }
}

- (void)startAnimating{
    [self.indicatorShapeLayer removeAllAnimations];
    switch (self.animationStyle) {
        case MUReplicatorLayerAnimationStyleWoody:{
            CABasicAnimation *basicAnimation = [self animationKeyPath:@"transform.scale.y"
                                                                 from:@(1.5)
                                                                   to:@(0.0)
                                                             duration:0.3
                                                           repeatTime:INFINITY];
            basicAnimation.autoreverses = YES;
            [self.indicatorShapeLayer addAnimation:basicAnimation forKey:basicAnimation.keyPath];
            break;
        }
        case MUReplicatorLayerAnimationStyleAllen:{
            CABasicAnimation *basicAnimation = [self animationKeyPath:@"position.y"
                                                                 from:@(self.indicatorShapeLayer.position.y+10)
                                                                   to:@(self.indicatorShapeLayer.position.y-10)
                                                             duration:0.3
                                                           repeatTime:INFINITY];
            basicAnimation.autoreverses = YES;
            [self.indicatorShapeLayer addAnimation:basicAnimation forKey:basicAnimation.keyPath];
            break;
        }
        case MUReplicatorLayerAnimationStyleCircle:{
            CABasicAnimation *basicAnimation = [self animationKeyPath:@"transform.scale"
                                                                 from:@(1.0)
                                                                   to:@(0.2)
                                                             duration:0.8
                                                           repeatTime:INFINITY];
            [self.indicatorShapeLayer addAnimation:basicAnimation forKey:basicAnimation.keyPath];
            break;
        }
        case MUReplicatorLayerAnimationStyleDot:{
            CABasicAnimation *basicAnimation = [self animationKeyPath:@"transform.scale"
                                                                 from:@(0.3)
                                                                   to:@(4.)
                                                             duration:0.5
                                                           repeatTime:INFINITY];
            basicAnimation.autoreverses = YES;
            CABasicAnimation * opc = [self animationKeyPath:@"opacity"
                                                       from:@(0.1)
                                                         to:@(1.0)
                                                   duration:0.5
                                                 repeatTime:INFINITY];
            
            opc.autoreverses = YES;
            CAAnimationGroup * group = [CAAnimationGroup animation];
            group.animations = @[basicAnimation,opc];
            group.autoreverses = YES;
            group.repeatCount = INFINITY;
            group.duration = 0.5;
            [self.indicatorShapeLayer addAnimation:group forKey:basicAnimation.keyPath];
            break;
        }
        case MUReplicatorLayerAnimationStyleArc:{
            CABasicAnimation *basicAnimation = [self animationKeyPath:@"transform.rotation.z"
                                                                 from:@(0.0)
                                                                   to:@(2*M_PI)
                                                             duration:0.8
                                                           repeatTime:INFINITY];
            [self.indicatorShapeLayer addAnimation:basicAnimation forKey:basicAnimation.keyPath];
            break;
        }
        case MUReplicatorLayerAnimationStyleTriangle:{
            CAShapeLayer *leftCircle = objc_getAssociatedObject(self, &kLeftDotKey);
            CAShapeLayer *rightCircle = objc_getAssociatedObject(self, &kRightDotKey);
            
            CGPoint topPoint = self.indicatorShapeLayer.position;
            CGPoint leftPoint = leftCircle.position;
            CGPoint rightPoint = rightCircle.position;
            
            NSArray *vertexs = @[[NSValue valueWithCGPoint:topPoint],
                                 [NSValue valueWithCGPoint:leftPoint],
                                 [NSValue valueWithCGPoint:rightPoint]];
            
            CAKeyframeAnimation *key0 = [self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:topPoint vertexs:vertexs] duration:1.5];
            [self.indicatorShapeLayer addAnimation:key0 forKey:key0.keyPath];
            
            CAKeyframeAnimation *key1 = [self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:leftPoint vertexs:vertexs] duration:1.5];
            [rightCircle addAnimation:key1 forKey:key1.keyPath];
            
            CAKeyframeAnimation *key2 = [self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:rightPoint vertexs:vertexs] duration:1.5];
            [leftCircle addAnimation:key2 forKey:key2.keyPath];
            break;
        }
        case MUReplicatorLayerAnimationStyleNone:
            break;
    }
}

- (void)stopAnimating{
    [self.indicatorShapeLayer removeAllAnimations];
    
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
            self.indicatorShapeLayer.strokeEnd = 0.1;
            break;
        }
        case MUReplicatorLayerAnimationStyleTriangle:{
            CAShapeLayer *leftCircle = objc_getAssociatedObject(self, &kLeftDotKey);
            [leftCircle removeAllAnimations];
            CAShapeLayer *rightCircle = objc_getAssociatedObject(self, &kRightDotKey);
            [rightCircle removeAllAnimations];
            break;
        }
        case MUReplicatorLayerAnimationStyleNone:
            break;
    }
    
}

- (CABasicAnimation *)animationKeyPath:(NSString *)keyPath
                                  from:(NSNumber *)fromValue
                                    to:(NSNumber *)toValue
                              duration:(CFTimeInterval)duration
                            repeatTime:(CGFloat)repeat {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.repeatCount = repeat;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAKeyframeAnimation *)keyFrameAnimationWithPath:(UIBezierPath *)path
                                          duration:(NSTimeInterval)duration {
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = duration;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    return animation;
}

- (UIBezierPath *)trianglePathWithStartPoint:(CGPoint)startPoint vertexs:(NSArray *)vertexs {
    CGPoint topPoint  = [[vertexs objectAtIndex:0] CGPointValue];
    CGPoint leftPoint  = [[vertexs objectAtIndex:1] CGPointValue];
    CGPoint rightPoint  = [[vertexs objectAtIndex:2] CGPointValue];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (CGPointEqualToPoint(startPoint, topPoint) ) {
        [path moveToPoint:startPoint];
        [path addLineToPoint:rightPoint];
        [path addLineToPoint:leftPoint];
    } else if (CGPointEqualToPoint(startPoint, leftPoint)) {
        [path moveToPoint:startPoint];
        [path addLineToPoint:topPoint];
        [path addLineToPoint:rightPoint];
    } else {
        [path moveToPoint:startPoint];
        [path addLineToPoint:leftPoint];
        [path addLineToPoint:topPoint];
    }
    
    [path closePath];
    
    return path;
}

- (CAShapeLayer *)leftCircle{
    CAShapeLayer *leftCircle = objc_getAssociatedObject(self, &kLeftDotKey);
    if (!leftCircle) {
        leftCircle = [CAShapeLayer layer];
        leftCircle.backgroundColor = self.indicatorShapeLayer.backgroundColor;
        objc_setAssociatedObject(self, &kLeftDotKey, leftCircle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return leftCircle;
}

- (CAShapeLayer *)rithtCircle{
    CAShapeLayer *rightCircle = objc_getAssociatedObject(self, &kRightDotKey);
    if (!rightCircle) {
        rightCircle = [CAShapeLayer layer];
        rightCircle.backgroundColor = self.indicatorShapeLayer.backgroundColor;
        objc_setAssociatedObject(self, &kRightDotKey, rightCircle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rightCircle;
}

- (CAShapeLayer *)indicatorShapeLayer{
    if (!_indicatorShapeLayer) {
        _indicatorShapeLayer = [CAShapeLayer layer];
        _indicatorShapeLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _indicatorShapeLayer;
}

- (CAReplicatorLayer *)replicatorLayer{
    if (!_replicatorLayer) {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
        _replicatorLayer.shouldRasterize = YES;
        _replicatorLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    }
    return _replicatorLayer;
}
@end
