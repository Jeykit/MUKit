//
//  MUTextScrollView.m
//  ZPApp
//
//  Created by Jekity on 2018/8/9.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUTextScrollView.h"

#define  kWidth  self.bounds.size.width
#define  kHeight self.bounds.size.height

@interface MUTextScrollView()<UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *scrollView;

// 前一个视图,当前视图,下一个视图
@property(strong, nonatomic) UILabel *lastLabel;
@property(strong, nonatomic) UILabel *currentLabel;
@property(strong, nonatomic) UILabel *nextLabel;
@property(strong, nonatomic) NSTimer *timer;
// kImageCount = array.count,图片数组个数
@property(assign, nonatomic) NSInteger kImageCount;
// 记录nextImageView的下标 默认从1开始
@property(assign, nonatomic) NSInteger nextPhotoIndex;
// 记录lastImageView的下标 默认从 _kImageCount - 1 开始
@property(assign, nonatomic) NSInteger lastPhotoIndex;
//pageControl图片大小
@property (nonatomic, assign) CGSize pageImageSize;
@property(nonatomic, assign)CGFloat currentImageHeight;

@end

@implementation MUTextScrollView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _duration = 2;
    _autoScroll = YES;
    _currentIndex = 0;
    
}
#pragma mark - lazy loading
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.layer.masksToBounds = YES;
    }
    return _scrollView;
}

- (UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel = [UILabel new];
        _lastLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _lastLabel;
}

- (UILabel *)currentLabel{
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.textAlignment = NSTextAlignmentLeft;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapActionInImageView:)];
        [_currentLabel addGestureRecognizer:tap];
        _currentLabel.userInteractionEnabled = YES;
    }
    return _currentLabel;
}

- (UILabel *)nextLabel{
    if (!_nextLabel) {
        _nextLabel = [UILabel new];
        _nextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nextLabel;
}

#pragma mark -configured
-(void)configure{
    
    self.scrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
    [self addSubview:self.scrollView];
    // 添加最初的三张imageView
    [self.scrollView addSubview:self.lastLabel];
    [self.scrollView addSubview:self.currentLabel];
    [self.scrollView addSubview:self.nextLabel];
    
    
    if (self.currentIndex > _kImageCount - 1 || self.currentIndex == 0) {
        // 将上一张图片设置为数组中最后一张图片
        [self setTetxLabel:_lastLabel withSubscript:(_kImageCount -1)];
        // 将当前图片设置为数组中第一张图片
         [self setTetxLabel:_currentLabel withSubscript:0];
        // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
        [self setTetxLabel:_nextLabel withSubscript:_kImageCount == 1 ? 0 : 1];
        self.nextPhotoIndex = 1;
        self.lastPhotoIndex = _kImageCount - 1;
    }else if(self.currentIndex == _kImageCount - 1){
        
        // 将上一张图片设置为数组中最后一张图片
         [self setTetxLabel:_lastLabel withSubscript:_currentIndex - 1];
        // 将当前图片设置为数组中第一张图片
        [self setTetxLabel:_currentLabel withSubscript:_currentIndex];
        // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
          [self setTetxLabel:_nextLabel withSubscript:0];
       
        self.nextPhotoIndex = 0;
        self.lastPhotoIndex = _currentIndex - 1;
    }else{
        
        // 将上一张图片设置为数组中最后一张图片
          [self setTetxLabel:_lastLabel withSubscript:_currentIndex - 1];
        // 将当前图片设置为数组中第一张图片
          [self setTetxLabel:_currentLabel withSubscript:_currentIndex];
        // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
          [self setTetxLabel:_nextLabel withSubscript:_currentIndex + 1];
        self.nextPhotoIndex = _currentIndex + 1;
        self.lastPhotoIndex = _currentIndex - 1;
    }
    
    _scrollView.contentSize = CGSizeMake(kWidth , kHeight*3);
    //显示中间的图片
    _scrollView.contentOffset = CGPointMake(0, kHeight);
    
    

    
    
    [self layoutIfNeeded];
}

#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 到第一张图片时   (一上来，当前图片的x值是kWidth)
    if (ceil(scrollView.contentOffset.y) <= 0) {  // 右滑
        
        _nextLabel.text = _currentLabel.text;
        _currentLabel.text = _lastLabel.text;
        _lastLabel.text = nil;
        scrollView.contentOffset = CGPointMake(0, kHeight);
        // 一定要是小于等于，否则数组中只有一张图片时会出错
        if (_lastPhotoIndex <= 0) {
            _lastPhotoIndex = _kImageCount - 1;
            _nextPhotoIndex = _lastPhotoIndex - (_kImageCount - 2);
        } else {
            _lastPhotoIndex--;
            if (_nextPhotoIndex == 0) {
                _nextPhotoIndex = _kImageCount - 1;
            } else {
                _nextPhotoIndex--;
            }
        }
        [self setTetxLabel:_lastLabel withSubscript:_lastPhotoIndex];
    }
    // 到最后一张图片时（最后一张就是轮播图的第三张）
    if ((ceil(scrollView.contentOffset.y)  >= ceil(kHeight)*2.)) {  // 左滑
        
        
        
        _lastLabel.text = _currentLabel.text;
        _currentLabel.text = _nextLabel.text;
        
        scrollView.contentOffset = CGPointMake(0, kHeight);
        _nextLabel.text = nil;
        // 一定要是大于等于，否则数组中只有一张图片时会出错
        if (_nextPhotoIndex >= _kImageCount - 1 ) {
            _nextPhotoIndex = 0;
            _lastPhotoIndex = _nextPhotoIndex + (_kImageCount - 2);
        } else{
            _nextPhotoIndex++;
            if (_lastPhotoIndex == _kImageCount - 1) {
                _lastPhotoIndex = 0;
            } else {
                _lastPhotoIndex++;
            }
        }
         [self setTetxLabel:_nextLabel withSubscript:_nextPhotoIndex];
        
    }
    if (self.doneUpdateCurrentIndex) {
        self.doneUpdateCurrentIndex(_nextPhotoIndex==0?_kImageCount:_nextPhotoIndex);
    }
 
    
}
//根据下标设置imgView的image
-(void)setTetxLabel:(UILabel *)label withSubscript:(NSInteger)subcript{
//    MUModel *model = self.tittleAray[subcript];
//    label.text = model.Title;
}
// 用户将要拖拽时将定时器关闭
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 闭定时器
    [self invalidateTimer];
}

// 用户结束拖拽时将定时器开启(在打开自动轮播的前提下)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self addTimer];
    }
}
#pragma mark - 系统方法
-(void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
-(void)didMoveToSuperview{
    
    [self invalidateTimer];
    [self addTimer];
}
#pragma mark - 手势点击事件
-(void)handleTapActionInImageView:(UITapGestureRecognizer *)tap {
    
    if (self.clickedTextBlock) {
        // 如果_nextPhotoIndex == 0,那么中间那张图片一定是数组中最后一张，我们要传的就是中间那张图片在数组中的下标
        if (_nextPhotoIndex == 0) {
            self.clickedTextBlock(_kImageCount-1);
        }else{
            self.clickedTextBlock(_nextPhotoIndex-1);
        }
    }
}

-(void)dealloc {
    //    NSLog(@"dealloc");
    _scrollView.delegate = nil;
}

// 开启定时器
- (void)addTimer {
    // 开启之前一定要先将上一次开启的定时器关闭,否则会跟新的定时器重叠
    [self invalidateTimer];
    if (_autoScroll) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(timerAction) userInfo:self repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

// 关闭定时器
- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}
#pragma maek - Private Method

// timer事件
-(void)timerAction{
    // 定时器每次触发都让当前图片为轮播图的第三张ImageView的image
    [_scrollView setContentOffset:CGPointMake(0, kHeight * 2) animated:YES];
    
}
- (void)setTittleAray:(NSArray<NSString *> *)tittleAray{
    if (tittleAray.count == 0) {
        return;
    }
    if (![_tittleAray isEqualToArray:tittleAray]) {
        //获取数组个数
        _tittleAray = tittleAray;
        self.kImageCount = _tittleAray.count;
        [self configure];
    }
}

// 是否自动轮播
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        // 开启新的定时器
        [self addTimer];
    } else {
        // 关闭定时器
        [self invalidateTimer];
    }
}
// 重写duration的set方法,用户可以在外界设置轮播图间隔时间
-(void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    if (duration < 1.0f) { // 如果外界不小心设置的时间小于1秒，强制默认2秒。
        duration = 2.0f;
    }
    [self addTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(kWidth , kHeight*3);
    // 这里如果采用动画效果设置偏移量将不起任何作用
    self.scrollView.contentOffset = CGPointMake(0, kHeight);
    
    self.nextLabel.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.currentLabel.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    self.nextLabel.frame = CGRectMake(0,kHeight*2, kWidth , kHeight);
    
    
}

@end
