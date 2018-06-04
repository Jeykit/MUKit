//
//  MURefreshComponent.m
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import "MURefreshComponent.h"
#import "MURefreshHeaderComponent.h"


@interface MURefreshLabel : UILabel<CAAnimationDelegate>
- (void)startAnimating;
@end
@implementation MURefreshLabel{
    CAGradientLayer * gradientLayer;
}

-(instancetype)init{
    if (self = [super init]) {
        
        gradientLayer = [CAGradientLayer new];
        gradientLayer.locations = @[@0.2,@0.5,@0.8];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:gradientLayer];
        
    }
    return self;
}
- (void)layoutSubviews{
    gradientLayer.frame = CGRectMake(0, 0, 0, self.height_Mu);
    gradientLayer.position = CGPointMake(self.width_Mu/2.0, self.height_Mu/2.);
}
- (void)startAnimating{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1.0;
    }];
    gradientLayer.colors = @[(id)[self.textColor colorWithAlphaComponent:0.2].CGColor,
                   (id)[self.textColor colorWithAlphaComponent:0.2].CGColor,
                   (id)[self.textColor colorWithAlphaComponent:0.2].CGColor];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    animation.fromValue = @(0);
    animation.toValue = @(self.width_Mu);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.3;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [gradientLayer addAnimation:animation forKey:animation.keyPath];
}

- (void)stopAnimating{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0.0;
    }];
    [gradientLayer removeAllAnimations];
}

@end
@interface MURefreshComponent()
@property (nonatomic, weak) __kindof UIScrollView *scrollView;
@property (nonatomic, getter=isRefresh) BOOL refresh;
@property (assign, nonatomic,getter=isObservering) BOOL observering;
@property (strong, nonatomic) MURefreshLabel *alertLabel;
@property (assign, nonatomic, getter=isShouldNoLongerRefresh) BOOL shouldNoLongerRefresh;
@property(nonatomic, assign)BOOL firstRefreshing;
@end

static NSString * const MUContentOffset = @"contentOffset";
static NSString * const MUContentSize = @"contentSize";
static CGFloat const MURefreshHeight = 44.;
static CGFloat const kStretchOffsetYAxisThreshold = 1.0;
@implementation MURefreshComponent

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperties];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupProperties];
    }
    return self;
}
- (void)setupProperties{
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.;
    [self addSubview:self.alertLabel];
    _firstRefreshing = YES;
    _refreshState = MURefreshStateNone;
    _stretchOffsetYAxisThreshold = kStretchOffsetYAxisThreshold;
    _shouldNoLongerRefresh = NO;
    _refresh = NO;
    if (CGRectEqualToRect(self.frame, CGRectZero)) self.frame = CGRectMake(0, 0, 1, 1);
}
-(void)setRefreshState:(MURefreshingState)refreshState{
    if (_refreshState == refreshState) return;
    _refreshState = refreshState;
    
    #define MU_SET_ALPHA(a) __weak typeof(self) weakSelf = self;\
        [self setAnimateBlock:^{\
        weakSelf.alpha = (a);\
   } completion:NULL];
    
    switch (refreshState) {
        case MURefreshStateNone:{
            MU_SET_ALPHA(0.);
            break;
        }
        case MURefreshStateScrolling:{
            ///when system adjust contentOffset atuomatically,
            ///will trigger refresh control's state changed.
            if (!self.isAutoRefreshing && !self.scrollView.isTracking) {
                return;
            }
            MU_SET_ALPHA(1.);
            break;
        }
        case MURefreshStateReady:{
            ///because of scrollView contentOffset is not continuous change.
            ///need to manually adjust progress
            if (self.progress < self.stretchOffsetYAxisThreshold) {
                [self MUDidScrollWithProgress:self.stretchOffsetYAxisThreshold max:self.stretchOffsetYAxisThreshold];
            }
             MU_SET_ALPHA(1.);
            break;
        }
        case MURefreshStateRefreshing:{
            break;
        }
        case MURefreshStateWillEndRefresh:{
            MU_SET_ALPHA(1.);
            break;
        }
    }
    [self MURefreshStateDidChange:refreshState];//刷新状态改变

}
- (void)setProgress:(CGFloat)progress{
    if (_progress == progress) return;
    _progress = progress;
    [self MUDidScrollWithProgress:progress max:self.stretchOffsetYAxisThreshold];
}

- (void)setStretchOffsetYAxisThreshold:(CGFloat)stretchOffsetYAxisThreshold{
    if (_stretchOffsetYAxisThreshold != stretchOffsetYAxisThreshold &&
        stretchOffsetYAxisThreshold > 1.0) {
        _stretchOffsetYAxisThreshold = stretchOffsetYAxisThreshold;
    }
}

- (BOOL)isRefresh{
    return (_refreshState == MURefreshStateRefreshing);
}
#pragma mark - layout

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.height_Mu = (self.height_Mu < 44.) ? MURefreshHeight  : self.height_Mu;
    self.frame = CGRectMake(0, 0, self.scrollView.width_Mu, self.height_Mu);
    self.alertLabel.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    if (self.superview && newSuperview == nil) {
        if (_observering) {
            [self.superview removeObserver:self forKeyPath:MUContentOffset];
            [self.superview removeObserver:self forKeyPath:MUContentSize];
            _observering = NO;
        }
    }
    else if (self.superview == nil && newSuperview){
        if (!_observering) {
            _scrollView = (UIScrollView *)newSuperview;
            //sometimes, this method called before `layoutSubviews`,such as UICollectionViewController
            [self layoutIfNeeded];
            _preSetContentInsets = ((UIScrollView *)newSuperview).realContentInsetMu;
            [newSuperview addObserver:self forKeyPath:MUContentOffset options:options context:nil];
            [newSuperview addObserver:self forKeyPath:MUContentSize options:options context:nil];
            _observering = YES;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([self isKindOfClass:[MURefreshHeaderComponent class]] && self.firstRefreshing){
        return;
    }
    if ([keyPath isEqualToString:MUContentOffset]) {
        //If you disable the control's refresh feature, set the control to hidden
        if (self.isHidden) return;
        
        CGPoint point = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        //If you quickly scroll scrollview in an instant, contentoffset changes are not continuous
        [self privateContentOffsetOfScrollViewDidChange:point];
    }
    else if([keyPath isEqualToString:MUContentSize]){
        [self layoutSubviews];
    }
}

- (void)privateContentOffsetOfScrollViewDidChange:(CGPoint)contentOffset{}

-(void)beginRefreshing{
    
    if ([self isKindOfClass:[MURefreshHeaderComponent class]] && self.firstRefreshing) {
        
        if (self.refreshHandler) {
            self.refreshHandler(self);
            self.firstRefreshing = NO;
        }
        return;
    }
    if (self.refreshState != MURefreshStateNone || self.isHidden || self.isAutoRefreshing) return;
    if (self.isShouldNoLongerRefresh)  self.alertLabel.hidden = YES;
    self.shouldNoLongerRefresh = NO;
    self.autoRefreshing = YES;
    [self setScrollViewToRefreshLocation];
}

- (void)setScrollViewToRefreshLocation{
    self.animating = YES;
}

- (void)endRefreshing{
    [self endRefreshingWithText:nil completion:nil];
}

- (void)endRefreshingWithText:(NSString *)text completion:(dispatch_block_t)completion {
      if ([self isKindOfClass:[MURefreshHeaderComponent class]] && self.firstRefreshing) {
          if (completion) {
              completion();
          }
      }
    if((!self.isRefresh && !self.isAnimating) || self.isHidden) return;
    if (text) {
        [self bringSubviewToFront:self.alertLabel];
        self.alertLabel.text = text;
        [self.alertLabel startAnimating];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.alertLabel stopAnimating];
            [weakSelf _endRefresh];
            if (completion) completion();
        });
    }else{
        [self _endRefresh];
    }
}

- (void)endRefreshingAndNoLongerRefreshingWithAlertText:(NSString *)text{
    if((!self.isRefresh && !self.isAnimating) || self.isHidden) return;
    if (self.isShouldNoLongerRefresh) return;
    self.shouldNoLongerRefresh = YES;
    __weak typeof(self) weakSelf = self;
    if (self.alertLabel.alpha == 0.0){
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alertLabel.alpha = 1.0;
        }];
    }
    [self bringSubviewToFront:self.alertLabel];
    self.alertLabel.text = text;
    if (text) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf _endRefresh];
        });
    }else{
        [self _endRefresh];
    }
}

- (void)resumeRefreshAvailable{
    self.shouldNoLongerRefresh = NO;
    self.alertLabel.alpha = 0.0;
}

- (void)_endRefresh{
    [self MURefreshStateDidChange:MURefreshStateWillEndRefresh];
    self.refreshState = MURefreshStateScrolling;
    [self setScrollViewToOriginalLocation];
}

- (void)setScrollViewToOriginalLocation{}

#pragma mark -

#pragma mark - progress callback
-(void)MURefreshStateDidChange:(MURefreshingState)state{}
-(void)MUDidScrollWithProgress:(CGFloat)progress max:(const CGFloat)max{}

#pragma mark - getter

- (MURefreshLabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [MURefreshLabel new];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font =  [UIFont fontWithName:@"Helvetica" size:15.f];
        _alertLabel.textColor = [UIColor blackColor];
        _alertLabel.alpha = 0.0;
        _alertLabel.backgroundColor = [UIColor whiteColor];
    }
    return _alertLabel;
}
-(void)setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        _textColor = textColor;
        _alertLabel.textColor = textColor;
        
    }
}
- (void)setAnimateBlock:(dispatch_block_t)block completion:(dispatch_block_t)completion{
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:block
                     completion:^(BOOL finished) {
                         if (completion) completion();
                     }];
}
@end
