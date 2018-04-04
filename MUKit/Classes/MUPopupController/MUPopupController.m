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
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.navigationBar.alpha = navigationBarHidden ? 0 : 1;
        [weakSelf layoutContainerView];
    } completion:^(BOOL finished) {
        weakSelf.navigationBar.hidden = navigationBarHidden;
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
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutContainerView];
            [weakSelf.contentView addSubview:toViewController.view];
            capturedView.alpha = 0;
            toViewController.view.alpha = 1;
            [weakSelf.containerViewController setNeedsStatusBarAppearanceUpdate];
        } completion:^(BOOL finished) {
            [capturedView removeFromSuperview];
            [fromViewController removeFromParentViewController];
            
            weakSelf.containerView.userInteractionEnabled = YES;
            [toViewController didMoveToParentViewController:weakSelf.containerViewController];
            
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
#pragma mark - Observers
- (void)setupObservers
{
    if (_observing) {
        return;
    }
    _observing = YES;
    
    // Observe navigation bar
    [_navigationBar addObserver:self forKeyPath:NSStringFromSelector(@selector(tintColor)) options:NSKeyValueObservingOptionNew context:nil];
    [_navigationBar addObserver:self forKeyPath:NSStringFromSelector(@selector(titleTextAttributes)) options:NSKeyValueObservingOptionNew context:nil];
    
    // Observe orientation change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    // Observe keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Observe responder change
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstResponderDidChange) name:STPopupFirstResponderDidChangeNotification object:nil];
}
- (void)destroyObservers
{
    if (!_observing) {
        return;
    }
    _observing = NO;
    
    [_navigationBar removeObserver:self forKeyPath:NSStringFromSelector(@selector(tintColor))];
    [_navigationBar removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleTextAttributes))];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIViewController *topViewController = self.topViewController;
    if (object == _navigationBar || object == topViewController.navigationItem) {
        if (topViewController.isViewLoaded && topViewController.view.superview) {
            [self updateNavigationBarAniamted:NO];
        }
    }
    else if (object == topViewController) {
        if (topViewController.isViewLoaded && topViewController.view.superview) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self layoutContainerView];
            } completion:nil];
        }
    }
}
- (void)setupObserversForViewController:(UIViewController *)viewController
{
    [viewController addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeInPopup)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController addObserver:self forKeyPath:NSStringFromSelector(@selector(landscapeContentSizeInPopup)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(titleView)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItems)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItems)) options:NSKeyValueObservingOptionNew context:nil];
    [viewController.navigationItem addObserver:self forKeyPath:NSStringFromSelector(@selector(hidesBackButton)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)destroyObserversOfViewController:(UIViewController *)viewController
{
    [viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSizeInPopup))];
    [viewController removeObserver:self forKeyPath:NSStringFromSelector(@selector(landscapeContentSizeInPopup))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleView))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(leftBarButtonItems))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(rightBarButtonItems))];
    [viewController.navigationItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(hidesBackButton))];
}
#pragma mark - UIApplicationDidChangeStatusBarOrientationNotification
- (void)orientationDidChange
{
    [_containerView endEditing:YES];
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _containerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self layoutContainerView];
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _containerView.alpha = 1;
        } completion:nil];
    }];
}

#pragma mark - UIKeyboardWillShowNotification & UIKeyboardWillHideNotification

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIView<UIKeyInput> *currentTextInput = [self getCurrentTextInputInView:_containerView];
    if (!currentTextInput) {
        return;
    }
    
    _keyboardInfo = notification.userInfo;
    [self adjustContainerViewOrigin];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _keyboardInfo = nil;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    _containerView.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}

- (void)adjustContainerViewOrigin
{
    if (!_keyboardInfo) {
        return;
    }
    
    UIView<UIKeyInput> *currentTextInput = [self getCurrentTextInputInView:_containerView];
    if (!currentTextInput) {
        return;
    }
    
    CGAffineTransform lastTransform = _containerView.transform;
    _containerView.transform = CGAffineTransformIdentity; // Set transform to identity for calculating a correct "minOffsetY"
    
    CGFloat textFieldBottomY = [currentTextInput convertPoint:CGPointZero toView:_containerViewController.view].y + currentTextInput.bounds.size.height;
    CGFloat keyboardHeight = [_keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    // For iOS 7
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 &&
        (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)) {
        keyboardHeight = [_keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
    }
    
    CGFloat offsetY = 0;
    if (self.style == MUPopupStyleBottomSheet) {
        offsetY = keyboardHeight;
        if([currentTextInput isKindOfClass:[UITextField class]]){
            offsetY = textFieldBottomY - _containerViewController.view.bounds.size.height + keyboardHeight + 64.;//适配textfield
        }
    }
    else {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        if (_containerView.bounds.size.height <= _containerViewController.view.bounds.size.height - keyboardHeight - statusBarHeight) {
            offsetY = _containerView.frame.origin.y - (statusBarHeight + (_containerViewController.view.bounds.size.height - keyboardHeight - statusBarHeight - _containerView.bounds.size.height) / 2);
        }
        else {
            CGFloat spacing = 5;
            offsetY = _containerView.frame.origin.y + _containerView.bounds.size.height - (_containerViewController.view.bounds.size.height - keyboardHeight - spacing);
            if (offsetY <= 0) { // _containerView can be totally shown, so no need to translate the origin
                return;
            }
            if (_containerView.frame.origin.y - offsetY < statusBarHeight) { // _containerView will be covered by status bar if the origin is translated by "offsetY"
                offsetY = _containerView.frame.origin.y - statusBarHeight;
                // currentTextField can not be totally shown if _containerView is going to repositioned with "offsetY"
                if (textFieldBottomY - offsetY > _containerViewController.view.bounds.size.height - keyboardHeight - spacing) {
                    offsetY = textFieldBottomY - (_containerViewController.view.bounds.size.height - keyboardHeight - spacing);
                }
            }
        }
    }
    
    NSTimeInterval duration = [_keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [_keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    _containerView.transform = lastTransform; // Restore transform
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    _containerView.transform = CGAffineTransformMakeTranslation(0, -offsetY);
    
    [UIView commitAnimations];
}

- (UIView<UIKeyInput> *)getCurrentTextInputInView:(UIView *)view
{
    if ([view conformsToProtocol:@protocol(UIKeyInput)] && view.isFirstResponder) {
        // Quick fix for web view issue
        if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")] || [view isKindOfClass:NSClassFromString(@"WKContentView")]) {
            return nil;
        }
        return (UIView<UIKeyInput> *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIView<UIKeyInput> *view = [self getCurrentTextInputInView:subview];
        if (view) {
            return view;
        }
    }
    return nil;
}

#pragma mark - MUPopupController present & dismiss & push & pop
-(void)presentInViewController:(UIViewController *)viewController{
    [self presentInViewController:viewController completion:nil];
}
-(void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion{
    if (self.presented) {
        return;
    }
    
    //在屏幕上显示时注册通知
    [self setupObservers];
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
     [self setupObserversForViewController:viewController];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    if (_viewControllersArray.count <= 1) {
        [self dismiss];
        return;
    }
    
    UIViewController *topViewController = self.topViewController;
    [self destroyObserversOfViewController:topViewController];// remove KVO
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
        
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:[transitioning popupControllerTransitionDuration:context] delay:0 usingSpringWithDamping:1. initialSpringVelocity:1. options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.backgroundView.alpha = lastBackgroundViewAlpha;
        } completion:nil];
        
        [transitioning popupControllerAnimateTransition:context completion:^{
            weakSelf.backgroundView.userInteractionEnabled = YES;
            weakSelf.containerView.userInteractionEnabled = YES;
            
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
        
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:[transitioning popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.backgroundView.alpha = 0;
        } completion:nil];
        
        [transitioning popupControllerAnimateTransition:context completion:^{
            weakSelf.backgroundView.userInteractionEnabled = YES;
            weakSelf.containerView.userInteractionEnabled = YES;;
            
            [fromViewController.view removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            [topViewController.view removeFromSuperview];
            [topViewController removeFromParentViewController];
            
            [toViewController endAppearanceTransition];
            
            weakSelf.backgroundView.alpha = lastBackgroundViewAlpha;
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
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.containerView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}


#pragma mark -dealloc
-(void)dealloc{
    
    [self destroyObservers];
    for (UIViewController *viewController in _viewControllersArray) {
        viewController.popupController = nil; // Avoid crash when try to access unsafe unretained property
        [self destroyObserversOfViewController:viewController];
    }
#if DEBUG
    NSLog(@"MUPopupController被销毁了");
#endif
}
@end
