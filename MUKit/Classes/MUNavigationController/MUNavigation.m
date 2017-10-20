//
//  MUNavigationTest.m
//  Pods
//
//  Created by Jekity on 2017/10/13.
//
//

#import "MUNavigation.h"
#import "MUHookMethodHelper.h"
#import "UIColor+MUColor.h"
#import "UIImage+MUColor.h"
#import <objc/runtime.h>

@interface UINavigationBar(MUNavigation)
/** 设置当前 NavigationBar 背景图片*/
- (void)mu_setBackgroundImage:(UIImage *)image;
/** 设置当前 NavigationBar 背景颜色*/
- (void)mu_setBackgroundColor:(UIColor *)color;

/** 设置当前 NavigationBar 透明度*/
//- (void)mu_setBackgroundAlpha:(CGFloat)alpha;
- (void)mu_remove;
@end
@implementation UINavigationBar (MUNavigation)

- (UIView *)backgroundView {
    return (UIView *)objc_getAssociatedObject(self, @selector(backgroundView));
}
- (void)setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, @selector(backgroundView), backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView {
    return (UIImageView *)objc_getAssociatedObject(self, @selector(backgroundView));
}
- (void)setBackgroundImageView:(UIImageView *)bgImageView {
    objc_setAssociatedObject(self, @selector(backgroundView), bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// -> 设置导航栏背景图片
- (void)mu_setBackgroundImage:(UIImage *)image {
    if (!image) {
        return;
    }
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    if (!self.backgroundImageView) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  // ****
        UIColor *color = [UIColor colorWithPatternImage:image];
        NSString *hexStr = [UIColor hexStringFromColor:color];
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:hexStr alpha:.28].CGColor,(__bridge id)[UIColor colorWithHex:0x040012 alpha:.28].CGColor];
        gradientLayer.locations  = @[@(0),@(1)];
        gradientLayer.startPoint = CGPointMake(0, 1.);
        gradientLayer.endPoint   = CGPointMake(0, 0);
        [self.backgroundImageView.layer addSublayer:gradientLayer];

        // _UIBarBackground is first subView for navigationBar
        /** iOS11下导航栏不显示问题 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
        } else {
            [self insertSubview:self.backgroundImageView atIndex:0];
        }
    }
//    self.backgroundImageView.alpha =
    self.backgroundImageView.image = image;
}

// -> 设置导航栏背景颜色
- (void)mu_setBackgroundColor:(UIColor *)color {
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    
    if (!self.backgroundView) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;      // ****
        
        //实现类似微信导航栏穿透效果
        NSString *hexStr = [UIColor hexStringFromColor:color];
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:hexStr alpha:.28].CGColor,(__bridge id)[UIColor colorWithHex:0x040012 alpha:.28].CGColor];
        gradientLayer.locations  = @[@(0),@(1)];
        gradientLayer.startPoint = CGPointMake(0, 1.);
        gradientLayer.endPoint   = CGPointMake(0, 0);
        [self.backgroundView.layer addSublayer:gradientLayer];
        //
        self.backgroundView.userInteractionEnabled = NO;
        // _UIBarBackground is first subView for navigationBar
//        [self mu_setBackgroundAlpha:0.5];
        /** iOS11下导航栏不显示问题 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
        } else {
            [self insertSubview:self.backgroundView atIndex:0];
        }
    }
    self.backgroundView.backgroundColor = color;
}
/** 设置当前 NavigationBar 透明度*/
-(void)mu_setBackgroundAlpha:(CGFloat)alpha{
//    if (!self.backgroundImageView){
//        self.backgroundImageView.alpha = alpha;
//    }else{
//        self.backgroundView.alpha = alpha;
//    }
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
}

-(void)mu_remove{
    if (self.backgroundImageView) {
        [self.backgroundImageView removeFromSuperview];
        self.backgroundImageView = nil;
    }
    if (self.backgroundView) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    }
}
@end

@interface UIViewController (MUNavigations)
@property(nonatomic, copy)void(^leftItemByTapped)(UIBarButtonItem *item);
@property(nonatomic, copy)void(^rightItemByTapped)(UIBarButtonItem *item);
@end
@implementation UIViewController (MUNavigation)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewWillAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillAppear:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewWillDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillDisappear:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidAppear:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidDisappear:)];
        
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLayoutSubviews) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLayoutSubviews)];
        
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLoad) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLoad)];
    });
}
-(void)mu_viewDidLoad{
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
//    CGRect rect = self.view.frame;
//    rect.size.width = [UIScreen mainScreen].bounds.size.width;
//    self.view.frame = rect;
    [self mu_viewDidLoad];
}
- (void)mu_viewWillAppear:(BOOL)animated {
  
     [self mu_viewWillAppear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self.navigationController setNavigationBarHidden:self.navigationBarHiddenMu animated:YES];
        [self removeFakeNavigationBar];
       
        if (([self colorEqualToColor:self] || [self imageEqualToImage:self])&&self.navigationBarAlphaMu == 1 && !self.navigationBarHiddenMu && !self.navigationBarTranslucentMu) {//颜色相同，无隐藏、透明度变化时更新
            
            [self now_updateNaviagationBarInfo];
            if (self.navigationBarBackgroundImageMu) {
                 [self.navigationController.navigationBar mu_setBackgroundImage:self.navigationBarBackgroundImageMu ];
                
            }else{
                
                [self.navigationController.navigationBar mu_setBackgroundColor:self.navigationBarBackgroundColorMu];
            }
        }else{
            if ([self shouldAddFakeNavigationBar]) {
//                if (self.navigationBarHiddenMu) {
//                    [self.navigationController setNavigationBarHidden:YES animated:YES];
//                }
               
                [self addFakeNavigationBar];
                if (self.navigationBarAlphaMu < 1.) {
                    [self setOpaqueView:self.navigationBarAlphaMu];
                }
                
                if (!self.navigationBarHiddenMu) {
                    [self now_updateNaviagationBarInfo];
                }
                
            }
        }
    }
   
}
- (void)mu_viewDidAppear:(BOOL)animated {
    
    [self mu_viewDidAppear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        self.navigationController.navigationBar.userInteractionEnabled = YES;
//        if (self.navigationBarHiddenMu) {
//            [self.navigationController setNavigationBarHidden:YES animated:NO];
//        }
        [self.navigationController setNavigationBarHidden:self.navigationBarHiddenMu animated:NO];
        if (![self colorEqualToColor:self] && ![self imageEqualToImage:self]) {
            
            [self  updateNaviagationBarInfo];
        }
        
        if (self.navigationBarAlphaMu == 1) {
            [self removeFakeNavigationBar];
        }

    }
}
// 交换方法 - 将要消失
- (void)mu_viewWillDisappear:(BOOL)animated {
  
    [self mu_viewWillDisappear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setNavigationBarHidden:self.navigationBarHiddenMu animated:YES];
        if (self.navigationBarAlphaMu == 1) {
            [self removeFakeNavigationBar];
        }
        [self.navigationController.navigationBar mu_remove];
    }
}
// 交换方法 - 已经消失
- (void)mu_viewDidDisappear:(BOOL)animated {
    
    [self removeFakeNavigationBar];
    [self mu_viewDidDisappear:animated];
}
//控制器布局结束
-(void)mu_viewDidLayoutSubviews{
    [self mu_viewDidLayoutSubviews];
    if (self.fakeNavigationBar) {
        [self.view bringSubviewToFront:self.fakeNavigationBar];
        
    }
}
//立即更新navigationBar info
-(void)now_updateNaviagationBarInfo{
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.titleColorMu};
    self.navigationController.navigationBar.tintColor = self.navigationBarTintColor;
    self.navigationController.navigationBar.barStyle  = self.barStyleMu;
//    [self.navigationController.navigationBar mu_setBackgroundAlpha:self.navigationBarAlphaMu];
//    [self.navigationController.navigationBar mu_setBackgroundColor:self.navigationBarBackgroundColorMu];

}
//更新navigationBar info
-(void)updateNaviagationBarInfo{
    
   [self.navigationController.navigationBar mu_setBackgroundImage:self.navigationBarBackgroundImageMu ];
    
    if (self.navigationBarBackgroundColorMu&&self.navigationBarAlphaMu == 1 && !self.navigationBarHiddenMu && !self.navigationBarTranslucentMu) {
        [self.navigationController.navigationBar mu_setBackgroundColor:self.navigationBarBackgroundColorMu];
    }
    [self showBottomLineInView:self.navigationController.navigationBar hidden:self.navigationBarShadowImageHiddenMu];
    
   
 
}
#pragma mark - private
- (BOOL)canUpdateNavigationBar {
    // 如果当前有导航栏//且没有手动设置隐藏导航栏
    if (self.navigationController) {
        return YES;
    }
    return NO;
}
-(BOOL)shouldAddFakeNavigationBar{
    
    UIViewController *fromViewController = self.fromViewController;
    UIViewController *toViewController   = self.toViewController;
    
    if ((fromViewController && (fromViewController.navigationBarAlphaMu != 1. || fromViewController.navigationBarHiddenMu || fromViewController.navigationBarTranslucentMu || ![self colorEqualToColor:fromViewController] || ![self imageEqualToImage:fromViewController])) || (toViewController && (toViewController.navigationBarAlphaMu != 1. || toViewController.navigationBarHiddenMu || toViewController.navigationBarTranslucentMu || ![self colorEqualToColor:toViewController] || ![self imageEqualToImage:toViewController]))) {//透明度变化，隐藏导航栏，透明导航栏，导航栏颜色与navigationController颜色不同时,导航栏图片不同时
        
        return YES;
    }
    return NO;
}
-(BOOL)colorEqualToColor:(UIViewController *)viewController{
    return  [UIColor colorEqualToColorMu:viewController.navigationBarBackgroundColorMu anotherColor:viewController.navigationController.navigationBarBackgroundColorMu];
}
-(BOOL)imageEqualToImage:(UIViewController *)viewController{
    return  [UIImage imageEqualToImageMu:viewController.navigationBarBackgroundImageMu anotherImage:viewController.navigationController.navigationBarBackgroundImageMu];
}
-(UIViewController *)fromViewController{
    return [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
}
-(UIViewController *)toViewController{
     return [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
}
- (void)showBottomLineInView:(UIView *)view hidden:(BOOL)hidden{
    UIImageView *navBarLineImageView = [self findLineImageViewUnder:view];
    navBarLineImageView.hidden = hidden;
}

- (UIImageView *)findLineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findLineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
// 添加一个假的 NavigationBar
- (void)addFakeNavigationBar {
    
//    [self configuredFakeNavigationBar:self];
    UIViewController *fromViewController = self.fromViewController;
    UIViewController *toViewController   = self.toViewController;
    if (fromViewController && !fromViewController.fakeNavigationBar) {
        
        [self configuredFakeNavigationBar:fromViewController];
    }
    if (toViewController && !toViewController.fakeNavigationBar) {
        
        [self configuredFakeNavigationBar:toViewController];
    }
}
- (void)removeFakeNavigationBar {
    if (self.fakeNavigationBar) {
        [self.fakeNavigationBar removeFromSuperview];
        self.fakeNavigationBar = nil;
        self.view.clipsToBounds = self.tempClipsToBounds;
    }
}
-(void)configuredFakeNavigationBar:(UIViewController *)viewController{
    
    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    if (self.navigationBarTranslucentMu || self.navigationBarAlphaMu != 1.) {
        [self showBottomLineInView:self.navigationController.navigationBar hidden:YES];
        self.navigationBarShadowImageHiddenMu = YES;
    }
    CGFloat mu_y = 0;
    if ((viewController.navigationBarBackgroundColorMu || viewController.navigationBarBackgroundImageMu)&&viewController.navigationBarAlphaMu == 1.) {
        mu_y = -64.;
    }
    viewController.fakeNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, mu_y, CGRectGetWidth([UIScreen mainScreen].bounds), self.navigationBarAndStatusBarHeight)];
    if (viewController.navigationBarTranslucentMu) {
        viewController.fakeNavigationBar.alpha = 0.;
        viewController.fakeNavigationBar.image = nil;
        viewController.fakeNavigationBar.backgroundColor = [UIColor clearColor];
    }else{
         viewController.fakeNavigationBar.alpha = viewController.navigationBarAlphaMu;
        UIColor *color = self.navigationBarBackgroundImageMu ? [UIColor colorWithPatternImage:self.navigationBarBackgroundImageMu]:self.navigationBarBackgroundColorMu;
        NSString *hexStr = [UIColor hexStringFromColor:color];
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),  self.navigationBarAndStatusBarHeight);
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:hexStr alpha:.28].CGColor,(__bridge id)[UIColor colorWithHex:0x040012 alpha:.28].CGColor];
        gradientLayer.locations  = @[@(0),@(1)];
        gradientLayer.startPoint = CGPointMake(0, 1.);
        gradientLayer.endPoint   = CGPointMake(0, 0);
        [viewController.fakeNavigationBar.layer addSublayer:gradientLayer];
        viewController.fakeNavigationBar.userInteractionEnabled = NO;
    }
    
    if (!self.navigationBarTranslucentMu) {
        viewController.fakeNavigationBar.image           = viewController.navigationBarBackgroundImageMu;
        viewController.fakeNavigationBar.backgroundColor = viewController.navigationBarBackgroundColorMu;
    }
    
    
    if ([viewController isKindOfClass:[UITableViewController class]]) {//tableView默认是打开裁剪的，必需关闭，否则假的navigationbar就会被裁剪，而达不到逾期效果
        viewController.tempClipsToBounds   = viewController.view.clipsToBounds;
        viewController.view.clipsToBounds = NO;
    }
    
    [viewController.view addSubview:viewController.fakeNavigationBar];
    [viewController.view bringSubviewToFront:viewController.fakeNavigationBar];
   
}

-(void)setOpaqueView:(CGFloat)alpha{
    
//    self.fakeNavigationBar.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.fakeNavigationBar.alpha = alpha;
}

//假的导航栏
- (UIImageView *)fakeNavigationBar {
    return (UIImageView *)objc_getAssociatedObject(self, @selector(fakeNavigationBar));
}
- (void)setFakeNavigationBar:(UIImageView *)navigationBar
{
    objc_setAssociatedObject(self, @selector(fakeNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//是否裁剪
-(void)setTempClipsToBounds:(BOOL)clipsToBounds{
    objc_setAssociatedObject(self, @selector(tempClipsToBounds), @(clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)tempClipsToBounds{
    id object = objc_getAssociatedObject(self, @selector(tempClipsToBounds));
    return object ? [object boolValue] : NO;
}
#pragma mark -public method
//电池电量
/** 设置当前状态栏样式 白色/黑色 */
-(void)setBarStyleMu:(UIBarStyle)barStyleMu{
     objc_setAssociatedObject(self, @selector(barStyleMu), @(barStyleMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIBarStyle)barStyleMu{
     id style = objc_getAssociatedObject(self, @selector(barStyleMu));
    UIBarStyle barStyle = UIBarStyleDefault;
    if (style) {
          barStyle = [style integerValue] == 0 ? UIBarStyleDefault : UIBarStyleBlack;
    }else{
        barStyle = self.navigationController.barStyleMu;
    }
    return barStyle;
}
-(void)setStatusBarStyleMu:(UIStatusBarStyle)statusBarStyleMu{
    objc_setAssociatedObject(self, @selector(statusBarStyleMu), @(statusBarStyleMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsStatusBarAppearanceUpdate];       // 调用导航栏的 preferredStatusBarStyle 方法
}
-(UIStatusBarStyle)statusBarStyleMu{
    id style = objc_getAssociatedObject(self, @selector(statusBarStyleMu));
    UIStatusBarStyle barStyle = UIStatusBarStyleDefault;
    if (style) {
        barStyle = [style integerValue] == 0 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    }else{
        barStyle = self.navigationController.statusBarStyleMu;
    }
    return barStyle;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self statusBarStyleMu];
}

//控件颜色
-(void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor{
     objc_setAssociatedObject(self, @selector(navigationBarTintColor), navigationBarTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UIColor *)navigationBarTintColor{
     id object = objc_getAssociatedObject(self, @selector(navigationBarTintColor));
    return object?:self.navigationController.navigationBarTintColor?:[UINavigationBar new].tintColor;
}
//标题颜色
-(void)setTitleColorMu:(UIColor *)titleColorMu{
    objc_setAssociatedObject(self, @selector(titleColorMu), titleColorMu, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(UIColor *)titleColorMu{
    id object = objc_getAssociatedObject(self, @selector(titleColorMu));
    UIColor *color = object?:self.navigationController.titleColorMu?:[UIColor blackColor];
    return color;
}
//阴影线
-(void)setNavigationBarShadowImageHiddenMu:(BOOL)navigationBarShadowImageHiddenMu{
    
    objc_setAssociatedObject(self, @selector(navigationBarShadowImageHiddenMu), @(navigationBarShadowImageHiddenMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)navigationBarShadowImageHiddenMu{
      id object = objc_getAssociatedObject(self, @selector(navigationBarShadowImageHiddenMu));
    return object ? [object boolValue] : NO;
}
//背景图片
-(void)setNavigationBarBackgroundImageMu:(UIImage *)navigationBarBackgroundImageMu{
    objc_setAssociatedObject(self, @selector(navigationBarBackgroundImageMu), navigationBarBackgroundImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)navigationBarBackgroundImageMu{
    id object = objc_getAssociatedObject(self, @selector(navigationBarBackgroundImageMu));
    object = object ? : self.navigationController.navigationBarBackgroundImageMu ? : nil;
    return object;
}
//背景颜色
-(void)setNavigationBarBackgroundColorMu:(UIColor *)navigationBarBackgroundColorMu{
    
    objc_setAssociatedObject(self, @selector(navigationBarBackgroundColorMu), navigationBarBackgroundColorMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)navigationBarBackgroundColorMu{
//    UIViewController *fromViewController = self.fromViewController;
    UIColor *color = objc_getAssociatedObject(self, @selector(navigationBarBackgroundColorMu));
    color = color ? :self.navigationController.navigationBarBackgroundColorMu? :[UIColor whiteColor];
   return color;
}
//隐藏导航栏
-(void)setNavigationBarHiddenMu:(BOOL)navigationBarHiddenMu{
    self.edgesForExtendedLayout = UIRectEdgeTop;
    objc_setAssociatedObject(self, @selector(navigationBarHiddenMu), [NSNumber numberWithBool:navigationBarHiddenMu], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)navigationBarHiddenMu{
    id object = objc_getAssociatedObject(self, @selector(navigationBarHiddenMu));
    return object?[object boolValue]:NO;
}
//透明导航栏
-(void)setNavigationBarTranslucentMu:(BOOL)navigationBarTranslucentMu{
     self.edgesForExtendedLayout = UIRectEdgeTop;
     objc_setAssociatedObject(self, @selector(navigationBarTranslucentMu), [NSNumber numberWithBool:navigationBarTranslucentMu], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)navigationBarTranslucentMu{
     id object = objc_getAssociatedObject(self, @selector(navigationBarTranslucentMu));
    return object?[object boolValue]:NO;
}
//透明度变化
-(void)setNavigationBarAlphaMu:(CGFloat)navigationBarAlphaMu{

    self.edgesForExtendedLayout = UIRectEdgeTop;
    objc_setAssociatedObject(self, @selector(navigationBarAlphaMu), @(navigationBarAlphaMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)navigationBarAlphaMu{
    
    id object = objc_getAssociatedObject(self, @selector(navigationBarAlphaMu));
    return object?[object floatValue]:1.;
}

/** 获取导航栏加状态栏高度*/
- (CGFloat)navigationBarAndStatusBarHeight {
    return CGRectGetHeight(self.navigationController.navigationBar.bounds) +
    CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

-(void)setLeftItemByTapped:(void (^)(UIBarButtonItem *))leftItemByTapped{
    
    objc_setAssociatedObject(self, @selector(leftItemByTapped), leftItemByTapped, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)(UIBarButtonItem *))leftItemByTapped{
    return objc_getAssociatedObject(self, @selector(leftItemByTapped));
}

-(void)setRightItemByTapped:(void (^)(UIBarButtonItem *))rightItemByTapped{
    objc_setAssociatedObject(self, @selector(rightItemByTapped), rightItemByTapped, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)(UIBarButtonItem *))rightItemByTapped{
    return objc_getAssociatedObject(self, @selector(rightItemByTapped));
}

#pragma mark -add item
-(void)addLeftItemWithTitle:(NSString *)title itemByTapped:(void (^)(UIBarButtonItem *))itemByTapped{
    
    self.leftItemByTapped = itemByTapped;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemByClicked:)];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)addLeftItemWithImage:(UIImage *)image itemByTapped:(void (^)(UIBarButtonItem *))itemByTapped{
      self.leftItemByTapped = itemByTapped;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemByClicked:)];
    self.navigationItem.leftBarButtonItem = barItem;
}
-(void)leftBarButtonItemByClicked:(UIBarButtonItem *)item{
    
    if (self.leftItemByTapped) {
        self.leftItemByTapped(item);
    }
}

-(void)addRightItemWithTitle:(NSString *)title itemByTapped:(void (^)(UIBarButtonItem *))itemByTapped{
    self.rightItemByTapped  = itemByTapped;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemByClicked:)];
    self.navigationItem.rightBarButtonItem = barItem;
}
-(void)addRightItemWithImage:(UIImage *)image itemByTapped:(void (^)(UIBarButtonItem *))itemByTapped{
    self.rightItemByTapped  = itemByTapped;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemByClicked:)];
    self.navigationItem.rightBarButtonItem = barItem;
}
-(void)rightBarButtonItemByClicked:(UIBarButtonItem *)item{
    if (self.rightItemByTapped) {
        self.rightItemByTapped(item);
    }
}
#pragma mark -readonly
-(UIBarButtonItem *)leftButtonItem{
    return self.navigationItem.leftBarButtonItem;
}
-(UIBarButtonItem *)rightButtonItem{
    return self.navigationItem.rightBarButtonItem;
}
-(UIBarButtonItem *)backButtonItem{
    return self.navigationItem.backBarButtonItem;
}
@end
