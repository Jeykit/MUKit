//
//  MUNavigationTest.m
//  Pods
//
//  Created by Jekity on 2017/10/13.
//
//

#import "MUNavigation.h"
#import "YYModel.h"
#import <objc/runtime.h>

@interface UINavigationBar(MUNavigation)
/** 设置当前 NavigationBar 背景图片*/
- (void)mu_setBackgroundImage:(UIImage *)image;
/** 设置当前 NavigationBar 背景颜色*/
- (void)mu_setBackgroundColor:(UIColor *)color;

/** 设置当前 NavigationBar 透明度*/
- (void)mu_setBackgroundAlpha:(CGFloat)alpha;
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
    return (UIImageView *)objc_getAssociatedObject(self, @selector(backgroundImageView));
}
- (void)setBackgroundImageView:(UIImageView *)bgImageView {
    objc_setAssociatedObject(self, @selector(backgroundImageView), bgImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_11_0
- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *aView in self.subviews) {
        if ([@[@"_UINavigationBarBackground", @"_UIBarBackground"] containsObject:NSStringFromClass([aView class])]) {
            aView.frame = CGRectMake(0, -CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+CGRectGetMinY(self.frame));
            aView.backgroundColor = [UIColor clearColor];
        }
    }
}
#endif
/** 设置当前 NavigationBar 背景透明度*/
- (void)mu_setBackgroundAlpha:(CGFloat)alpha {
    //     [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.backgroundImageView.alpha = alpha;
    self.backgroundView.alpha      = alpha;
    UIView *barBackgroundView = self.subviews.firstObject;
    barBackgroundView.alpha = alpha;
    if (@available(iOS 11.0, *)) {  // iOS11 下 UIBarBackground -> UIView/UIImageViwe
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass([view class]) containsString:@"_UIBarBackground"]) {
                view.alpha = alpha;
                break;
                //                    view.backgroundColor = [UIColor clearColor];
            }
        }
        // iOS 下如果不设置 UIBarBackground 下的UIView的透明度，会显示不正常
        if (barBackgroundView.subviews.firstObject) {
            barBackgroundView.subviews.firstObject.alpha = alpha;
        }
    }
}
// -> 设置导航栏背景图片
- (void)mu_setBackgroundImage:(UIImage *)image {
    if (!image) {
        return;
    }
    [self.backgroundView removeFromSuperview];
    //    self.backgroundView = nil;
    if (!self.backgroundImageView.superview) {
        // add a image(nil color) to _UIBarBackground make it clear
        if (!self.backgroundImageView) {
            self.translucent = YES;
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)+CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
            //            self.backgroundImageView.userInteractionEnabled = NO;
        }
        //        self.backgroundImageView.userInteractionEnabled = NO;
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

// -> 设置导航栏背景颜色
- (void)mu_setBackgroundColor:(UIColor *)color {
    [self.backgroundImageView removeFromSuperview];
    //    self.backgroundImageView = nil;
    
    if (!self.backgroundView.superview) {
        // add a image(nil color) to _UIBarBackground make it clear
        if (!self.backgroundView) {
            self.translucent = YES;
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
            self.backgroundView.userInteractionEnabled = NO;
        }
        // _UIBarBackground is first subView for navigationBar
        /** iOS11下导航栏不显示问题 */
        if (self.subviews.count > 0) {
            [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
        } else {
            [self insertSubview:self.backgroundView atIndex:0];
        }
    }
    self.backgroundView.backgroundColor = color;
}

-(void)mu_remove{
    
    if (self.backgroundImageView.superview) {
        [self.backgroundImageView removeFromSuperview];
    }
    if (self.backgroundView.superview) {
        [self.backgroundView removeFromSuperview];
    }
}
@end


//hook
void MUHookMethodSubDecrption(const char * originalClassName ,SEL originalSEL ,const char * newClassName ,SEL newSEL){
    
    Class originalClass = objc_getClass(originalClassName);//get a class through a string
    if (originalClass == 0) {
        NSLog(@"I can't find a class through a 'originalClassName'");
        return;
    }
    Class newClass     = objc_getClass(newClassName);
    if (newClass == 0) {
        NSLog(@"I can't find a class through a 'newClassName'");
        return;
    }
    class_addMethod(originalClass, newSEL, class_getMethodImplementation(newClass, newSEL), nil);//if newSEL not found in originalClass,it will auto add a method to this class;
    Method oldMethod = class_getInstanceMethod(originalClass, originalSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(originalClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}
@interface UIViewController (MUNavigations)<UIScrollViewDelegate>
@property(nonatomic, copy)void(^leftItemByTapped)(UIBarButtonItem *item);
@property(nonatomic, copy)void(^rightItemByTapped)(UIBarButtonItem *item);
@property(nonatomic, strong)UILabel *titleLabel;//自定义标题
@end
@implementation UIViewController (MUNavigation)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewWillAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillAppear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewWillDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewWillDisappear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidAppear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidAppear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidDisappear:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidDisappear:)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLayoutSubviews) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLayoutSubviews)];
        [self muHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLoad) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_viewDidLoad)];
    });
}
+(void)muHookMethodViewController:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethodSubDecrption(originalName, originalSEL, newName, newSEL);
}
-(void)mu_viewDidLoad{
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        self.edgesForExtendedLayout = UIRectEdgeBottom;
        if (@available(iOS 11.0, *)) {
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        
    }
    [self mu_viewDidLoad];
}
- (void)mu_viewWillAppear:(BOOL)animated {
    
    [self mu_viewWillAppear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        self.navigationController.navigationBar.userInteractionEnabled = NO;
         self.navigationController.navigationBar.barStyle  = self.barStyleMu;
        [self.navigationController setNavigationBarHidden:self.navigationBarHiddenMu animated:YES];
        [self now_updateNaviagationBarInfo];
        if ([self shouldAddFakeNavigationBar]) {
            [self addFakeNavigationBar];
        }
    }
    
}
- (void)mu_viewDidAppear:(BOOL)animated {
    
    [self mu_viewDidAppear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.navigationController setNavigationBarHidden:self.navigationBarHiddenMu animated:NO];
        [self removeFakeNavigationBar];
        //        [self  updateNaviagationBarInfo];
        
    }
}
// 交换方法 - 将要消失
- (void)mu_viewWillDisappear:(BOOL)animated {
    
    [self mu_viewWillDisappear:animated];
    if ([self canUpdateNavigationBar]) {//判断当前控制器有无导航控制器
        if (self.navigationBarTranslationY > 0) {
            self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
            self.navigationBarTranslationY = 0;
        }
        [self.navigationController setNavigationBarHidden:self.navigationBarHiddenMu animated:YES];
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
    
    //    self.title = self.title;
    if (self.navigationBarTranslucentMu) {
        [self.navigationController.navigationBar mu_setBackgroundAlpha:0];
    }
    if (self.backIndicatorImageMu) {
        self.navigationController.navigationBar.backIndicatorImage = self.backIndicatorImageMu;
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = self.backIndicatorImageMu;
    }
    
    if (!self.showBackBarButtonItemText) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
    }
    if (!self.titleViewMu) {
        if (self.navigationItem.titleView) {
            self.titleLabel.textColor     = self.titleColorMu;
            self.titleLabel.text          = self.title;
            self.titleLabel.font          = self.titleFontMu;
            [self.titleLabel sizeToFit];
        }else{
            self.navigationItem.titleView = self.titleLabel;
            self.titleLabel.textColor     = self.titleColorMu;
            self.titleLabel.text          = self.title;
            self.titleLabel.font          = self.titleFontMu;
            [self.titleLabel sizeToFit];
        }
    }else{
        self.navigationItem.titleView = self.titleViewMu;
    }
    
    //    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.titleColorMu};
    self.navigationController.navigationBar.tintColor = self.navigationBarTintColor;
//    self.navigationController.navigationBar.barStyle  = self.barStyleMu;
    [self  updateNaviagationBarInfo];
    
    
}
//标题
-(void)setTitleLabel:(UILabel *)titleLabel{
    
    objc_setAssociatedObject(self, @selector(titleLabel), titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILabel *)titleLabel{
    
    id object = objc_getAssociatedObject(self, @selector(titleLabel));
    if (!object) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        self.titleLabel = label;
        return label;
    }
    return object;
}
-(void)setTitleFontMu:(UIFont *)titleFontMu{
    self.titleLabel.font = titleFontMu;
    objc_setAssociatedObject(self, @selector(titleFontMu), titleFontMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIFont *)titleFontMu{
     UIFont *font = objc_getAssociatedObject(self, @selector(titleFontMu));
    font = font?:[UIFont systemFontOfSize:20.];
    return font;
}
//更新navigationBar info
-(void)updateNaviagationBarInfo{
    if (self.navigationBarHiddenMu||self.navigationBarTranslucentMu) {
        return;
    }
    if (!self.navigationBarTranslucentMu) {
        [self.navigationController.navigationBar mu_setBackgroundAlpha:self.navigationBarAlphaMu];
    }
    [self showBottomLineInView:self.navigationController.navigationBar hidden:self.navigationBarShadowImageHiddenMu];
    
    if (!self.fakeNavigationBar) {
        if (self.navigationBarBackgroundImageMu) {
            [self.navigationController.navigationBar mu_setBackgroundImage:self.navigationBarBackgroundImageMu ];
        }else{
            [self.navigationController.navigationBar mu_setBackgroundColor:self.navigationBarBackgroundColorMu];
        }
    }
    
}
- (BOOL)canUpdateNavigationBar {
    // 如果当前有导航栏//且没有手动设置隐藏导航栏
    if (self.navigationController&&[NSStringFromClass([self.navigationController class]) isEqualToString:NSStringFromClass([UINavigationController class])]) {//如果有自定义的导航栏则过滤掉
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
#pragma mark -判断两张图片是否相同
-(BOOL)imageEqualToImageMu:(UIImage *)image anotherImage:(UIImage *)anotherImage{
    NSData *orginalData = UIImagePNGRepresentation(image);
    NSData *anotherData = UIImagePNGRepresentation(anotherImage);
    if ([orginalData isEqual:anotherData]) {
        return YES;
    }
    return NO;
}
//判断颜色是否一致
-(BOOL)colorEqualToColorMu:(UIColor *)color anotherColor:(UIColor *)anotherColor{
    if (CGColorEqualToColor(color.CGColor, anotherColor.CGColor)) {
        return YES;
    }
    return NO;
}
-(BOOL)colorEqualToColor:(UIViewController *)viewController{
    return  [self colorEqualToColorMu:viewController.navigationBarBackgroundColorMu anotherColor:viewController.navigationController.navigationBarBackgroundColorMu];
}
-(BOOL)imageEqualToImage:(UIViewController *)viewController{
    return  [self imageEqualToImageMu:viewController.navigationBarBackgroundImageMu anotherImage:viewController.navigationController.navigationBarBackgroundImageMu];
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
        toViewController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : toViewController.titleColorMu};
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
    if (viewController.navigationBarBackgroundColorMu || viewController.navigationBarBackgroundImageMu) {
        mu_y = -self.navigationBarAndStatusBarHeight;
    }
    if ([viewController.view isKindOfClass:[UIScrollView class]]) {//tableView默认是打开裁剪的，必需关闭，否则假的navigationbar就会被裁剪，而达不到逾期效果
        viewController.tempClipsToBounds   = viewController.view.clipsToBounds;
        viewController.view.clipsToBounds = NO;
        UIScrollView *tableView = (UIScrollView *)viewController.view;
        mu_y  += tableView.contentOffset.y;
    }
    
    viewController.fakeNavigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, mu_y, CGRectGetWidth([UIScreen mainScreen].bounds), self.navigationBarAndStatusBarHeight)];
    if (viewController.navigationBarTranslucentMu) {
        viewController.fakeNavigationBar.alpha = 0.;
        viewController.fakeNavigationBar.image = nil;
        viewController.fakeNavigationBar.backgroundColor = [UIColor clearColor];
    }else{
        viewController.fakeNavigationBar.alpha = viewController.navigationBarAlphaMu;
        viewController.fakeNavigationBar.userInteractionEnabled = NO;
    }
    
    if (!viewController.navigationBarTranslucentMu) {
        viewController.fakeNavigationBar.image           = viewController.navigationBarBackgroundImageMu;
        viewController.fakeNavigationBar.backgroundColor = viewController.navigationBarBackgroundColorMu;
    }
    [viewController.view addSubview:viewController.fakeNavigationBar];
    [viewController.view bringSubviewToFront:viewController.fakeNavigationBar];
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
    self.titleLabel.textColor = titleColorMu;
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
//自定义titleView
-(UIView *)titleViewMu{
    return objc_getAssociatedObject(self, @selector(titleViewMu));
}
-(void)setTitleViewMu:(UIView *)titleViewMu{
    objc_setAssociatedObject(self, @selector(titleViewMu), titleViewMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//返回按钮图片
-(void)setBackIndicatorImageMu:(UIImage *)backIndicatorImageMu{
    objc_setAssociatedObject(self, @selector(backIndicatorImageMu), backIndicatorImageMu, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)backIndicatorImageMu{
    id object = objc_getAssociatedObject(self, @selector(backIndicatorImageMu));
    object = object?:self.navigationController.backIndicatorImageMu?:nil;
    return object;
}
//导航栏偏移距离
-(CGFloat)navigationBarTranslationY{
    id object = objc_getAssociatedObject(self, @selector(navigationBarTranslationY));
    CGFloat y = object?[object doubleValue]:0;
    return y;
}
-(void)setNavigationBarTranslationY:(CGFloat)navigationBarTranslationY{
    if (navigationBarTranslationY > 0) {
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -navigationBarTranslationY);
    }else{
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    }
   
    objc_setAssociatedObject(self, @selector(navigationBarTranslationY), @(navigationBarTranslationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//透明导航栏
-(void)setNavigationBarTranslucentMu:(BOOL)navigationBarTranslucentMu{
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    objc_setAssociatedObject(self, @selector(navigationBarTranslucentMu), [NSNumber numberWithBool:navigationBarTranslucentMu], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)navigationBarTranslucentMu{
    id object = objc_getAssociatedObject(self, @selector(navigationBarTranslucentMu));
    return object?[object boolValue]:NO;
}
//透明度变化
-(void)setNavigationBarAlphaMu:(CGFloat)navigationBarAlphaMu{
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self.navigationController.navigationBar mu_setBackgroundAlpha:navigationBarAlphaMu];
    objc_setAssociatedObject(self, @selector(navigationBarAlphaMu), @(navigationBarAlphaMu), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CGFloat)navigationBarAlphaMu{
    
    id object = objc_getAssociatedObject(self, @selector(navigationBarAlphaMu));
    return object?[object floatValue]:1.;
}
//显示返回按钮文字
-(BOOL)showBackBarButtonItemText{
    id object = objc_getAssociatedObject(self, @selector(showBackBarButtonItemText));
    return object?[object boolValue]:self.navigationController.showBackBarButtonItemText;
}
-(void)setShowBackBarButtonItemText:(BOOL)showBackBarButtonItemText{
    objc_setAssociatedObject(self, @selector(showBackBarButtonItemText), @(showBackBarButtonItemText), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

#pragma mark -设置左右Item
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
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemByClicked:)];
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


//push&处理
@implementation UINavigationController (MUNavigationExtension)

-(void)pushViewControllerMu:(UIViewController *)viewController animated:(BOOL)animated parameters:(void (^)(NSMutableDictionary *))parameter{
    if (!viewController) {
        
        return;
    }
    NSMutableDictionary * dict= [NSMutableDictionary dictionary];
    if (parameter) {
        parameter(dict);
    }
    [viewController yy_modelSetWithDictionary:dict];
    [self pushViewController:viewController animated:animated];
}

-(void)pushViewControllerStringMu:(NSString *)controllerString animated:(BOOL)animated parameters:(void (^)(NSMutableDictionary *))parameter{
    if (!controllerString) {
        return;
    }
    UIViewController *controller = [NSClassFromString(controllerString) new];
    NSMutableDictionary * dict= [NSMutableDictionary dictionary];
    if (parameter) {
        parameter(dict);
    }
    [controller yy_modelSetWithDictionary:dict];
    [self pushViewController:controller animated:animated];
}
@end

//适配iOS11
@implementation UIScrollView (MUNavigationExtension)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self muHookMethodSrollView:NSStringFromClass([self class]) orignalSEL:@selector(initWithFrame:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_AdjustmentBehaviorInitWithFrame:)];
        
        
    });
}
+(void)muHookMethodSrollView:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethodSubDecrption(originalName, originalSEL, newName, newSEL);
}
-(void)mu_AdjustmentBehaviorInitWithFrame:(CGRect)frame{
    if (@available(iOS 11.0, *)) {
        if ([self isKindOfClass:[UIScrollView class]]) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    [self mu_AdjustmentBehaviorInitWithFrame:frame];
}
@end

