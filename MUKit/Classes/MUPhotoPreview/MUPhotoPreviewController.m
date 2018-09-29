//
//  MUPhotoPreviewController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUPhotoPreviewController.h"
#import "MUPhotoPreviewView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define kMUPadding 10.
@interface MUPhotoPreviewController ()
@property(nonatomic, strong)MUPhotoPreviewView *carouselView;
@property(nonatomic, strong)UIView *contentView;
@property (nonatomic,strong ) UIToolbar *toolbar;
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
@property(nonatomic, strong)UIImage *previousNavigationBarShadowImage;
@property(nonatomic, strong)NSDictionary *attuributeDictionary;
@property (nonatomic,strong) MPMoviePlayerViewController *currentVideoPlayerViewController;
@property (nonatomic,strong) AVPlayerViewController *playerViewController;
@property (nonatomic,strong) UILabel *customTitleLabel;
@property (nonatomic,strong) MUCaptionView *captionView;
@end
#pragma clang diagnostic pop

@implementation MUPhotoPreviewController

- (UIImage *)imageFromColorMu:(UIColor *)color{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.navigationController.navigationBar.translucent = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(setNavigationBarBackgroundImageMu:)]) {
        [self performSelectorOnMainThread:@selector(setNavigationBarBackgroundImageMu:) withObject:[self imageFromColorMu:[UIColor clearColor]] waitUntilDone:YES];
    }
#pragma clang diagnostic pop
    NSUInteger totalCount = self.fetchResult.count>0?self.fetchResult.count:self.modelArray.count;
    self.title = [NSString stringWithFormat:@"%ld/%ld ",self.currentIndex+1,totalCount];
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
    navBar.shadowImage = [UIImage new];
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
- (void)storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    _previousNavigationBarShadowImage = self.navigationController.navigationBar.shadowImage;
    _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsCompact];
    if (self.navigationController.navigationBar.titleTextAttributes) {
        _attuributeDictionary = self.navigationController.navigationBar.titleTextAttributes;
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
        navBar.shadowImage = _previousNavigationBarShadowImage;
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
        [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsCompact];
        if (_attuributeDictionary) {
            [self.navigationController.navigationBar setTitleTextAttributes:_attuributeDictionary];
            
        }
        // Restore back button if we need to
    }
}
-(UIToolbar *)toolbar{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc]initWithFrame:CGRectZero];
        _toolbar.tintColor = [UIColor whiteColor];
        _toolbar.translucent = YES;
        _toolbar.barTintColor = nil;
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsCompact];
        _toolbar.barStyle = UIBarStyleBlack;
        _toolbar.clipsToBounds = YES;
        _toolbar.frame = [self frameForToolbarAtOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        [_toolbar layoutIfNeeded];//立即更新布局 防止第一次frame布局不正确
        [self.view addSubview:_toolbar];
       
    }
    return _toolbar;
}

-(void)initialization{
    self.view.backgroundColor = [UIColor blackColor];
    self.delayToHideElements  = 5.;
    self.navigationItem.titleView = self.customTitleLabel;
}
- (UILabel *)customTitleLabel{
    if (!_customTitleLabel) {
        _customTitleLabel = [UILabel new];
        _customTitleLabel.textColor = [UIColor whiteColor];
        _customTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _customTitleLabel;
}

-(MUCaptionView *)captionView{
    if (!_captionView) {
        _captionView = [[MUCaptionView alloc]init];
        [self.carouselView addSubview:_captionView];
    }
    return _captionView;
}
-(MUPhotoPreviewView *)carouselView{
    if (!_carouselView) {
        _carouselView = [[MUPhotoPreviewView alloc]initWithFrame:self.view.bounds];
        _carouselView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_carouselView];
        
        __weak typeof(self)weakSelf = self;
        __block BOOL firstSubViews = NO;
        self.carouselView.configuredImageBlock = ^(UIImageView *imageView, NSUInteger index, id model) {
            
            if (weakSelf.configuredImageBlock) {
                NSString *caption  = @"";
                weakSelf.configuredImageBlock(imageView , index ,model ,&caption);
                if (caption.length > 0) {
                    if (!firstSubViews) {
                        firstSubViews = YES;
                        [weakSelf.carouselView bringSubviewToFront:weakSelf.captionView];
                    }
                    weakSelf.captionView.frame = [weakSelf frameForCaptionView:weakSelf.captionView caption:caption];
                }
            }
        } ;
        _carouselView.doneUpdateCurrentIndex = ^(NSUInteger index) {
            weakSelf.currentIndex = index;
            NSUInteger totalCount = weakSelf.fetchResult.count>0?weakSelf.fetchResult.count:weakSelf.modelArray.count;
            weakSelf.customTitleLabel.text = [NSString stringWithFormat:@"%ld/%ld ",index+1,totalCount];
            [weakSelf.customTitleLabel sizeToFit];
        };
        
        _carouselView.handleScrollViewDelegate = ^(BOOL flag) {
            
            if (flag) {
                [weakSelf cancelControlHiding];
            }else{
                [weakSelf hideControlsAfterDelay];
            }
        };
        
        _carouselView.hideControls = ^{
            
            [weakSelf hideControls];
        };
        
        _carouselView.handleSingleTap = ^(NSUInteger index, NSUInteger mediaType) {
            
            if ([weakSelf areControlsHidden]) {
                [weakSelf showControls];
            }else{
                [weakSelf hideControls];
            }
        };
        
    }
    return _carouselView;
}
- (CGRect)frameForCaptionView:(MUCaptionView *)captionView caption:(NSString *)caption{
    CGRect pageFrame = [UIScreen mainScreen].bounds;
    CGSize captionSize = [captionView sizeThatFits:CGSizeMake(pageFrame.size.width, 0) withTitle:caption];
    CGRect captionFrame = CGRectMake(pageFrame.origin.x,
                                     pageFrame.size.height - captionSize.height - (self.toolbar.superview?self.toolbar.frame.size.height:0),
                                     pageFrame.size.width,
                                     captionSize.height);
    return CGRectIntegral(captionFrame);
}
-(void)initializationPreviewView{
    __weak typeof(self)weakSelf = self;
    self.carouselView.handleSingleTapWithPlayVideo = ^(NSUInteger index, NSUInteger mediaType) {
        
        if (weakSelf.fetchResult.count > 0) {
            PHAsset *asset = weakSelf.fetchResult[index];
            PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
            options2.deliveryMode=PHVideoRequestOptionsDeliveryModeAutomatic;
            PHImageManager *manager = [PHCachingImageManager defaultManager];
            [manager requestAVAssetForVideo:asset options:options2 resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                if (@available(iOS 9.0, *)) {
                    [weakSelf playVideo:urlAsset.URL];
                    
                }else{
                    [weakSelf _playVideo:urlAsset.URL];
                }
            }];
        }
    };
    
    
    
    
}
- (void)setFetchResult:(PHFetchResult *)fetchResult{
    _fetchResult = fetchResult;
    if (fetchResult.count > 0) {
        self.carouselView.currentIndex    = self.currentIndex;
        self.carouselView.mediaType       = self.mediaType;
        self.carouselView.fetchResult     = fetchResult;
        self.title = [NSString stringWithFormat:@"%ld/%ld ",_currentIndex+1,fetchResult.count];
    }
}

- (void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    if (modelArray.count >0) {
        self.carouselView.currentIndex    = self.currentIndex;
        self.carouselView.mediaType  = self.mediaType;
        self.carouselView.imageModelArray = modelArray;
        self.title = [NSString stringWithFormat:@"%ld/%ld ",_currentIndex+1,modelArray.count];
    }
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)_playVideo:(NSURL *)videoURL {
    
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Setup player
        weakSelf.currentVideoPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [weakSelf.currentVideoPlayerViewController.moviePlayer prepareToPlay];
        weakSelf.currentVideoPlayerViewController.moviePlayer.shouldAutoplay = YES;
        weakSelf.currentVideoPlayerViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        weakSelf.currentVideoPlayerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakSelf presentViewController:weakSelf.currentVideoPlayerViewController animated:YES completion:nil];
    });
    
}
#pragma clang diagnostic pop
- (void)playVideo:(NSURL *)videoURL {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Setup player
        self.playerViewController.player = [AVPlayer playerWithURL:videoURL];
        self.playerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        // Show
        __weak typeof(self)weakSelf = self;
        [self presentViewController:weakSelf.playerViewController animated:YES completion:^{
            [weakSelf.playerViewController.player play];
        }];
    });
    
}
- (AVPlayerViewController *)playerViewController{
    if (!_playerViewController) {
        
        _playerViewController  = [[AVPlayerViewController alloc] init];
        // 是否显示播放控制条
        _playerViewController.showsPlaybackControls = YES;
        _playerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerViewController;
}
// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
    if (![self areControlsHidden]) {
        [self cancelControlHiding];
        _controlVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:self.delayToHideElements target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    }
}
- (BOOL)areControlsHidden { return (_toolbar.alpha == 0)&&(_captionView.alpha == 0); }
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
    
    if ((_toolbar.alpha == 0 && _captionView.alpha == 0)&&hidden) {//已经隐藏过
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
    __weak typeof(self)weakSelf = self;
    MUCaptionView *caption = _captionView;
    UIToolbar *toolbar = _toolbar;
    [UIView animateWithDuration:animationDuration animations:^(void) {
        
        CGFloat alpha = hidden ? 0 : 1;
        
        // Nav bar slides up on it's own on iOS 7+
        [self.navigationController.navigationBar setAlpha:alpha];
        
        if (toolbar) {
            weakSelf.toolbar.frame = [self frameForToolbarAtOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
            if (hidden)weakSelf.toolbar.frame = CGRectOffset(weakSelf.toolbar.frame, 0, animatonOffset);
            weakSelf.toolbar.alpha = alpha;
        }
        // Toolbar
        if (caption) {
            CGRect captionFrame = [self frameForCaptionView:weakSelf.captionView caption:nil];
            if (hidden) captionFrame = CGRectOffset(captionFrame, 0, animatonOffset);
            weakSelf.captionView.frame = captionFrame;
            weakSelf.captionView.alpha = alpha;
        }
        
    } completion:^(BOOL finished) {}];
    
    // Control hiding timer
    // Will cancel existing timer but only begin hiding if
    // they are visible
    if (!permanent) [self hideControlsAfterDelay];
    
}

#pragma mark - Frame Calculations
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
   
    CGFloat height =  49.;
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if(MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) == 812.0 && !UIInterfaceOrientationIsLandscape(orientation)){//iPhone X
            height += 34.;
        }else if(UIInterfaceOrientationIsLandscape(orientation)){
            height = 49.;
        }
    }
    return CGRectIntegral(CGRectMake(0, [UIScreen mainScreen].bounds.size.height - height, [UIScreen mainScreen].bounds.size.width, height));
}

@end
