//
//  MULevitateView.m
//  ZPApp
//
//  Created by Jekity on 2018/8/16.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MULevitateView.h"


// 屏幕高度
#define kLevitateScreenHeight [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define kLevitateScreenWidth [UIScreen mainScreen].bounds.size.width
@interface MULevitateView ()
@property (nonatomic,strong) UIButton *levitateButton;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@end
@implementation MULevitateView

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = backgroundColor?:[UIColor whiteColor];
        if (cornerRadius > 0) {
            self.layer.cornerRadius = cornerRadius;
        }
        [self setupLevitateButton:frame];
    }
    return self;
}


- (void)setupLevitateButton:(CGRect)rect{
    self.levitateButton = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,0, rect.size.width, rect.size.height);
        // 按钮点击事件
        [btn addTarget:self action:@selector(suspendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        // 禁止高亮
        btn.adjustsImageWhenHighlighted = NO;
        // 置顶（只是显示置顶，但响应事件会被后来者覆盖！）
        btn.layer.zPosition = 1;
        
        //创建移动手势事件
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panRcognize setMinimumNumberOfTouches:1];
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        _panGestureRecognizer = panRcognize;
        [self addGestureRecognizer:panRcognize];
        
        btn;
    });
    
    [self addSubview:self.levitateButton];
}

//悬浮按钮点击
- (void)suspendBtnClicked:(id)sender
{
    if (self.tapedBlock) {
        self.tapedBlock();
    }
}

//设置属性
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [self.levitateButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}
- (void)setTitleFont:(CGFloat)titleFont{
    _titleFont = titleFont;
    self.levitateButton.titleLabel.font = [UIFont systemFontOfSize:titleFont];
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self.levitateButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [self.levitateButton setTitle:titleText forState:UIControlStateNormal];
}

- (void)setAddjustPosition:(BOOL)addjustPosition{
    _addjustPosition = addjustPosition;
    if (!addjustPosition) {
        [self.panGestureRecognizer removeTarget:self action:@selector(handlePanGesture:)];
    }else{
        [self.panGestureRecognizer addTarget:self action:@selector(handlePanGesture:)];
    }
}
/*
 *  悬浮按钮移动事件处理
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.superview];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, kLevitateScreenHeight / 2.0);
            
            if (recognizer.view.center.x < kLevitateScreenWidth / 2.0) {
                if (recognizer.view.center.y <= kLevitateScreenHeight/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x , CGRectGetWidth(self.frame)/2.0);
                    }else{
                        stopPoint = CGPointMake(CGRectGetWidth(self.frame)/2.0 , recognizer.view.center.y);
                    }
                }else{
                    //左下
                    if (recognizer.view.center.x  >= kLevitateScreenWidth - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x , kLevitateScreenHeight - CGRectGetWidth(self.frame)/2.0 );
                    }else{
                        stopPoint = CGPointMake(CGRectGetWidth(self.frame)/2.0, recognizer.view.center.y );
                    }
                }
            }else{
                if (recognizer.view.center.y <= kLevitateScreenHeight/2.0) {
                    //右上
                    if (kLevitateScreenWidth - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x , CGRectGetWidth(self.frame)/2.0);
                    }else{
                        stopPoint = CGPointMake(kLevitateScreenWidth - CGRectGetWidth(self.frame)/2.0 , recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (kLevitateScreenWidth - recognizer.view.center.x  >= kLevitateScreenHeight - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, kLevitateScreenHeight - CGRectGetWidth(self.frame)/2.0 );
                    }else{
                        stopPoint = CGPointMake(kLevitateScreenWidth - CGRectGetWidth(self.frame)/2.0 ,recognizer.view.center.y );
                    }
                }
            }
            
            if (stopPoint.x - CGRectGetWidth(self.frame)/2.0 <= 0) {
                stopPoint = CGPointMake(CGRectGetWidth(self.frame)/2.0+_horizontalMargain, stopPoint.y);
            }
            
            if (stopPoint.x + CGRectGetWidth(self.frame)/2.0 >= kLevitateScreenWidth) {
                stopPoint = CGPointMake(kLevitateScreenWidth - CGRectGetWidth(self.frame)/2.0 - _horizontalMargain, stopPoint.y);
            }
            
            if (stopPoint.y - CGRectGetWidth(self.frame)/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, kLevitateScreenWidth/2.0 + _verticalMargain);
            }
            
            if (stopPoint.y + CGRectGetWidth(self.frame)/2.0 >= kLevitateScreenHeight) {
                stopPoint = CGPointMake(stopPoint.x, kLevitateScreenHeight - CGRectGetWidth(self.frame)/2.0 - _verticalMargain);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}
@end
