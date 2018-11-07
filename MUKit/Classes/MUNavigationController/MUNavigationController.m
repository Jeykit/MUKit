//
//  MUNavigationController.m
//  AFNetworking
//
//  Created by Jekity on 2018/11/6.
//

#import "MUNavigationController.h"
#import "MUScreenShotView.h"
#import <objc/runtime.h>


#define MUNavigationScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define MUNavigationScreenHeight ([UIScreen mainScreen].bounds.size.height)


//hook
void MUNAvigationHookMethodSubDecrption(const char * originalClassName ,SEL originalSEL ,const char * newClassName ,SEL newSEL){
    
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


@interface MUNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) MUScreenShotView *shotView;

@property (nonatomic,strong) UIViewController *controller;

@property (nonatomic,strong) NSArray *tempArray;

@property (strong, nonatomic) dispatch_source_t timer;
@property (nonatomic,assign) CGFloat duration;

@end

@implementation MUNavigationController
+(void)muNaviagtionHookMethodViewController:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUNAvigationHookMethodSubDecrption(originalName, originalSEL, newName, newSEL);
}
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self muNaviagtionHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(popViewControllerAnimated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_popViewControllerAnimated:)];
        
        [self muNaviagtionHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(popToRootViewControllerAnimated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_popToRootViewControllerAnimated:)];
        
        [self muNaviagtionHookMethodViewController:NSStringFromClass([self class]) orignalSEL:@selector(popToViewController:animated:) newClassName:NSStringFromClass([self class]) newSEL: @selector(mu_popToViewController:animated:)];
        
    });
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.delegate = self;
    [self.interactivePopGestureRecognizer setEnabled:NO];
    self.animationType = MUNavigationAnimationTypeSlider;
    
    self.distanceLeft = 80;
    self.maskViewAlpha = 0.4;
    self.scaleViewFloat = 0.95;
    self.shadowOpacity = 0.3;
    self.duration = 0.3;
    
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesListener:)];
    panGesture.delegate = self;
    
    [self.view addGestureRecognizer:panGesture];
}

- (void)dealloc{
    _tempArray = nil;
    _controller = nil;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _tempArray = nil;
    _controller = nil;
}

- (MUScreenShotView *)shotView{
    
    if (!_shotView) {
        _shotView = [[MUScreenShotView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [[[UIApplication sharedApplication] delegate].window insertSubview:_shotView atIndex:0];
    }
    return _shotView;
}
#pragma mark - UIPanGestureRecognizerListener

- (void)panGesListener:(UIPanGestureRecognizer *)panGes{
    
    _tempArray = nil;
    _controller = nil;
    if (self.viewControllers.count <= 1 || ![self respondsToSelector:@selector(isPassed)]) return;
    UIView *topView = self.view;
    
    MUScreenShotView *shotView = self.shotView;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        CGPoint pt2 = [panGes translationInView:self.view];
        if (pt2.x < 0) return;
        [topView endEditing:YES];
        topView.layer.shadowColor = [UIColor blackColor].CGColor;
        topView.layer.shadowOffset = CGSizeMake(-4, 0);
        topView.layer.shadowOpacity = self.shadowOpacity;
        
    }else if(panGes.state == UIGestureRecognizerStateChanged){
        CGPoint pt = [panGes translationInView:self.view];
        if (pt.x >= 10) {
            topView.transform = CGAffineTransformMakeTranslation(pt.x - 10, 0);
            
            shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:-pt.x / MUNavigationScreenWidth * 0.4 + self.maskViewAlpha];
            
            if (self.animationType == MUNavigationAnimationTypeScale) {
                shotView.imageView.transform = CGAffineTransformMakeScale(self.scaleViewFloat + (pt.x / MUNavigationScreenWidth * 0.05), 0.95 + (pt.x / MUNavigationScreenWidth * 0.05));
            }else{
                shotView.imageView.transform = CGAffineTransformMakeTranslation(pt.x *0.5-MUNavigationScreenWidth/2 , 0);
            }
        }
    }
    else if (panGes.state == UIGestureRecognizerStateEnded){
        CGPoint pt = [panGes translationInView:self.view];
        if (pt.x >= self.distanceLeft) {
            
            [UIView animateWithDuration:self.duration animations:^{
                topView.transform = CGAffineTransformMakeTranslation(MUNavigationScreenWidth, 0);
                shotView.imageView.transform = CGAffineTransformMakeTranslation(0 , 0);
                shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
                
            } completion:^(BOOL finished) {
                [self mu_popViewControllerAnimated:NO];
                topView.transform = CGAffineTransformIdentity;
                topView.layer.shadowOpacity = 0;
            }];
            
        }else{
            [UIView animateWithDuration:self.duration animations:^{
                shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:self.maskViewAlpha];
                topView.transform = CGAffineTransformIdentity;
                if (self.animationType == MUNavigationAnimationTypeScale) {
                    shotView.imageView.transform = CGAffineTransformMakeScale(self.scaleViewFloat,self.scaleViewFloat);
                }else{
                    shotView.imageView.transform = CGAffineTransformMakeTranslation(-200, 0);
                }
                
            } completion:^(BOOL finished) {
                shotView.imageView.transform = CGAffineTransformIdentity;
                topView.layer.shadowOpacity = 0;
                
            }];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ||
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UITableViewWrapperView")])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return YES;
    
}
#pragma mark - 拦截push

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    _tempArray = nil;
    _controller = nil;
    if (self.viewControllers.count == 0) {
        [super pushViewController:viewController animated:animated];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImage *cropImage = [self interaceptionImage];
        
        [ self.shotView.arrayScreenShots addObject:cropImage];
        
        self.shotView.imageView.image = cropImage;
        
        [self pushAnimationWithViewController:viewController isFullPush:YES];
        
    });
}

#pragma mark - 全屏PUSH

- (void)pushAnimationWithViewController:(UIViewController *)viewController isFullPush:(BOOL)isFullPush{
    
    _tempArray = nil;
    _controller = nil;
    [super pushViewController:viewController animated:NO];
    
    if (isFullPush) {
        
        UIView *topView = self.view;
        self.shotView.imageView.transform = CGAffineTransformMakeScale(1, 1);
        self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
        
        topView.transform = CGAffineTransformMakeTranslation(MUNavigationScreenWidth, 0);
        
        [UIView animateWithDuration:self.duration animations:^{
            if (self.animationType == MUNavigationAnimationTypeScale) {
                self.shotView.imageView.transform = CGAffineTransformMakeScale(self.scaleViewFloat, self.scaleViewFloat);
            }else{
                self.shotView.imageView.transform = CGAffineTransformMakeTranslation(-MUNavigationScreenWidth/2 , 0);
            }
            
            topView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:self.maskViewAlpha];
            
        } completion:^(BOOL finished) {
            
            
            self.shotView.imageView.transform = CGAffineTransformIdentity;
            
        }];
    }
}

#pragma mark - Private Method


- (void)getAccurateShotView:(UIViewController *)viewController class:(Class)clazz{
    
    for (NSInteger i = 0; i < self.viewControllers.count; i ++) {
        UIViewController *currentViewController = self.viewControllers[i];
        if ([currentViewController isKindOfClass:[viewController class]] || [currentViewController isKindOfClass:clazz]) {
            UIImage *image =   self.shotView.arrayScreenShots[i];
            
            if (image) {
                self.shotView.imageView.image = image;
            }
            break;
        }
    }
};


- (UIImage *)interaceptionImage{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, YES, 0.0); // no retina
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        if(window == screenWindow)
        {
            break;
        }else{
            [window.layer renderInContext:context];
        }
    }
    
    if ([screenWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [screenWindow drawViewHierarchyInRect:screenWindow.bounds afterScreenUpdates:NO];
    } else {
        [screenWindow.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    screenWindow.layer.contents = nil;
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - 拦截pop

- (UIViewController *)mu_popViewControllerAnimated:(BOOL)animated{
    
    if (![self respondsToSelector:@selector(isPassed)] ) {
        return  [self mu_popViewControllerAnimated:animated];
    }
    UIView *topView = self.view;
    if (self.animationType == MUNavigationAnimationTypeScale) {
        self.shotView.imageView.transform = CGAffineTransformMakeScale(self.scaleViewFloat, self.scaleViewFloat);
    }else{
        self.shotView.imageView.transform = CGAffineTransformMakeTranslation(-200, 0);
        
    }
    self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:self.maskViewAlpha];
    
    [UIView animateWithDuration:.25 animations:^{
        
        if (self.animationType == MUNavigationAnimationTypeScale) {
            self.shotView.imageView.transform = CGAffineTransformMakeScale(1.0 , 1.0);
        }else{
            
            self.shotView.imageView.transform = CGAffineTransformIdentity;
        }
        
        topView.transform = CGAffineTransformMakeTranslation(MUNavigationScreenWidth, 0);
        self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.0];
    } completion:^(BOOL finished) {
        
        topView.transform = CGAffineTransformMakeTranslation(0, 0);
        [ self.shotView.arrayScreenShots removeLastObject];
        UIImage *image = [ self.shotView.arrayScreenShots lastObject];
        
        self.shotView.imageView.image = image;
        
        [self mu_popViewControllerAnimated:NO];
    }];
    
    return nil;
}

- (NSArray<UIViewController *> *)mu_popToRootViewControllerAnimated:(BOOL)animated{
    
    if (![self respondsToSelector:@selector(isPassed)] ) {
        
        return [self mu_popToRootViewControllerAnimated:animated];
    }
    UIView *topView = self.view;
    [self getAccurateShotView:self.viewControllers[0] class:nil];
    if (self.animationType == MUNavigationAnimationTypeScale) {
        self.shotView.imageView.transform = CGAffineTransformMakeScale(self.scaleViewFloat, self.scaleViewFloat);
    }else{
        self.shotView.imageView.transform = CGAffineTransformMakeTranslation(-200, 0);
        
    }
    self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:self.maskViewAlpha];
    [UIView animateWithDuration:self.duration animations:^{
        
        if (self.animationType == MUNavigationAnimationTypeScale) {
            self.shotView.imageView.transform = CGAffineTransformMakeScale(1.0 , 1.0);
        }else{
            
            self.shotView.imageView.transform = CGAffineTransformIdentity;
        }
        
        topView.transform = CGAffineTransformMakeTranslation(MUNavigationScreenWidth, 0);
        
        self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.0];
    } completion:^(BOOL finished) {
        
        for (int i = 0; i < self.viewControllers.count - 1; i++) {
            [ self.shotView.arrayScreenShots removeLastObject];
            UIImage *image = [ self.shotView.arrayScreenShots lastObject];
            self.shotView.imageView.image = image;
        }
        topView.transform = CGAffineTransformIdentity;
        [self mu_popToRootViewControllerAnimated:NO];
    }];
    
    return nil;
}


- (NSArray<UIViewController *> *)mu_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (![self respondsToSelector:@selector(isPassed)] ) {
        return  [self mu_popToViewController:viewController animated:animated];
    }
    UIView *topView = self.view;
    [self getAccurateShotView:viewController class:nil];
    if (self.animationType == MUNavigationAnimationTypeScale) {
        self.shotView.imageView.transform = CGAffineTransformMakeScale(self.scaleViewFloat, self.scaleViewFloat);
    }else{
        self.shotView.imageView.transform = CGAffineTransformMakeTranslation(-200, 0);
        
    }
    self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:self.maskViewAlpha];
    [UIView animateWithDuration:self.duration animations:^{
        
        if (self.animationType == MUNavigationAnimationTypeScale) {
            self.shotView.imageView.transform = CGAffineTransformMakeScale(1.0 , 1.0);
        }else{
            
            self.shotView.imageView.transform = CGAffineTransformIdentity;
        }
        
        topView.transform = CGAffineTransformMakeTranslation(MUNavigationScreenWidth, 0);
        
        self.shotView.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.0];
    } completion:^(BOOL finished) {
        topView.transform = CGAffineTransformIdentity;
        [self mu_popToViewController:viewController animated:NO];
    }];
    
    return nil;
    
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    _tempArray = nil;
    _tempArray = [super popToViewController:viewController animated:animated];
    
    if ( self.shotView.arrayScreenShots.count > _tempArray.count)
    {
        for (int i = 0; i < _tempArray.count; i++) {
            [ self.shotView.arrayScreenShots removeLastObject];
        }
    }
    UIImage *image = [ self.shotView.arrayScreenShots lastObject];
    self.shotView.imageView.image = image;
    [self delay];
    return _tempArray;
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    _controller = nil;
    _controller = [super popViewControllerAnimated:NO];
    [self delay];
    return _controller;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    _tempArray = nil;
    _tempArray = [super popToRootViewControllerAnimated:animated];
    [self delay];
    return _tempArray;
}

- (BOOL) isPassed {
    // 如果当前有导航栏//且没有手动设置隐藏导航栏
    if ([NSStringFromClass([self class]) isEqualToString:@"MUNavigationController"]) {//如果有自定义的导航栏则过滤掉
        return YES;
    }
    
    return NO;
}

- (void)delay{
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    self.timer = nil;
    // 队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建 dispatch_source
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 声明成员变量
    self.timer = timer;
    // 设置两秒后触发
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 2. * NSEC_PER_SEC);
    // 设置下次触发事件为 DISPATCH_TIME_FOREVER
    dispatch_time_t nextTime = DISPATCH_TIME_FOREVER;
    // 设置精确度
    dispatch_time_t leeway = 0.5 * NSEC_PER_SEC;
    // 配置时间
    dispatch_source_set_timer(timer, startTime, nextTime, leeway);
    // 回调
    dispatch_source_set_event_handler(timer, ^{
        self.controller = nil;
        self.tempArray = nil;
        dispatch_source_cancel(timer);
        self.timer = nil;
    });
    // 激活
    dispatch_resume(timer);
}
@end
