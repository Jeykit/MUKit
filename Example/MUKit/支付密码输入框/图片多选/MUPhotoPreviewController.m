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
@end

@implementation MUPhotoPreviewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
     [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = [NSString stringWithFormat:@"%ld/%ld ",self.currentIndex+1,self.fetchResult.count];
  
    [self initialization];
    [self initializationPreviewView];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setNavBarAppearance:animated];
//    [self hideControlsAfterDelay];
//}
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
//    self.contentView          = [[UIView alloc]initWithFrame:[self frameForContentView]];
//    self.contentView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:self.contentView];
    [self.view addSubview:self.toolbar];
}
-(void)initializationPreviewView{
    self.carouselView = [[MUPhotoPreviewView alloc]initWithFrame:self.view.bounds];
    self.carouselView.backgroundColor = [UIColor blackColor];
    self.carouselView.currentIndex = self.currentIndex;
    [self.view addSubview:self.carouselView];
    self.carouselView.fetchResult     = self.fetchResult;
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
