//
//  MUPopupController.m
//  Pods
//
//  Created by Jekity on 2017/10/9.
//
//

#import "MUPopupController.h"
#import "UIViewController+MUPopup.h"
#import "MUPopupControllerTransitioningFade.h"
#import "MUPopupControllerTransitioningSlideVertical.h"
#import "MUPopupNavigationBar.h"
#import "MUPopupLeftBarItem.h"

@implementation MUPopupControllerTransitioningContext

-(instancetype)initWithContainerView:(UIView *)containerView action:(MUPopupControllerTransitioningAction)action{
    
    if (self = [super init]) {
        _containerView = containerView;
        _action = action;
    }
    return self;
}

@end

CGFloat const MUPopupBottomSheetExtraHeight = 80.;
static NSMutableSet *_retainedPopupControllers;


@protocol MUPopupNavigationTouchEventDelegate <NSObject>

- (void)popupNavigationBar:(MUPopupNavigationBar *)navigationBar touchDidMoveWithOffset:(CGFloat)offset;
- (void)popupNavigationBar:(MUPopupNavigationBar *)navigationBar touchDidEndWithOffset:(CGFloat)offset;

@end

@interface MUPopupNavigationBar (MUInternal)
@property (nonatomic, weak) id<MUPopupNavigationTouchEventDelegate> touchEventDelegate;
@end

@interface UIViewController (MUInternal)
@property(nonatomic, weak)MUPopupController *popupController;
@end

@interface MUPopupContainerController : UIViewController
@end
@implementation MUPopupContainerController

//自由控制每个控制器的状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.childViewControllers.count || !self.presentingViewController) {
        
        return [super preferredStatusBarStyle];
    }
    return [self.presentingViewController preferredStatusBarStyle];
}
-(UIViewController *)childViewControllerForStatusBarHidden{
    return self.childViewControllers.lastObject;
}
-(UIViewController *)childViewControllerForStatusBarStyle{
    return self.childViewControllers.lastObject;
}
//presented VC自由的自动选择最佳的展示方式来展示presenting VC
-(void)showViewController:(UIViewController *)vc sender:(id)sender{
    if (!CGSizeEqualToSize(vc.contentSizeInPopup, CGSizeZero) ||
        !CGSizeEqualToSize(vc.landscapeContentSizeInPopup, CGSizeZero)) {
        UIViewController *childViewController = self.childViewControllers.lastObject;
        [childViewController.popupController pushViewController:vc animated:YES];
    }
    else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}
-(void)showDetailViewController:(UIViewController *)vc sender:(id)sender{
    if (!CGSizeEqualToSize(vc.contentSizeInPopup, CGSizeZero) ||
        !CGSizeEqualToSize(vc.landscapeContentSizeInPopup, CGSizeZero)) {
        UIViewController *childViewController = self.childViewControllers.lastObject;
        [childViewController.popupController pushViewController:vc animated:YES];
    }
    else {
        [self presentViewController:vc animated:YES completion:nil];
    }
}
@end

@interface MUPopupController()<UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning ,MUPopupNavigationTouchEventDelegate>
@property(nonatomic, strong)MUPopupContainerController                  *containerViewController;
@property(nonatomic, strong)NSMutableArray                              *viewControllersArray;
@property(nonatomic, strong)UIView                                      *contentView;
@property(nonatomic, assign)BOOL                                        observing;

@property(nonatomic, strong)MUPopupControllerTransitioningFade          *transitioningFade;
@property(nonatomic, strong)MUPopupControllerTransitioningSlideVertical *transitionSlideVertical;
@property(nonatomic, strong)NSDictionary                                *keyboardInfo;
@property(nonatomic, strong)MUPopupLeftBarItem                          *defaultLeftBarItem;
@property(nonatomic, strong)UILabel                                     *defaultTitleLabel;
@property(nonatomic, assign)CGFloat                                     preferredNavigationBarHeight;

@property(nonatomic, strong)MUPopupController *retainController;
@end
@implementation MUPopupController
//+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        _retainedPopupControllers = [NSMutableSet new];
//    });
//}
#pragma mark -topViewController
-(UIViewController *)topViewController{
    return _viewControllersArray.lastObject;
}

#pragma mark -presented
-(BOOL)presented{
    
    return _containerViewController.presentingViewController != nil;
}

#pragma mark -backgroundView
-(void)setBackgroundView:(UIView *)backgroundView{
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [_containerViewController.view insertSubview:_backgroundView atIndex:0];
}

-(void)backgroundViewDidTap{
    [_containerView endEditing:YES];
}

#pragma mark -cornerRadius
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    _containerView.layer.cornerRadius = cornerRadius;
}
#pragma mark -init
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    
    if (self = [self init]) {
        [self pushViewController:rootViewController animated:NO];
    }
    return self;
}
-(instancetype)init{
    if (self = [super init]) {
        if (!_retainController) {
            _retainController = self;
            _preferredNavigationBarHeight = 0;
        }
        [self configuredUI];
    }
    return self;
}
-(CGFloat)preferredNavigationBarHeight{
    if (_preferredNavigationBarHeight < 22) {
        // The preferred height of navigation bar is different between iPhone (4, 5, 6) and 6 Plus.
        // Create a navigation controller to get the preferred height of navigation bar.
         UINavigationController *navigationController = [UINavigationController new];
        _preferredNavigationBarHeight = navigationController.navigationBar.bounds.size.height;
    }
   
    return _preferredNavigationBarHeight;
}
#pragma mark - UI
- (void)configuredUI
{
    _containerViewController = [MUPopupContainerController new];
    _containerViewController.view.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
        _containerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else {
        _containerViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    //动画转场
    _containerViewController.transitioningDelegate = self;
    
    _transitionSlideVertical = [MUPopupControllerTransitioningSlideVertical new];
    _transitioningFade       = [MUPopupControllerTransitioningFade new];
    
    //初始化contentView and containerView
    [self configuredBackgroundView];
    [self configuredContainerView];
    [self configuredNavigationBar];
}

- (void)configuredContainerView
{
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.clipsToBounds = YES;
    [_containerViewController.view addSubview:_containerView];
    
    _contentView = [UIView new];
    [_containerView addSubview:_contentView];
}

-(void)configuredBackgroundView{
    UIView *backgroundView         = [UIView new];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    self.backgroundView = backgroundView;
}

-(void)configuredNavigationBar{
    
    MUPopupNavigationBar *navigationBar = [MUPopupNavigationBar new];
    navigationBar.touchEventDelegate    = self;
    _navigationBar = navigationBar;
    
    [_containerView addSubview:navigationBar];
    _defaultTitleLabel  = [UILabel new];
    _defaultLeftBarItem = [[MUPopupLeftBarItem alloc]initWithTarget:self action:@selector(leftBarItemDidTap)];
}

- (void)leftBarItemDidTap
{
    switch (_defaultLeftBarItem.type) {
        case MUPopupLeftBarItemCross:
            [self dismiss];
            break;
        case MUPopupLeftBarItemArrow:
            [self popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}
#pragma mark - navigationBar
-(void)setNavigationBarHidden:(BOOL)navigationBarHidden{
     [self setNavigationBarHidden:navigationBarHidden animated:NO];
}
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated
{
    _navigationBarHidden = navigationBarHidden;
    _navigationBar.alpha = navigationBarHidden ? 1 : 0;
    
    if (!animated) {
        [self layoutContainerView];
        _navigationBar.hidden = navigationBarHidden;
        return;
    }
    
    if (!navigationBarHidden) {
        _navigationBar.hidden = navigationBarHidden;
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _navigationBar.alpha = navigationBarHidden ? 0 : 1;
        [self layoutContainerView];
    } completion:^(BOOL finished) {
        _navigationBar.hidden = navigationBarHidden;
    }];
}

- (void)updateNavigationBarAniamted:(BOOL)animated
{
    BOOL shouldAnimateDefaultLeftBarItem = animated && _navigationBar.topItem.leftBarButtonItem == _defaultLeftBarItem;
    
    UIViewController *topViewController = self.topViewController;
    UIView *lastTitleView = _navigationBar.topItem.titleView;
    _navigationBar.items = @[ [UINavigationItem new] ];
    _navigationBar.topItem.leftBarButtonItems = topViewController.navigationItem.leftBarButtonItems ? : (topViewController.navigationItem.hidesBackButton ? nil : @[ _defaultLeftBarItem ]);
    _navigationBar.topItem.rightBarButtonItems = topViewController.navigationItem.rightBarButtonItems;
    if (self.hidesCloseButton && topViewController == _viewControllersArray.firstObject &&
        _navigationBar.topItem.leftBarButtonItem == _defaultLeftBarItem) {
        _navigationBar.topItem.leftBarButtonItems = nil;
    }
    
    if (animated) {
        UIView *fromTitleView, *toTitleView;
        if (lastTitleView == _defaultTitleLabel)    {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:_defaultTitleLabel.frame];
            tempLabel.center = _navigationBar.center;
            tempLabel.textColor = _defaultTitleLabel.textColor;
            tempLabel.font = _defaultTitleLabel.font;
            tempLabel.attributedText = [[NSAttributedString alloc] initWithString:_defaultTitleLabel.text ? : @""
                                                                       attributes:_navigationBar.titleTextAttributes];
            fromTitleView = tempLabel;
        }
        else {
            fromTitleView = lastTitleView;
        }
        
        if (topViewController.navigationItem.titleView) {
            toTitleView = topViewController.navigationItem.titleView;
        }
        else {
            NSString *title = (topViewController.title ? : topViewController.navigationItem.title) ? : @"";
            _defaultTitleLabel = [UILabel new];
            _defaultTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                                attributes:_navigationBar.titleTextAttributes];
            [_defaultTitleLabel sizeToFit];
            toTitleView = _defaultTitleLabel;
        }
        
        [_navigationBar addSubview:fromTitleView];
        _navigationBar.topItem.titleView = toTitleView;
        toTitleView.alpha = 0;
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromTitleView.alpha = 0;
            toTitleView.alpha = 1;
        } completion:^(BOOL finished) {
            [fromTitleView removeFromSuperview];
        }];
    }
    else {
        if (topViewController.navigationItem.titleView) {
            _navigationBar.topItem.titleView = topViewController.navigationItem.titleView;
        }
        else {
            NSString *title = (topViewController.title ? : topViewController.navigationItem.title) ? : @"";
            _defaultTitleLabel = [UILabel new];
            _defaultTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                                attributes:_navigationBar.titleTextAttributes];
            [_defaultTitleLabel sizeToFit];
            _navigationBar.topItem.titleView = _defaultTitleLabel;
        }
    }
    _defaultLeftBarItem.tintColor = _navigationBar.tintColor;
    [_defaultLeftBarItem setType:_viewControllersArray.count > 1 ? MUPopupLeftBarItemArrow : MUPopupLeftBarItemCross
                        animated:shouldAnimateDefaultLeftBarItem];
}

- (void)transitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController animated:(BOOL)animated
{
    [fromViewController beginAppearanceTransition:NO animated:animated];
    [toViewController beginAppearanceTransition:YES animated:animated];
    
    [fromViewController willMoveToParentViewController:nil];
    [_containerViewController addChildViewController:toViewController];
    
    if (animated) {
        // Capture view in "fromViewController" to avoid "viewWillAppear" and "viewDidAppear" being called.
        UIGraphicsBeginImageContextWithOptions(fromViewController.view.bounds.size, NO, [UIScreen mainScreen].scale);
        [fromViewController.view drawViewHierarchyInRect:fromViewController.view.bounds afterScreenUpdates:NO];
        
        UIImageView *capturedView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        
        UIGraphicsEndImageContext();
        
        capturedView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
        [_containerView insertSubview:capturedView atIndex:0];
        
        [fromViewController.view removeFromSuperview];
        
        _containerView.userInteractionEnabled = NO;
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutContainerView];
            [_contentView addSubview:toViewController.view];
            capturedView.alpha = 0;
            toViewController.view.alpha = 1;
            [_containerViewController setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            [capturedView removeFromSuperview];
            [fromViewController removeFromParentViewController];
            
            _containerView.userInteractionEnabled = YES;
            [toViewController didMoveToParentViewController:_containerViewController];
            
            [fromViewController endAppearanceTransition];
            [toViewController endAppearanceTransition];
        }];
        [self updateNavigationBarAniamted:animated];
    }
    else {
        [self layoutContainerView];
        [_contentView addSubview:toViewController.view];
        [_containerViewController setNeedsStatusBarAppearanceUpdate];
        [self updateNavigationBarAniamted:animated];
        
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        
        [toViewController didMoveToParentViewController:_containerViewController];
        
        [fromViewController endAppearanceTransition];
        [toViewController endAppearanceTransition];
    }
}

#pragma mark - UI layout
- (void)layoutContainerView
{
    _backgroundView.frame = _containerViewController.view.bounds;
    CGFloat preferredNavigationBarHeight = self.preferredNavigationBarHeight;
    CGFloat navigationBarHeight = _navigationBarHidden ? 0 : preferredNavigationBarHeight;
    CGSize contentSizeOfTopView = [self contentSizeOfTopView];
    
    CGFloat containerViewWidth = contentSizeOfTopView.width;
    CGFloat containerViewHeight = contentSizeOfTopView.height + navigationBarHeight;
    
    //居中
    CGFloat containerViewY = (_containerViewController.view.bounds.size.height - containerViewHeight) / 2;
    
    if (self.style == MUPopupStyleBottomSheet) {
        containerViewY = _containerViewController.view.bounds.size.height - containerViewHeight;
        containerViewHeight += MUPopupBottomSheetExtraHeight;
    }
    
    _containerView.frame = CGRectMake((_containerViewController.view.bounds.size.width - containerViewWidth) / 2,
                                      containerViewY, containerViewWidth, containerViewHeight);
    
    _navigationBar.frame = CGRectMake(0, 0, containerViewWidth, preferredNavigationBarHeight);
    _contentView.frame   = CGRectMake(0, navigationBarHeight, contentSizeOfTopView.width, contentSizeOfTopView.height);
    
    UIViewController *topViewController = self.topViewController;
    topViewController.view.frame = _contentView.bounds;
    
}

- (CGSize)contentSizeOfTopView
{
    UIViewController *topViewController = self.topViewController;
    CGSize contentSize = CGSizeZero;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            contentSize = topViewController.landscapeContentSizeInPopup;
            if (CGSizeEqualToSize(contentSize, CGSizeZero)) {
                contentSize = topViewController.contentSizeInPopup;
            }
        }
            break;
        default: {
            contentSize = topViewController.contentSizeInPopup;
        }
            break;
    }
    
    NSAssert(!CGSizeEqualToSize(contentSize, CGSizeZero), @"contentSizeInPopup should not be size zero.");
    
    return contentSize;
}


#pragma mark - MUPopupController present & dismiss & push & pop
-(void)presentInViewController:(UIViewController *)viewController{
    [self presentInViewController:viewController completion:nil];
}
-(void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion{
    if (self.presented) {
        return;
    }
    viewController = viewController.tabBarController ? :viewController;
    [viewController presentViewController:_containerViewController animated:YES completion:completion];
}
- (void)dismiss
{
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion
{
    if (!self.presented) {
        return;
    }
    [_containerViewController dismissViewControllerAnimated:YES completion:^{
        _retainController = nil;
        if (completion) {
            completion();
        }
    }];
}

#pragma mark -Push && Pop
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (!_viewControllersArray) {
        _viewControllersArray = [NSMutableArray array];
    }
    UIViewController *topViewController = self.topViewController;
    viewController.popupController   = self;
    [_viewControllersArray addObject:viewController];
    if (self.presented) {
        [self transitFromViewController:topViewController toViewController:viewController animated:animated];
    }
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    if (_viewControllersArray.count <= 1) {
        [self dismiss];
        return;
    }
    
    UIViewController *topViewController = self.topViewController;
    [_viewControllersArray removeObject:topViewController];
    
    if (self.presented) {
        [self transitFromViewController:topViewController toViewController:self.topViewController animated:animated];
    }
    topViewController.popupController = nil;
}

-(void)popToRootViewControllerAnimated:(BOOL)animated{
    if (_viewControllersArray.count <= 1) {
        [self dismiss];
        return;
    }
    UIViewController *fromViewController = _viewControllersArray.lastObject;
    UIViewController *toViewController   = _viewControllersArray.firstObject;
    _viewControllersArray = [NSMutableArray arrayWithObject:toViewController];
    if (self.presented) {
        [self transitFromViewController:fromViewController toViewController:toViewController animated:YES];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}
#pragma mark - UIViewControllerAnimatedTransitioning - customer

//判断当前的动作方式
- (MUPopupControllerTransitioningContext *)convertTransitioningContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    MUPopupControllerTransitioningAction action = MUPopupControllerTransitioningActionPresent;
    if ([transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] != _containerViewController) {
        action = MUPopupControllerTransitioningActionDismiss;
    }
    return [[MUPopupControllerTransitioningContext alloc] initWithContainerView:_containerView action:action];
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    MUPopupControllerTransitioningContext *context = [self convertTransitioningContext:transitionContext];
    switch (self.transitionStyle) {
        case MUPopupTransitionStyleSlideVertical:
            return [_transitionSlideVertical popupControllerTransitionDuration:context];
            break;
        case MUPopupTransitionStyleFade:
            return [_transitioningFade popupControllerTransitionDuration:context];
            break;
        case MUPopupTransitionStyleCustom:
            NSAssert(self.transitioning, @"transitioning should be provided if it's using MUPopupTransitionStyleCustom");
            return [_transitioning popupControllerTransitionDuration:context];
            break;

        default:
            break;
    }
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.frame = fromViewController.view.frame;
    UIViewController *topViewController = self.topViewController;
    
    MUPopupControllerTransitioningContext *context = [self convertTransitioningContext:transitionContext];
    id<MUPopupControllerTransitioning>transitioning = nil;
    switch (self.transitionStyle) {
        case MUPopupTransitionStyleSlideVertical:
            transitioning = _transitionSlideVertical;
            break;
        case MUPopupTransitionStyleFade:
            transitioning = _transitioningFade;
        case MUPopupTransitionStyleCustom:
            transitioning = self.transitioning;
            break;
    }
     NSAssert(transitioning, @"transitioning should be provided if it's using MUPopupTransitionStyleCustom");
    if (context.action == MUPopupControllerTransitioningActionPresent) {
        
        [fromViewController beginAppearanceTransition:NO animated:YES];
        [transitionContext.containerView addSubview:toViewController.view];
        [toViewController beginAppearanceTransition:YES animated:YES];
        [toViewController addChildViewController:topViewController];
        
        [self layoutContainerView];
        [_contentView addSubview:topViewController.view];
        [topViewController setNeedsStatusBarAppearanceUpdate];
        CGFloat lastBackgroundViewAlpha = _backgroundView.alpha;
        [self updateNavigationBarAniamted:NO];
        
        _backgroundView.alpha = 0;
        _backgroundView.userInteractionEnabled = NO;
        _containerView.userInteractionEnabled  = NO;
        _containerView.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:[transitioning popupControllerTransitionDuration:context] delay:0 usingSpringWithDamping:1. initialSpringVelocity:1. options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _backgroundView.alpha = lastBackgroundViewAlpha;
        } completion:nil];
        
        [transitioning popupControllerAnimateTransition:context completion:^{
            _backgroundView.userInteractionEnabled = YES;
            _containerView.userInteractionEnabled = YES;
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [topViewController didMoveToParentViewController:toViewController];
            [fromViewController endAppearanceTransition];
            
        }];
    }else{
        [toViewController beginAppearanceTransition:YES animated:YES];
        
        [topViewController beginAppearanceTransition:NO animated:YES];
        [topViewController willMoveToParentViewController:nil];
        
        CGFloat lastBackgroundViewAlpha = _backgroundView.alpha;
        _backgroundView.userInteractionEnabled = NO;
        _containerView.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:[transitioning popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _backgroundView.alpha = 0;
        } completion:nil];
        
        [transitioning popupControllerAnimateTransition:context completion:^{
            _backgroundView.userInteractionEnabled = YES;
            _containerView.userInteractionEnabled = YES;;
            
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            [topViewController.view removeFromSuperview];
            [topViewController removeFromParentViewController];
            
            [toViewController endAppearanceTransition];
            
            _backgroundView.alpha = lastBackgroundViewAlpha;
        }];
    }
}



#pragma mark - MUPopupNavigationTouchEventDelegate
- (void)popupNavigationBar:(MUPopupNavigationBar *)navigationBar touchDidMoveWithOffset:(CGFloat)offset
{
    [_containerView endEditing:YES];
    
    if (self.style == MUPopupStyleBottomSheet && offset < -MUPopupBottomSheetExtraHeight) {
        return;
    }
    _containerView.transform = CGAffineTransformMakeTranslation(0, offset);
}

- (void)popupNavigationBar:(MUPopupNavigationBar *)navigationBar touchDidEndWithOffset:(CGFloat)offset
{
    if (offset > 150) {
        MUPopupTransitionStyle transitionStyle = self.transitionStyle;
        self.transitionStyle = MUPopupTransitionStyleSlideVertical;
        [self dismissWithCompletion:^{
            self.transitionStyle = transitionStyle;
        }];
    }
    else {
        [_containerView endEditing:YES];
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _containerView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}


#pragma mark -dealloc
-(void)dealloc{
    NSLog(@"MUPopupController被销毁了");
//#if DEBUG
//#endif
}
@end
