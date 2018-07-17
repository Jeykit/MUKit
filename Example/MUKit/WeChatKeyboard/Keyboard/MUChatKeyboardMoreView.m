//
//  MUChatKeyboardMoreView.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/30.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUChatKeyboardMoreView.h"
#import "MUChatKeyboardMoreViewItem.h"

#define topLineH  0.5
#define bottomH  18
@interface MUChatKeyboardMoreView ()<UIScrollViewDelegate>

@property (nonatomic, weak)UIView *topLine;
@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIPageControl *pageControl;
@end
@implementation MUChatKeyboardMoreView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:237./255. green:237./255. blue:246./255. alpha:1.];
        [self topLine];
        [self scrollView];
        [self pageControl];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.scrollView setFrame:CGRectMake(0, topLineH, frame.size.width,frame.size.height-bottomH)];
    [self.pageControl setFrame:CGRectMake(0, frame.size.height-bottomH, frame.size.width, 8)];
}

#pragma mark - Public Methods

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    self.pageControl.numberOfPages = items.count / 8 + 1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width_Mu * (items.count / 8 + 1), _scrollView.height_Mu);
    
    float w = self.width_Mu * 20 / 21 / 4 * 0.8;
    float space = w / 4;
    float h = (self.height_Mu - 20 - space * 2) / 2;
    float x = space, y = space;
    int i = 0, page = 0;
    for (MUChatKeyboardMoreViewItem * item in _items) {
        [self.scrollView addSubview:item];
        [item setFrame:CGRectMake(x, y, w, h)];
        [item setTag:i];
        [item addTarget:self action:@selector(didSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
        i ++;
        page = i % 8 == 0 ? page + 1 : page;
        x = (i % 4 ? x + w : page * self.width_Mu) + space;
        y = (i % 8 < 4 ? space : h + space * 1.5);
    }
    
}

// 点击了某个Item
- (void) didSelectedItem:(MUChatKeyboardMoreViewItem *)sender
{

    if (self.itemByTaped) {
        self.itemByTaped(sender.tag);
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / self.width_Mu;
    [_pageControl setCurrentPage:page];
}


#pragma mark - Getter and Setter

- (UIScrollView *)scrollView
{
    if (nil == _scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setPagingEnabled:YES];
        scrollView.delegate = self;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (nil == _pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIView *)topLine
{
    if (nil == _topLine) {
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,topLineH)];
        [self addSubview:topLine];
        topLine.backgroundColor = [UIColor colorWithRed:188./255. green:188./255. blue:188./255. alpha:1.];
        _topLine = topLine;
    }
    return _topLine;
}


#pragma mark - Privite Method

- (void)pageControlClicked:(UIPageControl *)pageControl
{
    [self.scrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * kScreenWidth, 0, kScreenWidth, self.scrollView.height_Mu) animated:YES];
}


@end
