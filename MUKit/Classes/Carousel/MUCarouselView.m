//
//  MUCarouselView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/9.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUCarouselView.h"

#define  kWidth  self.bounds.size.width
#define  kHeight self.bounds.size.height
#define kPageControlMargin 10.0f


typedef NS_ENUM(NSInteger, MUCarouseImagesDataStyle){
    MUCarouseImagesDataInLocal,// 本地图片标记
    MUCarouseImagesDataInURL,   // URL图片标记
    MUCarouseImagesDataIntitle   // 文字轮播标记
};
@interface MUCarouselView()<UIScrollViewDelegate>
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIPageControl *pageControl;
// 图片来源(本地或URL)
@property(nonatomic) MUCarouseImagesDataStyle carouseImagesStyle;
// 前一个视图,当前视图,下一个视图
@property(strong, nonatomic) UIImageView *lastImgView;
@property(strong, nonatomic) UIImageView *currentImgView;
@property(strong, nonatomic) UIImageView *nextImgView;
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


@property(strong, nonatomic) UILabel *lastLabel;
@property(strong, nonatomic) UILabel *currentLabel;
@property(strong, nonatomic) UILabel *nextLabel;
@end

@implementation MUCarouselView

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
    _pageColor = [UIColor grayColor];
    _currentPageColor = [UIColor whiteColor];
    _currentIndex = 0;
    _scrollDirection   = MUCarouselScrollDirectionHorizontal;
    
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

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = self.pageColor;
        _pageControl.currentPageIndicatorTintColor = self.currentPageColor;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(UIImageView *)lastImgView{
    if (_lastImgView == nil) {
        _lastImgView = [[UIImageView alloc] init];
        //        _lastImgView.backgroundColor = [UIColor grayColor];
    }
    return _lastImgView;
}

-(UIImageView *)currentImgView{
    if (_currentImgView == nil) {
        _currentImgView = [[UIImageView alloc] init];
        //        _currentImgView.backgroundColor = [UIColor grayColor];
        // 给当前图片添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapActionInImageView:)];
        [_currentImgView addGestureRecognizer:tap];
        
        UITapGestureRecognizer * doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired =2;
        doubleTapGesture.numberOfTouchesRequired =1;
        [_currentImgView addGestureRecognizer:doubleTapGesture];
        
        _currentImgView.userInteractionEnabled = YES;
    }
    return _currentImgView;
}

-(UIImageView *)nextImgView{
    if (_nextImgView == nil) {
        _nextImgView = [[UIImageView alloc] init];
        //        _nextImgView.backgroundColor = [UIColor grayColor];
    }
    return _nextImgView;
}

-(UILabel *)lastLabel{
    if (!_lastLabel) {
        _lastLabel = [UILabel new];
        _lastLabel.textColor = _titleColor?:[UIColor blackColor];
        _lastLabel.font = [UIFont systemFontOfSize:_titleFont>0?:17.];
        _lastLabel.textAlignment = _textAlignment>0?:NSTextAlignmentLeft;
        _lastLabel.numberOfLines = _numberOfLines>0?:0;
        //        _lastLabel.backgroundColor = _backgroundColor?:[UIColor whiteColor];
    }
    return _lastLabel;
}

-(UILabel *)currentLabel{
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.textColor = _titleColor?:[UIColor blackColor];
        _currentLabel.font = [UIFont systemFontOfSize:_titleFont>0?:17.];
        _currentLabel.textAlignment = _textAlignment>0?:NSTextAlignmentLeft;
        _currentLabel.numberOfLines = _numberOfLines>0?:0;
        //        _currentLabel.backgroundColor = _backgroundColor?:[UIColor whiteColor];
    }
    return _currentLabel;
}
-(UILabel *)nextLabel{
    
    if (!_nextLabel) {
        _nextLabel = [UILabel new];
        _nextLabel.textColor = _titleColor?:[UIColor blackColor];
        _nextLabel.font = [UIFont systemFontOfSize:_titleFont>0?:17.];
        _nextLabel.textAlignment = _textAlignment>0?:NSTextAlignmentLeft;
        _nextLabel.numberOfLines = _numberOfLines>0?:0;
        //        _nextLabel.backgroundColor = _backgroundColor?:[UIColor whiteColor];
    }
    return _nextLabel;
}
#pragma mark -configured
-(void)configure{
    
    self.scrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
    [self addSubview:self.scrollView];
    // 添加最初的三张imageView
    [self.scrollView addSubview:self.lastImgView];
    [self.scrollView addSubview:self.currentImgView];
    [self.scrollView addSubview:self.nextImgView];
    
    if (self.carouseImagesStyle == MUCarouseImagesDataIntitle&&self.scrollDirection == MUCarouselScrollDirectionVertical) {
        [self.lastImgView addSubview:self.lastLabel];
        [self.currentImgView addSubview:self.currentLabel];
        [self.nextImgView addSubview:self.nextLabel];
    }
    [self addSubview:self.pageControl];
    
    if (self.currentIndex > _kImageCount - 1 || self.currentIndex == 0) {
        // 将上一张图片设置为数组中最后一张图片
        [self setImageView:_lastImgView label:_lastLabel withSubscript:(_kImageCount -1)];
        // 将当前图片设置为数组中第一张图片
        [self setImageView:_currentImgView label:_currentLabel withSubscript:0];
        // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
        [self setImageView:_nextImgView label:_nextLabel  withSubscript:_kImageCount == 1 ? 0 : 1];
        self.nextPhotoIndex = 1;
        self.lastPhotoIndex = _kImageCount - 1;
    }else if(self.currentIndex == _kImageCount - 1){
        
        // 将上一张图片设置为数组中最后一张图片
        [self setImageView:_lastImgView label:_lastLabel withSubscript:_currentIndex - 1];
        // 将当前图片设置为数组中第一张图片
        [self setImageView:_currentImgView label:_currentLabel withSubscript:_currentIndex];
        // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
        [self setImageView:_nextImgView label:_nextLabel  withSubscript:0];
        
        self.nextPhotoIndex = 0;
        self.lastPhotoIndex = _currentIndex - 1;
    }else{
        
        // 将上一张图片设置为数组中最后一张图片
        [self setImageView:_lastImgView label:_lastLabel withSubscript:_currentIndex - 1];
        // 将当前图片设置为数组中第一张图片
        [self setImageView:_currentImgView label:_currentLabel withSubscript:_currentIndex];
        // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
        [self setImageView:_nextImgView label:_nextLabel  withSubscript:_currentIndex + 1];
        self.nextPhotoIndex = _currentIndex + 1;
        self.lastPhotoIndex = _currentIndex - 1;
    }
    if (self.scrollDirection == MUCarouselScrollDirectionHorizontal) {
        
        _scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
        //显示中间的图片
        _scrollView.contentOffset = CGPointMake(kWidth, 0);
    }else{
        _scrollView.contentSize = CGSizeMake(kWidth, kHeight * 3);
        //显示中间的图片
        _scrollView.contentOffset = CGPointMake(0, kHeight);
    }
    
    //    self.showPageControl = YES;
    _pageControl.numberOfPages = self.kImageCount;
    _pageControl.currentPage = 0;
    
    
    [self layoutIfNeeded];
}
// 设置pageControl的小圆点图片
- (void)setPageImage:(UIImage *)image currentPageImage:(UIImage *)currentImage {
    if (!image || !currentImage) return;
    self.pageImageSize = image.size;
    [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [self.pageControl setValue:image forKey:@"_pageImage"];
}
#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 到第一张图片时   (一上来，当前图片的x值是kWidth)
    if ((ceil(scrollView.contentOffset.x) <= 0&&self.scrollDirection == MUCarouselScrollDirectionHorizontal) || (ceil(scrollView.contentOffset.y) <= 0&&self.scrollDirection == MUCarouselScrollDirectionVertical)) {  // 右滑||上滑
        _nextImgView.image = _currentImgView.image;
        _currentImgView.image = _lastImgView.image;
        if (self.carouseImagesStyle == MUCarouseImagesDataIntitle) {
            _nextLabel.text = _currentLabel.text;
            _currentLabel.text = _lastLabel.text;
        }
        // 将轮播图的偏移量设回中间位置
        //        [scrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
        if (self.scrollDirection == MUCarouselScrollDirectionHorizontal) {
            
            scrollView.contentOffset = CGPointMake(kWidth, 0);
        }else{
            scrollView.contentOffset = CGPointMake(0, kHeight);
        }
        _lastImgView.image = nil;
        _lastLabel.text = @"";
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
        if (self.doneUpdateCurrentIndex) {
            self.doneUpdateCurrentIndex(_nextPhotoIndex==0?_kImageCount:_nextPhotoIndex);
        }
        if (self.doubleTapedForLargeImage) {
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:.25 animations:^{
                
                weakSelf.scrollView.transform = CGAffineTransformIdentity;
            }];
        }
        [self setImageView:_lastImgView label:_lastLabel withSubscript:_lastPhotoIndex];
    }
    // 到最后一张图片时（最后一张就是轮播图的第三张）
    //    NSLog(@"kWidth ===== %.f========%.f======%.f======%ld",ceil(scrollView.contentOffset.x),kWidth,scrollView.contentSize.width,self.scrollDirection);
    if (((ceil(scrollView.contentOffset.x)  >= ceil(kWidth)*2.- 2)&&self.scrollDirection == MUCarouselScrollDirectionHorizontal)||(ceil(scrollView.contentOffset.y)  >= kHeight*2&&self.scrollDirection == MUCarouselScrollDirectionVertical)) {  // 左滑||下滑
        _lastImgView.image = _currentImgView.image;
        _currentImgView.image = _nextImgView.image;
        
        if (self.carouseImagesStyle == MUCarouseImagesDataIntitle) {
            _lastLabel.text = _currentLabel.text;
            _currentLabel.text = _nextLabel.text;
        }
        // 将轮播图的偏移量设回中间位置
        //        [scrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
        if (self.scrollDirection == MUCarouselScrollDirectionHorizontal) {
            
            scrollView.contentOffset = CGPointMake(kWidth, 0);
        }else{
            scrollView.contentOffset = CGPointMake(0, kHeight);
        }
        _nextImgView.image = nil;
        _nextLabel.text = @"";
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
        if (self.doneUpdateCurrentIndex) {
            self.doneUpdateCurrentIndex(_nextPhotoIndex==0?_kImageCount:_nextPhotoIndex);
        }
        if (self.doubleTapedForLargeImage) {
            __weak typeof(self)weakSelf = self;
            [UIView animateWithDuration:.25 animations:^{
                
                weakSelf.scrollView.transform = CGAffineTransformIdentity;
            }];
        }
        [self setImageView:_nextImgView label:_nextLabel withSubscript:_nextPhotoIndex];
    }
    
    if (_nextPhotoIndex - 1 < 0) {
        self.pageControl.currentPage = _kImageCount - 1;
    } else {
        self.pageControl.currentPage = _nextPhotoIndex - 1;
    }
    
    
}
//根据下标设置imgView的image
-(void)setImageView:(UIImageView *)imgView label:(UILabel *)label withSubscript:(NSInteger)subcript{
    switch (self.carouseImagesStyle) {
        case MUCarouseImagesDataInLocal:
            imgView.image = [UIImage imageNamed:self.localImages[subcript]];
            break;
        case MUCarouseImagesDataInURL:
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.urlImages[subcript]] placeholderImage:self.placeholderImage];
            break;
        case MUCarouseImagesDataIntitle:
            label.text = self.titlesArray[subcript];
            break;
        default:
            break;
    }
}
//根据下标设置label的text
//-(void)setLabel:(UILabel *)label withSubscript:(NSInteger)subcript{
//
//    label.text = self.titlesArray[subcript];
//}
// 用户将要拖拽时将定时器关闭
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 关闭定时器
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
    if (self.doubleTapedForLargeImage) {
        
         __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:.25 animations:^{
            
            weakSelf.scrollView.transform = CGAffineTransformIdentity;
        }];
    }
    if (self.clickedImageBlock) {
        // 如果_nextPhotoIndex == 0,那么中间那张图片一定是数组中最后一张，我们要传的就是中间那张图片在数组中的下标
        if (_nextPhotoIndex == 0) {
            self.clickedImageBlock(_kImageCount-1);
        }else{
            self.clickedImageBlock(_nextPhotoIndex-1);
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
    if (self.scrollDirection == MUCarouselScrollDirectionHorizontal) {
        [_scrollView setContentOffset:CGPointMake(kWidth*2, 0) animated:YES];
    }else{
        [_scrollView setContentOffset:CGPointMake(0, kHeight * 2) animated:YES];
    }
}

#pragma mark -pramters
-(void)setLocalImages:(NSArray<NSString *> *)localImages{
    if (localImages.count == 0) return;
    if (![_localImages isEqualToArray:localImages]) {
        _localImages = nil;
        _localImages = [localImages copy];
        //标记图片来源
        self.carouseImagesStyle = MUCarouseImagesDataInLocal;
        //获取数组个数
        self.kImageCount = _localImages.count;
        [self configure];
        
        //        [self addTimer];
    }
}
// 网络图片
- (void)setUrlImages:(NSArray<NSString *> *)urlImages {
    if (urlImages.count == 0) return;
    if (![_urlImages isEqualToArray:urlImages]) {
        _urlImages = nil;
        _urlImages = [urlImages copy];
        //标记图片来源
        self.carouseImagesStyle = MUCarouseImagesDataInURL;
        self.kImageCount = _urlImages.count;
        [self configure];
        
        //        [self addTimer];
    }
}

// 文字
-(void)setTitlesArray:(NSArray<NSString *> *)titlesArray{
    if (titlesArray.count == 0) return;
    if (![_titlesArray isEqualToArray:titlesArray]) {
        _titlesArray = nil;
        _titlesArray = [titlesArray copy];
        self.scrollDirection = MUCarouselScrollDirectionVertical;
        self.carouseImagesStyle = MUCarouseImagesDataIntitle;
        self.kImageCount = _titlesArray.count;
        [self configure];
        self.showPageControl = NO;
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
// 设置其他小圆点的颜色
- (void)setPageColor:(UIColor *)pageColor {
    _pageColor = pageColor;
    _pageControl.pageIndicatorTintColor = pageColor;
}

// 设置当前小圆点的颜色
- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    _pageControl.currentPageIndicatorTintColor = currentPageColor;
}

// 是否显示pageControl
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    if (!showPageControl) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
        return;
    }
    self.pageControl.hidden = showPageControl;
}

// 设置pageControl的位置
- (void)setPageControlPosition:(MUPageContolPosition)pageControlPosition {
    _pageControlPosition = pageControlPosition;
    
    if (_pageControl.hidden) return;
    
    CGSize size;
    if (!_pageImageSize.width) {// 没有设置图片，系统原有样式
        size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        size.height = 8;
    } else { // 设置图片了
        size = CGSizeMake(_pageImageSize.width * (_pageControl.numberOfPages * 2 - 1), _pageImageSize.height);
    }
    
    _pageControl.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat centerY = kHeight - size.height * 0.5 - kPageControlMargin;
    CGFloat pointY = kHeight - size.height - kPageControlMargin;
    
    switch (pageControlPosition) {
        case MUPageContolPositionBottomCenter:
            // 底部中间
            _pageControl.center = CGPointMake(kWidth * 0.5, centerY);
            break;
        case MUPageContolPositionBottomRight:
            // 底部右边
            _pageControl.frame = CGRectMake(kWidth - size.width - kPageControlMargin, pointY, size.width, size.height);
            break;
        case MUPageContolPositionBottomLeft:
            // 底部左边
            _pageControl.frame = CGRectMake(kPageControlMargin, pointY, size.width, size.height);
            break;
        default:
            break;
    }
}
// 设置imageView的内容模式
- (void)setImageMode:(MUCarouselViewImageMode)imageMode {
    _imageMode = imageMode;
    
    switch (imageMode) {
        case MUCarouselViewImageModeScaleToFill:
            _nextImgView.contentMode = _currentImgView.contentMode = _lastImgView.contentMode = UIViewContentModeScaleToFill;
            break;
        case MUCarouselViewImageModeScaleAspectFit:
            _nextImgView.contentMode = _currentImgView.contentMode = _lastImgView.contentMode = UIViewContentModeScaleAspectFit;
            break;
        case MUCarouselViewImageModeScaleAspectFill:
            _nextImgView.contentMode = _currentImgView.contentMode = _lastImgView.contentMode = UIViewContentModeScaleAspectFill;
            break;
        case MUCarouselViewImageModeCenter:
            _nextImgView.contentMode = _currentImgView.contentMode = _lastImgView.contentMode = UIViewContentModeCenter;
            break;
        default:
            break;
    }
}
-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    if (self.carouseImagesStyle == MUCarouseImagesDataIntitle) {
        _textAlignment = textAlignment;
        self.nextLabel.textAlignment =self.currentLabel.textAlignment=self.lastLabel.textAlignment = textAlignment;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    self.scrollView.frame = self.bounds;
    // 重新设置contentOffset和contentSize对于轮播图下拉放大以及里面的图片跟随放大起着关键作用，因为scrollView放大了，如果不手动设置contentOffset和contentSize，则会导致scrollView的容量不够大，从而导致图片越出scrollview边界的问题
    if (self.scrollDirection == MUCarouselScrollDirectionHorizontal) {
        
        self.scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
        // 这里如果采用动画效果设置偏移量将不起任何作用
        self.scrollView.contentOffset = CGPointMake(kWidth, 0);
        
        self.lastImgView.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.currentImgView.frame = CGRectMake(kWidth, 0, kWidth, kHeight);
        self.nextImgView.frame = CGRectMake(kWidth * 2, 0, kWidth, kHeight);
        
        
    }else{
        self.scrollView.contentSize = CGSizeMake(kWidth , kHeight * 3);
        // 这里如果采用动画效果设置偏移量将不起任何作用
        self.scrollView.contentOffset = CGPointMake(0, kHeight);
        
        self.lastImgView.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.currentImgView.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.nextImgView.frame = CGRectMake(0 , 2*kHeight, kWidth, kHeight);
        
        if (self.carouseImagesStyle == MUCarouseImagesDataIntitle) {
            
            self.lastLabel.frame = self.currentLabel.frame = self.nextLabel.frame = CGRectMake(0, 0, kWidth, kHeight);
            
        }
    }
    
    // 等号左边是掉setter方法，右边调用getter方法
    if (self.showPageControl) {
        self.pageControl.hidden = NO;
        self.pageControlPosition = self.pageControlPosition;
    }else{
        self.pageControl.hidden = YES;
    }
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap{
    
    if (self.doubleTapedForLargeImage) {
        __weak typeof(self)weakSelf = self;
        [UIView animateWithDuration:.25 animations:^{
            
            CGFloat scaleWidth = [UIScreen mainScreen].bounds.size.width/kWidth;
            CGFloat scaleHeight = [UIScreen mainScreen].bounds.size.height/kHeight;
            weakSelf.scrollView.transform = CGAffineTransformMakeScale(scaleWidth, scaleHeight);
        }];
    }
    
}
@end
