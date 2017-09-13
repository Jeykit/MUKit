//
//  MURefreshHeaderComponent.m
//  Pods
//
//  Created by Jekity on 2017/8/30.
//
//

#import "MURefreshHeaderComponent.h"
#import "MUHookMethodHelper.h"
#import "MURefreshComponent.h"

NSString *const MURefreshContentOffset = @"contentOffset";
@interface MURefreshHeaderComponent()
@property(nonatomic, strong)MURefreshComponent *component;
@property (nonatomic, assign) CGFloat offsetY;   //原始的偏移量
@property(nonatomic, assign)BOOL finish;
@property(nonatomic, assign ,getter=isRefreshing)BOOL refreshing;//是否正在刷新
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, assign)UIEdgeInsets scrollViewInsets;
@property(nonatomic, assign ,getter=isObserver)BOOL observer;
@end
@implementation MURefreshHeaderComponent

-(instancetype)initWithFrame:(CGRect)frame callback:(void (^)(MURefreshHeaderComponent*))callback{
    if (self = [super initWithFrame:frame]) {
        _component    = [[MURefreshComponent alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) type:MURefreshingTypeHeader backgroundImage:nil];
        _callback     =  callback;
        _refreshing   = NO;
        _finish       = NO;
        _component.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_component];
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    [self removeObserver];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollViewInsets = self.scrollView.contentInset;
        [self addObserver];
    }
}
- (void)removeObserver {
    if (self.isObserver) {
        self.observer = NO;
        [self.superview removeObserver:self forKeyPath:MURefreshContentOffset];
    }
}
# pragma KVO Method
- (void)addObserver {
    if (!self.isObserver) {
        self.observer = YES;
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [self.scrollView addObserver:self forKeyPath:MURefreshContentOffset options:options context:nil];
    }
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.component.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    self.component.backgroundImageView.image = backgroundImage;
}
#pragma mark- contentOffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!self.userInteractionEnabled || self.hidden) {
        return;
    }
    if ([keyPath isEqualToString:MURefreshContentOffset]) {
        [self contentOffsetChangeAction:change];
    }
}
-(void)contentOffsetChangeAction:(NSDictionary *)change{
    CGFloat offsets = self.offsetY + self.scrollViewInsets.top;
    if (offsets < 0) {
            if (!self.isRefreshing) {
                 CGFloat progress = -offsets/CGRectGetHeight(self.bounds);
                if (progress > 1) {
                    
                    if (!self.scrollView.isDragging) {
                         [self startToRefresh];
                        [self.component updateRefreshing:MURefreshingTypeHeader state:MURefreshingStateRefreshing];
                       
                    }else{
                        [self.component updateRefreshing:MURefreshingTypeHeader state:MURefreshingStateWillRefresh];
                    }

                }else{
                    if (!self.finish) {
                         [self.component updateRefreshing:MURefreshingTypeHeader state:MURefreshingStateNormal];
                    }
                    
                    
                }
            }
       
    }
    self.offsetY = self.scrollView.contentOffset.y;
}
#pragma mark -refresh animation
-(void)startToRefresh{
    if (!self.isRefreshing) {
        self.refreshing = YES;
        self.scrollView.bounces = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.375 animations:^{
                self.scrollViewInsets  = self.scrollView.contentInset;
                UIEdgeInsets oldInsets = self.scrollViewInsets;
                oldInsets.top = oldInsets.top + CGRectGetHeight(self.bounds);
                self.scrollView.contentInset = oldInsets;
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, -self.scrollView.contentInset.top);
            } completion:^(BOOL finished) {
                self.scrollView.bounces = YES;
                if (self.callback) {
                    self.callback(self);
                }
            }];
            
        });
    }

}

-(void)stopRefreshing{
    if (self.isRefreshing) {
        dispatch_after((uint64_t)(0.5), dispatch_get_main_queue(), ^{
             [self.component updateRefreshing:MURefreshingTypeHeader state:MURefreshingStateRefreDone];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.375f animations:^{
                    self.scrollView.contentInset = self.scrollViewInsets;
                    self.offsetY = self.scrollView.contentOffset.y;
                } completion:^(BOOL finished) {
                    self.finish = NO;
                    self.refreshing = NO;
                    [self.component updateRefreshing:MURefreshingTypeHeader state:MURefreshingStateNormal];
                }];
            });

        });
        
    }
}
-(void)startRefresh{
    [self startToRefresh];
}
-(void)endRefreshing{
    [self stopRefreshing];
}
-(void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:MURefreshContentOffset];
    self.scrollView = nil;
}

@end
