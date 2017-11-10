//
//  MUTapDetectingView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUTapDetectingViewDelegate;

@interface MUTapDetectingView : UIView {}

@property (nonatomic, weak) id <MUTapDetectingViewDelegate> tapDelegate;

@end

@protocol MUTapDetectingViewDelegate <NSObject>

@optional

- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch;
- (void)view:(UIView *)view tripleTapDetected:(UITouch *)touch;

@end

