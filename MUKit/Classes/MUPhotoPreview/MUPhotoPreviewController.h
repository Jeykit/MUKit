//
//  MUPhotoPreviewController.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface MUPhotoPreviewController : UIViewController

/**
 * 相册
 */
@property (nonatomic, strong) PHFetchResult         *fetchResult;
/**
 *  currentIndex 0...
 */
@property(nonatomic, assign)NSUInteger              currentIndex;
/**
 *  1.代表图片
 *  2.代表视频
 */
@property (nonatomic,assign) NSUInteger             mediaType;

/**
 *  网络图片数组模型
 */
@property (nonatomic,strong) NSArray                *modelArray;//网络图片数组模型

/**
 * 如果使用的是网络图片，configuredImageBlock才会回调
 */
@property (nonatomic, copy) void(^configuredImageBlock)(UIImageView *imageView ,NSUInteger index ,id model);
@end
