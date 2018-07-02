//
//  MUEmotionListView.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUEmotionListView.h"
#import "MUEmotionPageView.h"


@interface MUEmotionListView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIView *topLine;
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIPageControl *pageControl;
@end
@implementation MUEmotionListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:237./255. green:237./255. blue:246./255. alpha:1.];
        
        [self topLine];
        [self scrollview];
        [self pageControl];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.pageControl.width_Mu =  self.width_Mu;
    self.pageControl.height_Mu = 10;
    self.pageControl.x_Mu = 0;
    self.pageControl.y_Mu = self.height_Mu - self.pageControl.height_Mu;
    
    self.scrollview.width_Mu = self.width_Mu;
    self.scrollview.height_Mu = self.pageControl.y_Mu;
    self.scrollview.x_Mu = self.scrollview.y_Mu = 0;
    
    NSUInteger count = self.scrollview.subviews.count;
    for (int i =0 ; i< count; i++) {
        MUEmotionPageView *pageview = self.scrollview.subviews[i];
        pageview.width_Mu = self.scrollview.width_Mu ;
        pageview.height_Mu = self.scrollview.height_Mu;
        pageview.x_Mu = i *pageview.width_Mu;
        pageview.y_Mu = 0;
    }
    self.scrollview.contentSize =CGSizeMake(count *self.scrollview.width_Mu, 0);
}
-(void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = (emotions.count + MUEmotionPageSize -1)/MUEmotionPageSize;
    self.pageControl.numberOfPages = count;
    for (int i = 0; i< count; i++) {
        MUEmotionPageView *pageView =[[MUEmotionPageView alloc]init];
        NSRange range;
        range.location  =   i * MUEmotionPageSize;
        NSUInteger left =   emotions.count - range.location;//剩余
        if (left >= MUEmotionPageSize) {
            range.length = MUEmotionPageSize;
        }else{
            range.length = left;
        }
        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollview addSubview:pageView];
    }
    [self setNeedsLayout];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNum                = scrollView.contentOffset.x/scrollView.width_Mu;
    self.pageControl.currentPage  = (int)(pageNum+0.5);
}
- (UIView *)topLine
{
    if (!_topLine) {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight,0.5)];
        [self addSubview:topLine];
        topLine.backgroundColor = [UIColor colorWithRed:188./255. green:188./255. blue:188./255. alpha:1.];
        _topLine = topLine;
    }
    return _topLine;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl =[[UIPageControl alloc]init];
        [self addSubview:_pageControl];
        _pageControl.currentPageIndicatorTintColor =[UIColor grayColor];
        _pageControl.pageIndicatorTintColor =[UIColor lightGrayColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
-(UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview =[[UIScrollView alloc]init];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        [self addSubview:_scrollview];
    }
    return _scrollview;
}
@end
