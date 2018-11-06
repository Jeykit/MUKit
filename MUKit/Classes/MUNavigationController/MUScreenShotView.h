//
//  MUScreenShotView.h
//  MUKit_Example
//
//  Created by Jekity on 2018/10/24.
//  Copyright © 2018 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUScreenShotView : UIView
/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *arrayScreenShots;
/** 容器view*/
@property (nonatomic, strong) UIImageView *imageView;
/** 蒙版*/
@property (nonatomic, strong) UIView *maskView;
@end

NS_ASSUME_NONNULL_END
