//
//  MUNavigation.h
//  Pods
//
//  Created by Jekity on 2017/10/12.
//
//

#import <Foundation/Foundation.h>


// -----------------------------------------------------------------------------
@interface UINavigationBar (MUNavigation)

/** 设置当前 NavigationBar 背景图片*/
- (void)mu_setBackgroundImage:(UIImage *)image;
/** 设置当前 NavigationBar 背景颜色*/
- (void)mu_setBackgroundColor:(UIColor *)color;
/** 设置当前 NavigationBar 背景透明度*/
- (void)mu_setBackgroundAlpha:(CGFloat)alpha;
/** 设置导航栏所有 barButtonItem 的透明度*/
- (void)mu_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;

@end

@interface UIViewController (MUNavigation)

@property(nonatomic, assign)BOOL             barHiddenMu;
@property(nonatomic, assign)CGFloat          barAlphaMu;
@property(nonatomic, assign)UIColor          *barBackgroundColorMu;
@property(nonatomic, assign)UIColor          *barTintColorMu;
@property(nonatomic, assign)UIImage          *barBackgroundImageMu;
@property(nonatomic, assign)UIColor          *titleColorMu;
@property(nonatomic, assign)UIStatusBarStyle statusBarStyleMu;
@property(nonatomic, assign)BOOL             barShadowImageHiddenMu;

@end
