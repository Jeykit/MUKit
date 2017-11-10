//
//  MUCarouselView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSInteger, MUPageContolPosition) {
    MUPageContolPositionBottomCenter,  // 底部中心
    MUPageContolPositionBottomRight,   // 底部右边
    MUPageContolPositionBottomLeft     // 底部左边
};

typedef NS_ENUM(NSInteger, MUCarouselViewImageMode) {
    MUCarouselViewImageModeScaleToFill,       // 默认,充满父控件
    MUCarouselViewImageModeScaleAspectFit,    // 按图片比例显示,少于父控件的部分会留有空白
    MUCarouselViewImageModeScaleAspectFill,   // 按图片比例显示,超出父控件的部分会被剪掉
    MUCarouselViewImageModeCenter             // 处于父控件中心,不会被拉伸,按原始大小显示
};

@interface MUCarouselView : UIView


// 为了消除类方法创建的局限性，提供下面两个属性，轮播图的图片数组。适用于创建时用alloc init，然后在以后的某个时刻传入数组。
// 本地图片
@property(strong, nonatomic) NSArray<NSString *> *localImages;
// 网络图片
@property(strong, nonatomic) NSArray<NSString *> *urlImages;

@property(nonatomic, strong)PHFetchResult *fetchResult;
// 轮播图的图片被点击时回调的block，与代理功能一致，开发者可二选其一.如果两种方式不小心同时实现了，则默认block方式
@property (nonatomic, copy) void(^clickedImageBlock)(NSUInteger index);
@property (nonatomic, copy) void(^scrollToImageBlock)(NSUInteger index);

// 图片自动切换间隔时间, 默认设置为 2s
@property(assign ,nonatomic) NSTimeInterval duration;

// 是否自动轮播,默认为YES
@property (assign ,nonatomic, getter=isAutoScroll) BOOL autoScroll;

// 当前小圆点的颜色
@property (strong, nonatomic) UIColor *currentPageColor;
// 其余小圆点的颜色
@property (strong, nonatomic) UIColor *pageColor;

// 当前显示的图片
@property(nonatomic, assign)NSUInteger currentIndex;
// pageControl的位置,分左,中,右
@property (assign, nonatomic) MUPageContolPosition pageControlPosition;

// 是否显示pageControl
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

// 轮播图上的图片显示模式
@property (assign, nonatomic) MUCarouselViewImageMode imageMode;

/** 设置小圆点的图片 */
- (void)setPageImage:(UIImage *)image currentPageImage:(UIImage *)currentImage;
@end
