//
//  MULevitateView.h
//  ZPApp
//
//  Created by Jekity on 2018/8/16.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MULevitateView : UIView

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

@property (nonatomic ,strong ,readonly) UIButton *levitateButton;
/**可移动时,水平方向与屏幕边缘的距离*/
@property (nonatomic,assign) CGFloat horizontalMargain;

/**可移动时，竖直方向与屏幕边缘的距离*/
@property (nonatomic,assign) CGFloat verticalMargain;

/**按钮是否可以拖动调整悬浮位置,默认为YES*/
@property (nonatomic,assign) BOOL addjustPosition;

/**按钮点击*/
@property (nonatomic, copy) void(^tapedBlock)(void);
@end
