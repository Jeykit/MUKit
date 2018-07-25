//
//  MUTapDetectingImageView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUTapDetectingImageViewDelegate;
@interface MUTapDetectingImageView : UIImageView
@property (nonatomic, weak) id <MUTapDetectingImageViewDelegate> tapDelegate;
@end

@protocol MUTapDetectingImageViewDelegate <NSObject>

@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;

@end
