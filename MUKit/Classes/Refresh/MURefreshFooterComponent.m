//
//  MURefreshFooterComponent.m
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import "MURefreshFooterComponent.h"
#import "MUHookMethodHelper.h"
#import "MURefreshComponent.h"
NSString *const MURefreshFooterContentSize   = @"contentSize";
NSString *const MURefreshFooterContentOffset = @"contentOffset";
@interface MURefreshFooterComponent()
@property(nonatomic, strong)MURefreshComponent *component;

@property(nonatomic, assign)BOOL finish;
@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, assign)UIEdgeInsets scrollViewInsets;
@property(nonatomic, assign ,getter=isObserver)BOOL observer;
@property(nonatomic, assign ,getter=isRefreshing)BOOL refreshing;//是否正在刷新
@property(nonatomic, assign)BOOL nomoreData;
@end
@implementation MURefreshFooterComponent


-(instancetype)initWithFrame:(CGRect)frame callback:(void (^)(MURefreshFooterComponent *))callback{
    if (self = [super initWithFrame:frame]) {
        _component    = [[MURefreshComponent alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) type:MURefreshingTypeFooter backgroundImage:nil];
        _callback     =  callback;
        _refreshing   = NO;
        _finish       = NO;
        _component.hidden = YES;
        _refresh      = NO;
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
# pragma mark - Action
- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        self.scrollView.contentInset = self.scrollViewInsets;
    } else {
        UIEdgeInsets oldInsets = self.scrollView.contentInset;
        oldInsets.bottom       = oldInsets.bottom + CGRectGetHeight(self.frame);
        self.scrollView.contentInset = oldInsets;
    }
}
- (void)removeObserver {
    if (self.isObserver) {
        self.observer = NO;
        [self.superview removeObserver:self forKeyPath:MURefreshFooterContentSize];
        [self.superview removeObserver:self forKeyPath:MURefreshFooterContentOffset];
    }
}
# pragma KVO Method
- (void)addObserver {
    if (!self.isObserver) {
        self.observer = YES;
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [self.scrollView addObserver:self forKeyPath:MURefreshFooterContentSize options:options context:nil];
        [self.scrollView addObserver:self forKeyPath:MURefreshFooterContentOffset options:options context:nil];
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
    if ([keyPath isEqualToString:MURefreshFooterContentOffset]) {
        if (!self.finish) {
            
            [self contentOffsetChangeAction:change];
        }
    }
    if ([keyPath isEqualToString:MURefreshFooterContentSize]) {
        
        if (!self.finish) {
            
           [self contentSizeChangeAction:change];
        }
        
    }
}
- (void)contentSizeChangeAction:(NSDictionary *)change {
    CGFloat targetY = self.scrollView.contentSize.height + self.scrollViewInsets.bottom;
    if (self.frame.origin.y != targetY) {
        CGRect frame = self.frame;
        frame.origin.y = targetY;
        self.frame = frame;
    }
}
-(void)contentOffsetChangeAction:(NSDictionary *)change{
    
    if (self.nomoreData) {
        return;
    }
    if (self.scrollView.contentOffset.y + self.scrollView.bounds.size.height > self.scrollView.contentSize.height) {
        if (self.scrollView.contentOffset.y + self.scrollView.contentInset.top >= self.frame.size.height/2.0) {
            if (_component.hidden) {
                _component.hidden = NO;
            }
            [self startToRefresh];
        }
    }
}

-(void)startToRefresh{
    if (self.isRefreshing) {
        return;
    }
    self.refresh           = YES;
    [self.component updateRefreshing:MURefreshingTypeFooter state:MURefreshingStateRefreshing];
    self.refreshing        = YES;
    self.finish            = YES;
//    UIEdgeInsets oldInsets = self.scrollViewInsets;
//    oldInsets.bottom       = oldInsets.bottom + CGRectGetHeight(self.frame);
//    self.scrollView.contentInset = oldInsets;
//    NSLog(@"botottom == %f",self.scrollView.contentOffset.y);
    CGFloat y = MAX(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollViewInsets.bottom);
//     NSLog(@"newbotottom == %f",y);
     self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x,y);
    
    if (self.callback) {
        
        self.callback(self);
    }
    self.finish = NO;
}
-(void)stopRefreshing{
    [self.component updateRefreshing:MURefreshingTypeFooter state:MURefreshingStateRefreDone];
    self.refreshing = NO;
//    self.scrollView.contentInset = self.scrollViewInsets;
}

-(void)dealloc{
    [self removeObserver];
}
-(void)noMoreData{
    self.nomoreData = YES;
    [self stopRefreshing];
    [self.component updateRefreshing:MURefreshingTypeFooter state:MURefreshingStateNoMoreData];
    
}
-(void)startRefresh{
    [self startToRefresh];
}
-(void)endRefreshing{
    [self stopRefreshing];
}
@end
