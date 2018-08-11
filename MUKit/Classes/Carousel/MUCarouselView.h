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

typedef NS_ENUM(NSInteger, MUCarouselViewImageMode) {
    MUCarouselViewImageModeScaleToFill,       // 默认,充满父控件
    MUCarouselViewImageModeScaleAspectFit,    // 按图片比例显示,少于父控件的部分会留有空白
    MUCarouselViewImageModeScaleAspectFill,   // 按图片比例显示,超出父控件的部分会被剪掉
    MUCarouselViewImageModeCenter             // 处于父控件中心,不会被拉伸,按原始大小显示
};


@interface MUCarouselView : UIView

// local images
@property(strong, nonatomic) NSArray<NSString *> *localImages;
// network images
@property(strong, nonatomic) NSArray<NSString *> *urlImages;
@property (nonatomic, copy) void(^clickedImageBlock)(NSUInteger index);
// defalut 2s
@property(assign ,nonatomic) NSTimeInterval duration;
// network placeholderImage
@property(nonatomic, strong)NSString *placeholderImage;
// auto scroll
@property (assign ,nonatomic, getter=isAutoScroll) BOOL autoScroll;
@property (strong, nonatomic) UIColor *currentPageColor;
@property (strong, nonatomic) UIColor *pageColor;
@property(nonatomic, assign) NSUInteger currentIndex;
@property (assign, nonatomic) MUPageContolPosition pageControlPosition;
@property (nonatomic, assign, getter=isShowPageControl) BOOL showPageControl;
@property (assign, nonatomic) MUCarouselViewImageMode imageMode;
@property(nonatomic, copy)void (^doneUpdateCurrentIndex)(NSUInteger index);
- (void)setPageImage:(UIImage *)image currentPageImage:(UIImage *)currentImage;
@property (nonatomic,assign) NSUInteger contentMargain;
@property (nonatomic,assign) CGFloat contentCornerRadius;
@end
