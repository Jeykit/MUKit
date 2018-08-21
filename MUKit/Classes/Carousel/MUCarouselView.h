//
//  MUCarouselView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, MUPageContolPosition) {
    MUPageContolPositionBottomCenter,  // 底部中心
    MUPageContolPositionBottomRight,   // 底部右边
    MUPageContolPositionBottomLeft     // 底部左边
};


@interface MUCarouselView : UIView
/**初始化方法，configured block是自定义设置的地方 ，model是imageArray里面的模型数据，需要手动转类型*/
- (instancetype)initWithFrame:(CGRect)frame configured:(void(^)(UIImageView *imageView ,NSUInteger index ,id model))configured;

/**图片模型数组，支持任意对象*/
@property (nonatomic,strong) NSArray *imageArray;

/**点击图片后调用的block*/
@property (nonatomic, copy) void(^clickedImageBlock)(UIImageView *imageView ,NSUInteger index ,id model);

/**图片滑动后调用的block*/
@property(nonatomic, copy)void (^doneUpdateCurrentIndex)(NSUInteger index ,id model);

/**设置pageControll的指示图片*/
- (void)setPageImage:(UIImage *)image currentPageImage:(UIImage *)currentImage;

/**轮播时间，默认2s*/
@property(assign ,nonatomic) NSTimeInterval duration;

/**内容边距*/
@property (nonatomic,assign) NSUInteger contentMargain;

/**自动滚动，默认为Yes*/
@property (assign ,nonatomic, getter=isAutoScroll) BOOL autoScroll;

//当前显示的轮播图索引
@property(nonatomic, assign ,readonly) NSUInteger currentIndex;

//pageControll的属性
@property (strong, nonatomic) UIColor *currentPageColor;
@property (strong, nonatomic) UIColor *pageColor;
@property (assign, nonatomic) MUPageContolPosition pageControlPosition;
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;

@end
