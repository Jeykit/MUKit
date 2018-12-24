//
//  MUNavigationController.h
//  AFNetworking
//
//  Created by Jekity on 2018/11/6.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger , MUNavigationAnimationType) {
    
    MUNavigationAnimationTypeNone = 0,//默认
    MUNavigationAnimationTypeSlider  = 1,//平滑
    MUNavigationAnimationTypeScale = 2//伸缩
};


NS_ASSUME_NONNULL_BEGIN

@interface MUNavigationController : UINavigationController
/** 动画类型 平滑*/
@property (nonatomic, assign) MUNavigationAnimationType animationType;

/** 阴影透明度 默认0.3 */
@property (nonatomic, assign) CGFloat shadowOpacity;

/** 距离左边多少就Push  80 */
@property (nonatomic, assign) CGFloat distanceLeft;

/** 蒙版的透明度 0.4 */
@property (nonatomic, assign) CGFloat maskViewAlpha;

/** 缩放程度 0.95 建议在0.9 ~ 1.0*/
@property (nonatomic, assign) CGFloat scaleViewFloat;

@property (nonatomic,assign) BOOL interactivePopGestureRecognizerMU;
@end

NS_ASSUME_NONNULL_END
