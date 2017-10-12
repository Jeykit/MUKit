//
//  MUNavigation.m
//  Pods
//
//  Created by Jekity on 2017/10/12.
//
//

#import "MUNavigation.h"
#import <objc/runtime.h>
#import "MUHookMethodHelper.h"
#import "UIColor+MUColor.h"

@implementation UINavigationBar (MUNavigation)

//really backgroundView and backgroundImage
- (UIView *)backgroundView {
    return (UIView *)objc_getAssociatedObject(self, @selector(backgroundView));
}
- (void)setBackgroundView:(UIView *)backgroundView {
    objc_setAssociatedObject(self, @selector(backgroundView), backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)backgroundImageView {
    return objc_getAssociatedObject(self, @selector(backgroundImageView));
}
- (void)setBackgroundImageView:(UIImageView *)bgImageView {
    objc_setAssociatedObject(self, @selector(backgroundImageView), bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -NavigationBar alpha
-(void)mu_setBackgroundAlpha:(CGFloat)alpha{
   
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
    
    if ([UIDevice.currentDevice.systemVersion compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {  // iOS11 下 UIBarBackground -> UIView/UIImageViwe
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass([view class]) containsString:@"UIbarBackGround"]) {
                view.alpha = 0;
            }
        }
        // iOS 11下如果不设置 UIBarBackground 下的UIView的透明度，会显示不正常
        if (barBackgroundView.subviews.firstObject) {
            barBackgroundView.subviews.firstObject.alpha = alpha;
        }
    }
}
#pragma mark -NavigationBar background image
-(void)mu_setBackgroundImage:(UIImage *)image{
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    if (!self.backgroundImageView) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
        self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  // ****
        // _UIBarBackground is first subView for navigationBar
        /** iOS11下导航栏不显示问题 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundImageView atIndex:0];
        } else {
            [self insertSubview:self.backgroundImageView atIndex:0];
        }
    }
    self.backgroundImageView.image = image;
}

#pragma mark -NavigationBar background color
-(void)mu_setBackgroundColor:(UIColor *)color{
    [self.backgroundImageView removeFromSuperview];
    self.backgroundImageView = nil;
    if (!self.backgroundView) {
        // add a image(nil color) to _UIBarBackground make it clear
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;      // ****
        // _UIBarBackground is first subView for navigationBar
        /**adapt iOS11 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
        } else {
            [self insertSubview:self.backgroundView atIndex:0];
        }
    }
    self.backgroundView.backgroundColor = color;
}

#pragma mark -all NavigationBarItem alpha
-(void)mu_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator{
    for (UIView *view in self.subviews) {
        if (hasSystemBackIndicator == YES) {
            // _UIBarBackground/_UINavigationBarBackground
            Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
            if (_UIBarBackgroundClass != nil) {
                if (![view isKindOfClass:_UIBarBackgroundClass]) {
                    view.alpha = alpha;
                }
            }
            Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
            if (_UINavigationBarBackground != nil) {
                if (![view isKindOfClass:_UINavigationBarBackground]) {
                    view.alpha = alpha;
                }
            }
        } else {
            // if you are not do this which will show backIndicatorImage
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] == NO) {
                Class _UIBarBackgroundClass = NSClassFromString(@"_UIBarBackground");
                if (_UIBarBackgroundClass != nil) {
                    if (![view isKindOfClass:_UIBarBackgroundClass]) {
                        view.alpha = alpha;
                    }
                }
                Class _UINavigationBarBackground = NSClassFromString(@"_UINavigationBarBackground");
                if (_UINavigationBarBackground != nil) {
                    if (![view isKindOfClass:_UINavigationBarBackground]) {
                        view.alpha = alpha;
                    }
                }
            }
        }
    }

}
@end

// -----------------------------------------------------------------------------
/** 因为在 UINavigationController 中使用了 VC 中的扩展方法，所以需要提到上面来声明，否则无法调用*/
@interface UIViewController (MUNavigation_extension)
// 设置当前 push 是否完成
- (void)setPushToCurrentViewControllerFinished:(BOOL)isFinished;
// 当前 VC 是否需要添加一个假的NavigationBar
- (BOOL)shouldAddFakeNavigationBar;
@end
@implementation UINavigationController (MUNavigation)

static CGFloat const muPopDuration = 0.12;       // 侧滑动画时间
static int muPopDisplayCount = 0;
- (CGFloat)muPopProgress {
    CGFloat all = 60 * muPopDuration;
    int current = MIN(all, muPopDisplayCount);
    return current / all;
}

static CGFloat muPushDuration = 0.10;
static int muPushDisplayCount = 0;
// 当前 push 进度
- (CGFloat)muPushProgress {
    CGFloat all = 60 * muPushDuration;
    int current = MIN(all, muPushDisplayCount);
    return current / all;
}
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:NSSelectorFromString(@"_updateInteractiveTransition:") newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_updateInteractiveTransition:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(popToViewController:animated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_popToViewController:animated:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(popToRootViewControllerAnimated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_popToRootViewControllerAnimated:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(pushViewController:animated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_pushViewController:animated:)];
    });
}

// 交换方法 - 监听侧滑手势进度
- (void)mu_updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *fromViewController = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    [self updateNavigationBarWithFromViewController:fromViewController toViewController:toViewController progress:percentComplete];
    [self mu_updateInteractiveTransition:percentComplete];
}

// 交换方法 - pop To VC
- (NSArray<UIViewController *> *)mu_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        muPopDisplayCount = 0;//reset when done
    }];
    [CATransaction setAnimationDuration:muPopDuration];
    [CATransaction begin];
    NSArray<UIViewController *> *viewControllers = [self mu_popToViewController:viewController animated:animated];
    [CATransaction commit];
    return viewControllers;
}
// 交换方法 - pop Root VC
- (NSArray<UIViewController *> *)mu_popToRootViewControllerAnimated:(BOOL)animated {
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(popNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        muPopDisplayCount = 0;//reset when done
    }];
    [CATransaction setAnimationDuration:muPopDuration];
    [CATransaction begin];
    
    NSArray<UIViewController *> *viewControllers = [self mu_popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return viewControllers;
}
// 交换方法 - push VC
- (void)mu_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //
    __block CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(pushNeedDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [CATransaction setCompletionBlock:^{
        [displayLink invalidate];
        displayLink = nil;
        muPushDisplayCount = 0;//reset when done
        [viewController setPushToCurrentViewControllerFinished:YES];
    }];
    [CATransaction setAnimationDuration:muPushDuration];
    [CATransaction begin];
    [self mu_pushViewController:viewController animated:animated];
    [CATransaction commit];
}
// pop
- (void)popNeedDisplay {
    if (self.topViewController != nil && self.topViewController.transitionCoordinator != nil) {
        muPopDisplayCount += 1;
        CGFloat popProgress = [self muPopProgress];
        UIViewController *fromViewController = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromViewController:fromViewController toViewController:toViewController progress:popProgress];
    }
}
// push
- (void)pushNeedDisplay {
    if (self.topViewController && self.topViewController.transitionCoordinator != nil) {
        muPushDisplayCount += 1;
        CGFloat pushProgress = [self muPushProgress];
        UIViewController *fromViewController = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        [self updateNavigationBarWithFromViewController:fromViewController toViewController:toViewController progress:pushProgress];
    }
}
// ** 根据进度更新导航栏 **
- (void)updateNavigationBarWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController progress:(CGFloat)progress{
    
    if (fromViewController.barHiddenMu || toViewController.barHiddenMu) {
        return;
    }
    if (fromViewController.barBackgroundImageMu || toViewController.barBackgroundImageMu) {
        return;
    }
    if (fromViewController.barAlphaMu != toViewController.barAlphaMu) {
        return;
    }
    // 颜色过渡
    {
        // 导航栏按钮颜色
        UIColor *fromTintColor = fromViewController.barTintColorMu;
        UIColor *toTintColor   = toViewController.barTintColorMu;
        UIColor *newTintColor  = [UIColor colorWithMixing:fromTintColor toColor:toTintColor percent:progress];
        [self setNeedsNavigationBarUpdateForTintColor:newTintColor];
        
        // 导航栏标题颜色
        UIColor *fromTitleColor = fromViewController.titleColorMu;
        UIColor *toTitleColor   = toViewController.titleColorMu;
        UIColor *newTitleColor  = [UIColor colorWithMixing:fromTitleColor toColor:toTitleColor percent:progress];
        [self setNeedsNavigationBarUpdateForTitleColor:newTitleColor];
        
        // 导航栏背景颜色
        UIColor *fromBarTintColor = fromViewController.barBackgroundColorMu;
        UIColor *toBarTintColor   = toViewController.barBackgroundColorMu;
        UIColor *newBarTintColor  = [UIColor colorWithMixing:fromBarTintColor toColor:toBarTintColor percent:progress];
        [self setNeedsNavigationBarUpdateForBarTintColor:newBarTintColor];
        // 导航栏背景透明度
        CGFloat fromBarBackgroundAlpha = fromViewController.barAlphaMu;
        CGFloat toBarBackgroundAlpha   = toViewController.barAlphaMu;
        CGFloat newBarBackgroundAlpha  = [self alphaWithMixing:fromBarBackgroundAlpha toAlpha:toBarBackgroundAlpha percent:progress];
        [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:newBarBackgroundAlpha];
    }
}
#pragma mark - deal the gesture of return
// 导航栏返回按钮点击
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    __weak typeof (self) weakSelf = self;
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    if ([coor initiallyInteractive]) {
        NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
        if ([sysVersion floatValue] >= 10) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        } else {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) pThis = weakSelf;
                [pThis dealInteractionChanges:context];
            }];
        }
        return YES;
    }
    
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    [self popToViewController:popToVC animated:YES];
    return YES;
}
// 处理侧滑手势
- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    void (^animations) (UITransitionContextViewControllerKey) = ^(UITransitionContextViewControllerKey key) {
        if (![self.topViewController shouldAddFakeNavigationBar]) {
            UIColor *curColor = [[context viewControllerForKey:key] barBackgroundColorMu];
            CGFloat curAlpha = [[context viewControllerForKey:key] barAlphaMu];
            [self setNeedsNavigationBarUpdateForBarTintColor:curColor];
            [self setNeedsNavigationBarUpdateForBarBackgroundAlpha:curAlpha];
        }
    };
    
    if ([context isCancelled]) {        // 自动取消侧滑手势
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            animations(UITransitionContextFromViewControllerKey);
        }];
    } else {                            // 自动完成侧滑手势
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            animations(UITransitionContextToViewControllerKey);
        }];
    }
}
- (CGFloat)alphaWithMixing:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha percent:(CGFloat)percent {
    return fromAlpha + (toAlpha - fromAlpha) * percent;
}
#pragma mark - setter
// -> 设置当前导航栏需要改变导航栏背景透明度
- (void)setNeedsNavigationBarUpdateForBarBackgroundAlpha:(CGFloat)barBackgroundAlpha {
    [self.navigationBar mu_setBackgroundAlpha:barBackgroundAlpha];
}
// -> 设置当前导航栏背景图片
- (void)setNeedsNavigationBarUpdateForBarBackgroundImage:(UIImage *)backgroundImage {
    [self.navigationBar mu_setBackgroundImage:backgroundImage];
}
// -> 设置当前导航栏 barTintColor | 导航栏背景颜色
- (void)setNeedsNavigationBarUpdateForBarTintColor:(UIColor *)barTintColor {
    [self.navigationBar mu_setBackgroundColor:barTintColor];
}
// -> 设置当前导航栏的 TintColor | 按钮颜色
- (void)setNeedsNavigationBarUpdateForTintColor:(UIColor *)tintColor {
    self.navigationBar.tintColor = tintColor;
}
// -> 设置当前导航栏 titleColor | 标题颜色
- (void)setNeedsNavigationBarUpdateForTitleColor:(UIColor *)titleColor {
    NSDictionary *titleTextAttributes = [self.navigationBar titleTextAttributes];
    if (titleTextAttributes == nil) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
        return;
    }
    NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
    newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
    self.navigationBar.titleTextAttributes = newTitleTextAttributes;
}
// -> 设置当前导航栏 shadowImageHidden
- (void)setNeedsNavigationBarUpdateForShadowImageHidden:(BOOL)hidden {
    self.navigationBar.shadowImage = hidden ? [UIImage new] : nil;
}
#pragma mark - 状态栏 -----------------------------------------------------------
- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}
#pragma mark - 屏幕旋转相关 ------------------------------------------------------
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
// 横屏后设置是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}
// 默认的屏幕方向（当前 ViewController 必须是通过模态出来的 UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
@implementation UIViewController (MUNavigation)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewWillAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillAppear:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewWillDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillDisappear:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidAppear:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidDisappear:)];
        
         [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLoad) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLoad)];
    });
}
-(void)mu_viewDidLoad{
    
    if ([self canUpdateNavigationBar]) {
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
    [self mu_viewDidLoad];
}
- (void)mu_viewWillAppear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        self.willDisappear = NO;
        [self.navigationController setNavigationBarHidden:self.barHiddenMu animated:YES];
        if ([self shouldAddFakeNavigationBar]) {
            [self addFakeNavigationBar];
        }
        if (!self.barHiddenMu) {
            [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:self.barShadowImageHiddenMu];
            [self.navigationController setNeedsNavigationBarUpdateForTintColor:self.barTintColorMu];
            [self.navigationController setNeedsNavigationBarUpdateForTitleColor:self.titleColorMu];
        }
    }
    [self mu_viewWillAppear:animated];
}

- (void)mu_viewDidAppear:(BOOL)animated {
    

    if ([self canUpdateNavigationBar]) {
        
        [self.navigationController setNavigationBarHidden:self.barHiddenMu animated:NO];
        [self removeFakeNavigationBar];
        [self updateNavigationInfo];
    }
    [self mu_viewDidAppear:animated];
}
// 交换方法 - 将要消失
- (void)mu_viewWillDisappear:(BOOL)animated {
    if ([self canUpdateNavigationBar]) {
        
        self.willDisappear = YES;
        [self.navigationController setNavigationBarHidden:self.barHiddenMu animated:YES];
        // 更新导航栏信息
        if (!self.barHiddenMu) {
            [self.navigationController setNeedsNavigationBarUpdateForTintColor:self.barTintColorMu];
            [self.navigationController setNeedsNavigationBarUpdateForTitleColor:self.titleColorMu];
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:self.barAlphaMu];
        }
        
    }
    [self mu_viewWillDisappear:animated];
}
// 交换方法 - 已经消失
- (void)mu_viewDidDisappear:(BOOL)animated {
    [self removeFakeNavigationBar];
    [self mu_viewDidDisappear:animated];
}
// 更新导航栏
- (void)updateNavigationInfo {
    if (self.barHiddenMu) {
        return;
    }
    if (!self.fakeNavigationBar) {
        if (self.barBackgroundImageMu) {
            [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundImage:self.barBackgroundImageMu];
        } else {
            [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:self.barBackgroundColorMu];
        }
    }
    [self.navigationController setNeedsNavigationBarUpdateForTintColor:self.barTintColorMu];
    [self.navigationController setNeedsNavigationBarUpdateForTitleColor:self.titleColorMu];
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:self.barAlphaMu];
    
}
// 是否需要添加一个假的 NavigationBar
- (BOOL)shouldAddFakeNavigationBar {
    // 判断当前导航栏交互的两个VC其中是否设置了导航栏样式为两种颜色导航栏，或者设置了导航栏背景图片，或者透明度不一致(用过渡不好看..)
    UIViewController *fromViewController = [self fromViewController];
    UIViewController *toViewController   = [self toViewController];
    if ((fromViewController && fromViewController.barBackgroundImageMu) ||
        (toViewController && toViewController.barBackgroundImageMu) ||
        fromViewController.barHiddenMu != toViewController.barHiddenMu ||
        fromViewController.barAlphaMu != toViewController.barAlphaMu) {
        return YES;
    }
    return NO;
}
// 添加一个假的 NavigationBar
- (void)addFakeNavigationBar {
    UIViewController *fromViewController = [self fromViewController];
    UIViewController *toViewController   = [self toViewController];
    
    [fromViewController removeFakeNavigationBar];
    [toViewController removeFakeNavigationBar];
    
    if (!fromViewController.fakeNavigationBar && !fromViewController.barHiddenMu) {
        [self setupFakeNavigarionBar:fromViewController];
    }
    if (!toViewController.fakeNavigationBar && !toViewController.barHiddenMu) {
        [self setupFakeNavigarionBar:toViewController];
    }
}
-(void)removeFakeNavigationBar{
    
    if (self.fakeNavigationBar) {
//        [self.navigationController setNavigationBarHidden:NO];
        [self.fakeNavigationBar removeFromSuperview];
        self.fakeNavigationBar = nil;
    }
}
#pragma mark - private method --------------------------------------------------
-(void)setupFakeNavigarionBar:(UIViewController *)viewController{
    //导航控制器会让viewcontroller向下偏移
//    [viewController.navigationController setNavigationBarHidden:YES];
    CGFloat height = self.navigationBarAndStatusBarHeight;
    viewController.fakeNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, -height, CGRectGetWidth(self.view.bounds),
                                                                                     height)];
    viewController.fakeNavigationBar.backgroundColor = viewController.barBackgroundColorMu;
    viewController.fakeNavigationBar.image           = viewController.barBackgroundImageMu;
    viewController.fakeNavigationBar.alpha           = viewController.barAlphaMu;
    [viewController.view addSubview:viewController.fakeNavigationBar];
    [viewController.view bringSubviewToFront:viewController.fakeNavigationBar];
    //
    [viewController.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:0.0f];
}
-(UIViewController *)fromViewController{
     return [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
}
-(UIViewController *)toViewController{
     return [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
}
- (BOOL)canUpdateNavigationBar {
    // 如果当前有导航栏，且当前是全屏，//且没有手动设置隐藏导航栏
   
//    if (self.navigationController &&
//        (CGRectEqualToRect(self.view.frame, [UIScreen mainScreen].bounds))) {
//        return YES;
//    }
    if (self.navigationController) {
        return YES;
    }
//    CGRect rect = [UIScreen mainScreen].bounds;
//    rect.origin.y     = self.navigationBarAndStatusBarHeight;
//    rect.size.height -= self.navigationBarAndStatusBarHeight;
//    NSLog(@"rect=======%@",NSStringFromCGRect(rect));
//    NSLog(@"frame=======%@",NSStringFromCGRect(self.view.frame));
//    if (self.navigationController && CGRectEqualToRect(self.view.frame, rect)) {
//        
//        return YES;
//    }
    return NO;
}
- (CGFloat)navigationBarAndStatusBarHeight{
    return CGRectGetHeight(self.navigationController.navigationBar.bounds) +
    CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}
- (UIImageView *)fakeNavigationBar {
    return (UIImageView *)objc_getAssociatedObject(self, @selector(fakeNavigationBar));
}
- (void)setFakeNavigationBar:(UIImageView *)navigationBar
{
    objc_setAssociatedObject(self, @selector(fakeNavigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//是否已经push完成
-(void)setPushToCurrentViewControllerFinished:(BOOL)isFinished{
    objc_setAssociatedObject(self, @selector(pushToCurrentViewControllerFinished), @(isFinished), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)pushToCurrentViewControllerFinished{
    id object = objc_getAssociatedObject(self, @selector(pushToCurrentViewControllerFinished));
    return object?[object boolValue] : NO;
}
/** 是否将要消失*/
- (void)setWillDisappear:(BOOL)disappear {
    objc_setAssociatedObject(self, @selector(willDisappear), @(disappear), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)willDisappear {
    id isShowing = objc_getAssociatedObject(self, @selector(willDisappear));
    return isShowing ? [isShowing boolValue] : NO;
}
//bar hidden
-(void)setBarHiddenMu:(BOOL)barHiddenMu{
    
    objc_setAssociatedObject(self, @selector(barHiddenMu), @(barHiddenMu), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)barHiddenMu{
   return [objc_getAssociatedObject(self, @selector(barHiddenMu)) boolValue];
}
//title color
-(void)setTitleColorMu:(UIColor *)titleColorMu{
    objc_setAssociatedObject(self, @selector(titleColorMu), titleColorMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.willDisappear) {
        [self.navigationController setNeedsNavigationBarUpdateForTitleColor:titleColorMu];
    }
}
-(UIColor *)titleColorMu{
    
//    NSDictionary *titleTextAttributes = [self.navigationController.navigationBar titleTextAttributes];
    UIColor *color = objc_getAssociatedObject(self, @selector(titleColorMu));
//    color          = color ? : titleTextAttributes?titleTextAttributes[NSForegroundColorAttributeName]:[UIColor blackColor];
    color          = color ? : [UIColor blackColor];
    return color;
}

//bar tint color
-(void)setBarTintColorMu:(UIColor *)barTintColorMu{
    objc_setAssociatedObject(self, @selector(barTintColorMu), barTintColorMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.willDisappear) {
        [self.navigationController setNeedsNavigationBarUpdateForTintColor:barTintColorMu];
    }
}
-(UIColor *)barTintColorMu{
    UIColor *color = objc_getAssociatedObject(self, @selector(barTintColorMu));
    color          = color ? : [UINavigationBar new].tintColor;
    return color;

}

//bar alpha
-(void)setBarAlphaMu:(CGFloat)barAlphaMu{
    objc_setAssociatedObject(self, @selector(barAlphaMu), @(barAlphaMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNeedsNavigationBarUpdateForBarBackgroundAlpha:barAlphaMu];
}
-(CGFloat)barAlphaMu{
    id barBackgroundAlpha = objc_getAssociatedObject(self, @selector(barAlphaMu));
    return barBackgroundAlpha ? [barBackgroundAlpha floatValue] : 1.0;
}

// status bar style
-(void)setStatusBarStyleMu:(UIStatusBarStyle)statusBarStyleMu{
    objc_setAssociatedObject(self, @selector(statusBarStyleMu), @(statusBarStyleMu), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsStatusBarAppearanceUpdate];
}
-(UIStatusBarStyle)statusBarStyleMu{
    NSUInteger style = [objc_getAssociatedObject(self, @selector(statusBarStyleMu)) integerValue];
    return style == 1 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyleMu;
}

//bar background Image
-(void)setBarBackgroundImageMu:(UIImage *)barBackgroundImageMu{
    objc_setAssociatedObject(self, @selector(backgroundImage), barBackgroundImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)barBackgroundImageMu{
    return objc_getAssociatedObject(self, @selector(barBackgroundImageMu));
}

//bar background Color
-(void)setBarBackgroundColorMu:(UIColor *)barBackgroundColorMu{
    objc_setAssociatedObject(self, @selector(barBackgroundColorMu), barBackgroundColorMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.pushToCurrentViewControllerFinished && !self.willDisappear) {
        [self.navigationController setNeedsNavigationBarUpdateForBarTintColor:barBackgroundColorMu];
    }
}
-(UIColor *)barBackgroundColorMu{
     UIColor *backgroundColor = objc_getAssociatedObject(self, @selector(barBackgroundColorMu));
    if (!backgroundColor) {//push
        UIViewController *fromViewController = [self fromViewController];
        backgroundColor = fromViewController.barBackgroundColorMu?:[UIColor whiteColor];
        objc_setAssociatedObject(self, @selector(barBackgroundColorMu), backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [backgroundColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    NSLog(@"red===%f,green====%f")
    return backgroundColor?:[UIColor whiteColor];
}

//bar shadow Image
-(void)setBarShadowImageHiddenMu:(BOOL)barShadowImageHiddenMu{
     objc_setAssociatedObject(self, @selector(barShadowImageHiddenMu), @(barShadowImageHiddenMu), OBJC_ASSOCIATION_ASSIGN);
    [self.navigationController setNeedsNavigationBarUpdateForShadowImageHidden:barShadowImageHiddenMu];
}
-(BOOL)barShadowImageHiddenMu{
     return [objc_getAssociatedObject(self, @selector(barShadowImageHiddenMu)) boolValue];
}
@end
