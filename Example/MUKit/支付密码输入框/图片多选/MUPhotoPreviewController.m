//
//  MUPhotoPreviewController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUPhotoPreviewController.h"
#import "MUPhotoPreviewView.h"

#define kMUPadding 10.
@interface MUPhotoPreviewController ()
@property(nonatomic, strong)MUPhotoPreviewView *carouselView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)UIToolbar *toolbar;
@property(nonatomic, strong)NSTimer *controlVisibilityTimer;
@property(nonatomic, assign)NSTimeInterval delayToHideElements;
@property(nonatomic, assign)BOOL didSavePreviousStateOfNavBar;
@property(nonatomic, strong)UIColor *previousNavBarBarTintColor;
@property(nonatomic, assign)BOOL previousNavBarTranslucent;
@property(nonatomic, strong)UIColor *previousNavBarTintColor;
@property(nonatomic, assign)BOOL previousNavBarHidden;
@property(nonatomic, assign)UIBarStyle previousNavBarStyle;
@property(nonatomic, strong)UIImage *previousNavigationBarBackgroundImageDefault;
@property(nonatomic, strong)UIImage *previousNavigationBarBackgroundImageLandscapePhone;
@property(nonatomic, strong)UIColor *titleColor;
@end

@implementation MUPhotoPreviewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
     [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = [NSString stringWithFormat:@"%ld/%ld ",self.currentIndex+1,self.fetchResult.count];
  
    [self initializationPreviewView];
    [self initialization];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self storePreviousNavBarAppearance];
    [self setNavBarAppearance:animated];
    [self hideControlsAfterDelay];
}
-(void)viewWillDisappear:(BOOL)animated{
    // Controls
    [self.navigationController.navigationBar.layer removeAllAnimations]; // Stop all animations on nav bar
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
    [self setControlsHidden:NO animated:NO permanent:YES];
    [self restorePreviousNavBarAppearance:animated];
    [super viewWillDisappear:animated];
}
- (void)setNavBarAppearance:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = nil;
    navBar.shadowImage = nil;
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
- (void)storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsCompact];
    if(self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName]) {
        
        _titleColor = self.navigationController.navigationBar.titleTextAttributes[NSForegroundColorAttributeName];
    }
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
    if (_didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = _previousNavBarTintColor;
        navBar.translucent = _previousNavBarTranslucent;
        navBar.barTintColor = _previousNavBarBarTintColor;
        navBar.barStyle = _previousNavBarStyle;
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsCompact];
        if (self.titleColor) {
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:self.titleColor};
        }
        // Restore back button if we need to
    }
}
-(UIToolbar *)toolbar{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:[self frameForToolbarAtOrientation]];
        _toolbar.tintColor = [UIColor whiteColor];
        _toolbar.barTintColor = nil;
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsCompact];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
    }
    return _toolbar;
}
-(void)initialization{
    self.view.backgroundColor = [UIColor blackColor];
    self.delayToHideElements  = 5.;
    [self.view addSubview:self.toolbar];
}
-(void)initializationPreviewView{
    self.carouselView = [[MUPhotoPreviewView alloc]initWithFrame:self.view.bounds];
    self.carouselView.backgroundColor = [UIColor blackColor];
    self.carouselView.currentIndex = self.currentIndex;
    [self.view addSubview:self.carouselView];
    self.carouselView.fetchResult     = self.fetchResult;
    
    __weak typeof(self)weakSelf = self;
    self.carouselView.handleSingleTap = ^(NSUInteger index) {
        
        if ([weakSelf areControlsHidden]) {
            [weakSelf showControls];
        }else{
            [weakSelf hideControls];
        }
    };
    
    self.carouselView.handleScrollViewDelegate = ^(BOOL flag) {
        
        if (flag) {
            [weakSelf cancelControlHiding];
        }else{
            [weakSelf hideControlsAfterDelay];
        }
    };
    
    self.carouselView.hideControls = ^{
        
        [weakSelf hideControls];
    };
    
    self.carouselView.doneUpdateCurrentIndex = ^(NSUInteger index) {
        
         weakSelf.title = [NSString stringWithFormat:@"%ld/%ld ",(index+1),weakSelf.fetchResult.count];
    };
}

// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
    if (![self areControlsHidden]) {
        [self cancelControlHiding];
        _controlVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayToHideElements target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    }
}
- (BOOL)areControlsHidden { return (_toolbar.alpha == 0); }
- (void)cancelControlHiding {
    // If a timer exists then cancel and release
    if (_controlVisibilityTimer) {
        [_controlVisibilityTimer invalidate];
        _controlVisibilityTimer = nil;
    }
}
- (void)hideControls { [self setControlsHidden:YES animated:YES permanent:NO]; }
- (void)showControls { [self setControlsHidden:NO animated:YES permanent:NO]; }
// If permanent then we don't set timers to hide again
// Fades all controls on iOS 5 & 6, and iOS 7 controls slide and fade
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent {
    
    if (self.toolbar.alpha == 0&&hidden) {//已经隐藏过
        return;
    }
    // Cancel any timers
    [self cancelControlHiding];
    
    // Animations & positions
    CGFloat animatonOffset = 20;
    CGFloat animationDuration = (animated ? 0.35 : 0);
    
    // Status bar
  
    // Toolbar, nav bar and captions
    // Pre-appear animation positions for sliding

    [UIView animateWithDuration:animationDuration animations:^(void) {
        
        CGFloat alpha = hidden ? 0 : 1;
        
        // Nav bar slides up on it's own on iOS 7+
        [self.navigationController.navigationBar setAlpha:alpha];
        
        // Toolbar
        _toolbar.frame = [self frameForToolbarAtOrientation];
        if (hidden) _toolbar.frame = CGRectOffset(_toolbar.frame, 0, animatonOffset);
        _toolbar.alpha = alpha;
        
    } completion:^(BOOL finished) {}];
    
    // Control hiding timer
    // Will cancel existing timer but only begin hiding if
    // they are visible
    if (!permanent) [self hideControlsAfterDelay];
    
}

#pragma mark - Frame Calculations
- (CGRect)frameForToolbarAtOrientation {
    CGFloat height = 49;
    return CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height));
}

@end
