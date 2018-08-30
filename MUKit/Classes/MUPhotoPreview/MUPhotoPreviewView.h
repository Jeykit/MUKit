//
//  MUPhotoPreviewView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/10.
//  Copyright © 2017年 Jeykit. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "MUZoomingScrollView.h"
#import "MUCaptionView.h"

@class MUPhotoPreviewController;
@interface MUPhotoPreviewView : UIView

@property (nonatomic,weak) MUCaptionView *captionView;
@property(nonatomic, strong)PHFetchResult *fetchResult;
@property (nonatomic,strong) NSArray *imageModelArray;//网络图片数组
@property (nonatomic,assign) NSUInteger             mediaType;//1代表图片，2代表视频
// 轮播图的图片被点击时回调的block，与代理功能一致，开发者可二选其一.如果两种方式不小心同时实现了，则默认block方式
// 当前显示的图片
@property(nonatomic, assign)NSUInteger currentIndex;
@property(nonatomic, copy)void (^handleSingleTap)(NSUInteger index ,NSUInteger mediaType);
@property(nonatomic, copy)void (^handleSingleTapWithPlayVideo)(NSUInteger index ,NSUInteger mediaType);
@property(nonatomic, copy)void (^handleScrollViewDelegate)(BOOL flag);
@property(nonatomic, copy)void (^hideControls)(void);
@property(nonatomic, copy)void (^doneUpdateCurrentIndex)(NSUInteger index);
/**点击图片后调用的block*/
@property (nonatomic, copy) void(^configuredImageBlock)(UIImageView *imageView ,NSUInteger index ,id model);
@end
