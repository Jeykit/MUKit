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
@property (nonatomic, strong) PHFetchResult         *fetchResult;
@property(nonatomic, assign)NSUInteger              currentIndex;
@property (nonatomic,assign) NSUInteger             mediaType;//1代表图片，2代表视频
@property (nonatomic,strong) NSArray *urlStringArray;//网络图片数组
@end
