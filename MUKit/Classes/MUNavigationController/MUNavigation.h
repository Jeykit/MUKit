//
//  MUNavigationTest.h
//  Pods
//
//  Created by Jekity on 2017/10/13.
//
//

#import <Foundation/Foundation.h>

@interface UIViewController (MUNavigation)

@property(nonatomic, assign)BOOL             navigationBarTranslucentMu;//透明导航栏
@property(nonatomic, assign)CGFloat          navigationBarAlphaMu;//透明度
@property(nonatomic, assign)BOOL             navigationBarHiddenMu;//隐藏导航栏
@property(nonatomic, strong)UIColor          *navigationBarBackgroundColorMu;//背景颜色
@property(nonatomic, strong)UIImage          *navigationBarBackgroundImageMu;//背景图片
@property(nonatomic, assign)BOOL             navigationBarShadowImageHiddenMu;//隐藏阴影线
@property(nonatomic, strong)UIColor          *titleColorMu;//标题颜色
@property(nonatomic, strong)UIColor          *navigationBarTintColor;//控件颜色
@property(nonatomic, assign)UIStatusBarStyle  statusBarStyleMu;//电池电量条,没有导航控制器的情况下使用
@property(nonatomic, assign)UIBarStyle       barStyleMu;//电池电量条，有导航控制器的情况下使用

@property(nonatomic, readonly ,weak)UIBarButtonItem *leftButtonItem;
@property(nonatomic, readonly ,weak)UIBarButtonItem *rightButtonItem;
@property(nonatomic, readonly ,weak)UIBarButtonItem *backButtonItem;
//左右item
-(void)addLeftItemWithTitle:(NSString *)title itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;
-(void)addLeftItemWithImage:(UIImage *)image itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;

-(void)addRightItemWithTitle:(NSString *)title itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;
-(void)addRightItemWithImage:(UIImage *)image itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;
@end
