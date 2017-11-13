//
//  MUPhotoPreviewView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/10.
//  Copyright © 2017年 Jeykit. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@class MUPhotoPreviewController;
@interface MUPhotoPreviewView : UIView

@property(nonatomic, strong)PHFetchResult *fetchResult;
// 轮播图的图片被点击时回调的block，与代理功能一致，开发者可二选其一.如果两种方式不小心同时实现了，则默认block方式
// 当前显示的图片
@property(nonatomic, assign)NSUInteger currentIndex;
@property(nonatomic, copy)void (^handleSingleTap)(NSUInteger index);
@property(nonatomic, copy)void (^handleScrollViewDelegate)(BOOL flag);
@property(nonatomic, copy)void (^hideControls)(void);
@property(nonatomic, copy)void (^doneUpdateCurrentIndex)(NSUInteger index);
@end
