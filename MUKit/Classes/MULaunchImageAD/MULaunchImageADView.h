//
//  MULaunchImageADView.h
//  AFNetworking
//
//  Created by Jekity on 2018/12/29.
//

#import <UIKit/UIKit.h>
#import <MUCarouselView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MULaunchImageADView : UIView

@property (nonatomic,strong ,readonly) MUCarouselView *carouselView;

/**图片配置*/
@property (nonatomic, copy) void(^ADConfigured)(UIImageView *imageView ,NSUInteger index ,id model);

///跳过按钮 可自定义
@property (nonatomic, strong) UIButton *skipButton;

///倒计时总时长,默认6秒
@property (nonatomic, assign) NSInteger ADTime;

/**点击关闭按钮调用的block,NO倒计时，YES代表点击跳过*/
@property (nonatomic, copy) void(^ADCallbackBlock)(BOOL clicked);

@end

NS_ASSUME_NONNULL_END
