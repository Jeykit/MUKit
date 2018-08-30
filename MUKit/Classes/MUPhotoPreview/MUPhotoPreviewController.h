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
 * photos
 */
@property (nonatomic, strong) PHFetchResult         *fetchResult;
/**
 *  currentIndex 0...
 */
@property(nonatomic, assign)NSUInteger              currentIndex;
/**
 *  1.image
 *  2.video
 */
@property (nonatomic,assign) NSUInteger             mediaType;

/**
 *  images model.local or networking
 */
@property (nonatomic,strong) NSArray                *modelArray;//网络/本地图片数组模型

/**
 * imageView show in time
 * index current index
 * model
 * caption image decription
 */
@property (nonatomic, copy) void(^configuredImageBlock)(UIImageView *imageView ,NSUInteger index ,id model ,NSString * *caption);

/**
 * toolbar which you can customize some functions
 */
@property (nonatomic,strong ,readonly) UIToolbar *toolbar;
@end
