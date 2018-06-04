//
//  MURefreshFooterComponent.m
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import "MURefreshFooterComponent.h"



@implementation MURefreshFooterComponent

- (void)layoutSubviews{
    [super layoutSubviews];
    self.topMu = self.scrollView.contentHeightMu;
}

static inline CGPoint RefreshingPoint(MURefreshComponent *cSelf){
    UIScrollView * sc = cSelf.scrollView;
    CGFloat x = sc.leftMu;
    CGFloat y = sc.contentHeightMu - sc.height_Mu - cSelf.height_Mu;
    return CGPointMake(x,y);
}

- (void)setScrollViewToRefreshLocation{
    [super setScrollViewToRefreshLocation];
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t animatedBlock = ^(void){
        if (weakSelf.isAutoRefreshing) {
            weakSelf.refreshState = MURefreshStateScrolling;
            if (weakSelf.scrollView.contentHeightMu >= weakSelf.scrollView.height_Mu &&
                weakSelf.scrollView.offsetYMu >= weakSelf.scrollView.contentHeightMu - weakSelf.scrollView.height_Mu) {
                ///////////////////////////////////////////////////////////////////////////////////////////
                ///This condition can be pre-execute refreshHandler, and will not feel scrollview scroll
                ///////////////////////////////////////////////////////////////////////////////////////////
                [weakSelf.scrollView setContentOffset:RefreshingPoint(weakSelf)];
                [weakSelf MUDidScrollWithProgress:0.5 max:weakSelf.stretchOffsetYAxisThreshold];
            }
        }
        weakSelf.scrollView.insetBottomMu = weakSelf.preSetContentInsets.bottom + weakSelf.height_Mu;
    };
    
    dispatch_block_t completionBlock = ^(void){
        if (weakSelf.refreshHandler) weakSelf.refreshHandler(self);
        if (weakSelf.isAutoRefreshing) {
            weakSelf.refreshState = MURefreshStateReady;
            weakSelf.refreshState = MURefreshStateRefreshing;
            [weakSelf MUDidScrollWithProgress:1. max:weakSelf.stretchOffsetYAxisThreshold];
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.preSetContentInsets = weakSelf.scrollView.realContentInsetMu;
        [weakSelf setAnimateBlock:animatedBlock completion:completionBlock];
    });
}

- (void)setScrollViewToOriginalLocation{
    [super setScrollViewToOriginalLocation];
    __weak typeof(self) weakSelf = self;
    [self setAnimateBlock:^{
        weakSelf.animating = YES;
        weakSelf.scrollView.insetBottomMu = weakSelf.preSetContentInsets.bottom;
    } completion:^{
        weakSelf.animating = NO;
        weakSelf.autoRefreshing = NO;
        weakSelf.refreshState = MURefreshStateNone;
    }];
}

#pragma mark - contentOffset

static CGFloat MaxYForTriggeringRefresh(MURefreshComponent * cSelf){
    UIScrollView * sc = cSelf.scrollView;
    CGFloat y = sc.contentHeightMu - sc.height_Mu + cSelf.stretchOffsetYAxisThreshold*cSelf.height_Mu + cSelf.preSetContentInsets.bottom;
    return y;
}

static CGFloat MinYForNone(MURefreshComponent * cSelf){
    UIScrollView * sc = cSelf.scrollView;
    CGFloat y = sc.contentHeightMu - sc.height_Mu + cSelf.preSetContentInsets.bottom;
    return y;
}

- (void)privateContentOffsetOfScrollViewDidChange:(CGPoint)contentOffset{
    [super privateContentOffsetOfScrollViewDidChange:contentOffset];
    if (self.refreshState != MURefreshStateRefreshing) {
        if (self.isAutoRefreshing) return;
        
        self.preSetContentInsets = self.scrollView.realContentInsetMu;
        
        CGFloat originY = 0.0, maxY = 0.0, minY = 0.0;
        if (self.scrollView.contentHeightMu + self.preSetContentInsets.top <= self.scrollView.height_Mu){
            maxY = self.stretchOffsetYAxisThreshold*self.height_Mu;
            minY = 0;
            originY = contentOffset.y + self.preSetContentInsets.top;
            if (self.refreshState == MURefreshStateScrolling){
                CGFloat progress = fabs(originY)/self.height_Mu;
                if (progress <= self.stretchOffsetYAxisThreshold) {
                    self.progress = progress;
                }
            }
        }else{
            maxY = MaxYForTriggeringRefresh(self);
            minY = MinYForNone(self);
            originY = contentOffset.y;
            /////////////////////////
            ///uncontinuous callback
            /////////////////////////
            if (originY < minY - 50.0) return;
            CGFloat contentOffsetBottom = self.scrollView.contentHeightMu - self.scrollView.height_Mu;
            if (self.refreshState == MURefreshStateScrolling){
                CGFloat progress = fabs((originY - contentOffsetBottom - self.preSetContentInsets.bottom))/self.height_Mu;
                if (progress <= self.stretchOffsetYAxisThreshold) {
                    self.progress = progress;
                }
            }
        }
        
        if (!self.scrollView.isDragging && self.refreshState == MURefreshStateReady){
            self.autoRefreshing = NO;
            self.refreshState = MURefreshStateRefreshing;
            [self setScrollViewToRefreshLocation];
        }
        else if (originY <= minY && !self.isAnimating){
            self.refreshState = MURefreshStateNone;
        }
        else if (self.scrollView.isDragging && originY >= minY
                 && originY <= maxY && self.refreshState != MURefreshStateScrolling){
            self.refreshState = MURefreshStateScrolling;
        }
        else if (self.scrollView.isDragging && originY > maxY && !self.isAnimating
                 && self.refreshState != MURefreshStateReady && !self.isShouldNoLongerRefresh){
            self.refreshState = MURefreshStateReady;
        }
    }
}
@end
