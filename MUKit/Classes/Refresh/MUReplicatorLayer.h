//
//  MUReplicatorLayer.h
//  AFNetworking
//
//  Created by Jekity on 2018/6/4.
//

#import <QuartzCore/QuartzCore.h>


typedef NS_ENUM(NSInteger,MUReplicatorLayerAnimationStyle) {
    MUReplicatorLayerAnimationStyleWoody,
    MUReplicatorLayerAnimationStyleAllen,
    MUReplicatorLayerAnimationStyleCircle,
    MUReplicatorLayerAnimationStyleDot,
    MUReplicatorLayerAnimationStyleArc,
    MUReplicatorLayerAnimationStyleTriangle,
    MUReplicatorLayerAnimationStyleNone
};
@interface MUReplicatorLayer : CALayer
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAShapeLayer *indicatorShapeLayer;
@property (assign, nonatomic) MUReplicatorLayerAnimationStyle animationStyle;

- (void)startAnimating;

- (void)stopAnimating;
@end
