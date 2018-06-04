//
//  MURefreshHeaderComponent.m
//  Pods
//
//  Created by Jekity on 2017/8/30.
//
//

#import "MURefreshHeaderComponent.h"
#import "MURefreshComponent.h"



@implementation MURefreshHeaderComponent


- (void)layoutSubviews{
    [super layoutSubviews];
    self.topMu = -self.height_Mu;
}

static inline CGPoint RefreshingPoint(MURefreshComponent *cSelf){
    UIScrollView * sc = cSelf.scrollView;
    CGFloat x = sc.leftMu;
    CGFloat y = -(cSelf.height_Mu + cSelf.preSetContentInsets.top);
    return CGPointMake(x,y);
}

- (void)setScrollViewToRefreshLocation{
    [super setScrollViewToRefreshLocation];
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t animatedBlock = ^(void){
        if (weakSelf.isAutoRefreshing) {
            weakSelf.refreshState = MURefreshStateScrolling;
            ///////////////////////////////////////////////////////////////////////////////////////////
            /*
             In general, we use UITableView, especially UITableView need to use the drop-down refresh,
             we rarely set SectionHeader. Unfortunately, if you use SectionHeader and integrate with
             UIRefreshControl or other third-party libraries, the refresh effect will be very ugly.
             
             This code has two effects:
             1.  when using SectionHeader refresh effect is still very natural.
             2.  when your scrollView using preloading technology, only in the right place,
             such as pull down a pixel you can see the refresh control case, will show the
             refresh effect. If the pull-down distance exceeds the height of the refresh control,
             then the refresh control has long been unable to appear on the screen,
             indicating that the top of the contentOffset office there is a long distance,
             this time, even if you call the beginRefreshing method, ScrollView position and effect
             are Will not be affected, so the deal is very friendly in the data preloading technology.
             */
            CGFloat min = -weakSelf.preSetContentInsets.top;
            CGFloat max = -(weakSelf.preSetContentInsets.top-weakSelf.height_Mu);
            if (weakSelf.scrollView.offsetYMu >= min && weakSelf.scrollView.offsetYMu <= max) {
                [weakSelf.scrollView setContentOffset:RefreshingPoint(weakSelf)];
                [weakSelf MUDidScrollWithProgress:0.5 max:weakSelf.stretchOffsetYAxisThreshold];
                weakSelf.scrollView.insetTopMu = weakSelf.height_Mu + weakSelf.preSetContentInsets.top;
            }
            ///////////////////////////////////////////////////////////////////////////////////////////
        }else{
            weakSelf.scrollView.insetTopMu = weakSelf.height_Mu + weakSelf.preSetContentInsets.top;
        }
    };
    
    dispatch_block_t completionBlock = ^(void){
        if (weakSelf.isAutoRefreshing) {
            weakSelf.refreshState = MURefreshStateReady;
            weakSelf.refreshState = MURefreshStateRefreshing;
            [weakSelf MUDidScrollWithProgress:1. max:weakSelf.stretchOffsetYAxisThreshold];
        }
        if (weakSelf.refreshHandler) weakSelf.refreshHandler(self);
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.preSetContentInsets = weakSelf.scrollView.realContentInsetMu;
        [weakSelf setAnimateBlock:animatedBlock completion:completionBlock];
    });
}

- (void)setScrollViewToOriginalLocation{
    [super setScrollViewToOriginalLocation];
    __weak typeof(self) weakSelf = self;
    dispatch_block_t animationBlock = ^{
        weakSelf.animating = YES;
        weakSelf.scrollView.insetTopMu = weakSelf.preSetContentInsets.top;
    };
    
    dispatch_block_t completion = ^{
        weakSelf.animating = NO;
        weakSelf.autoRefreshing = NO;
        weakSelf.refreshState = MURefreshStateNone;
    };
    [self setAnimateBlock:animationBlock completion:completion];
}

#pragma mark - contentOffset

static CGFloat MaxYForTriggeringRefresh( MURefreshComponent* cSelf){
    CGFloat y = -cSelf.preSetContentInsets.top + cSelf.stretchOffsetYAxisThreshold * cSelf.topMu;
    return y;
}

static CGFloat MinYForNone(MURefreshComponent * cSelf){
    CGFloat y = -cSelf.preSetContentInsets.top;
    return y;
}

- (void)privateContentOffsetOfScrollViewDidChange:(CGPoint)contentOffset{
    [super privateContentOffsetOfScrollViewDidChange:contentOffset];
    CGFloat maxY = MaxYForTriggeringRefresh(self);
    CGFloat minY = MinYForNone(self);
    CGFloat originY = contentOffset.y;
    
    if (self.refreshState == MURefreshStateRefreshing) {
        //fix hover problem of sectionHeader
        if (originY < 0 && (-originY >= self.preSetContentInsets.top)) {
            CGFloat threshold = self.preSetContentInsets.top + self.height_Mu;
            if (-originY > threshold) {
                self.scrollView.insetTopMu = threshold;
            }else{
                self.scrollView.insetTopMu = -originY;
            }
        }else{
            if (self.scrollView.insetTopMu != self.preSetContentInsets.top) {
                self.scrollView.insetTopMu = self.preSetContentInsets.top;
            }
        }
    }else{
        if (self.isAutoRefreshing) return;
        
        self.preSetContentInsets = self.scrollView.realContentInsetMu;
        
        if (self.refreshState == MURefreshStateScrolling){
            CGFloat progress = (fabs((double)originY) - self.preSetContentInsets.top)/self.height_Mu;
            if (progress <= self.stretchOffsetYAxisThreshold) {
                self.progress = progress;
            }
        }
        
        if (!self.scrollView.isDragging && self.refreshState == MURefreshStateReady){
            self.autoRefreshing = NO;
            self.refreshState = MURefreshStateRefreshing;
            [self setScrollViewToRefreshLocation];
        }
        else if (originY >= minY && !self.isAnimating){
            self.refreshState = MURefreshStateNone;
        }
        else if (self.scrollView.isDragging && originY <= minY
                 && originY >= maxY && self.refreshState != MURefreshStateScrolling){
            self.refreshState = MURefreshStateScrolling;
        }
        else if (self.scrollView.isDragging && originY < maxY && !self.isAnimating
                 && self.refreshState != MURefreshStateReady && !self.isShouldNoLongerRefresh){
            self.refreshState = MURefreshStateReady;
        }
    }
}

@end
