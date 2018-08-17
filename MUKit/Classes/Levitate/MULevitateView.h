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
/**水平方向与屏幕边缘的距离*/
@property (nonatomic,assign) CGFloat horizontalMargain;

/**竖直方向与屏幕边缘的距离*/
@property (nonatomic,assign) CGFloat verticalMargain;

/**按钮背景图片*/
@property (nonatomic,strong) UIImage *backgroundImage;

/**按钮标题文字*/
@property (nonatomic,strong) NSString *titleText;

/**按钮标题颜色*/
@property (nonatomic,strong) UIColor *titleColor;

/**按钮标题大小*/
@property (nonatomic,assign) CGFloat titleFont;

/**按钮是否可以拖动调整悬浮位置,默认为YES*/
@property (nonatomic,assign) BOOL addjustPosition;

/**按钮点击*/
@property (nonatomic, copy) void(^tapedBlock)(void);
@end
