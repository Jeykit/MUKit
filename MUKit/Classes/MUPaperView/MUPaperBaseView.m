//
//  MUPaperBaseView.m
//  AFNetworking
//
//  Created by Jekity on 2017/12/8.
//

#import "MUPaperBaseView.h"

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface MUPaperBaseView()<UIScrollViewDelegate>

@property(nonatomic, assign)CGRect contentRect;

@property(nonatomic, strong)NSMutableArray *bottomLineWidthArray;
@property(nonatomic, strong)NSMutableArray *topTabArray;
@property(nonatomic, strong)NSMutableArray *buttonArray;
@property(nonatomic, strong)UIView *lineBottom;
@property(nonatomic, strong)UIView *topTabBottomLine;
@property(nonatomic, strong)UIView *muMaskView;
@property(nonatomic, assign)CGFloat More5LineWidth;
@property(nonatomic, weak)UIButton *currentSelectedButton;
@property (assign, nonatomic) CGFloat bottomLinePer; /**< 下划线占比 **/
@property(nonatomic, assign)BOOL isClickedButton;
@property(nonatomic, assign)NSUInteger previousNumber;

@property(nonatomic, weak)UIButton *clickedButton;
@property(nonatomic, assign)id lastObject;
@property(nonatomic, assign)id currentObject;
@property(nonatomic, strong)NSMutableArray *loadedArray;

@property (nonatomic,weak) UIViewController *weakViewController;

@end

#define MaxNums  12 //Max limit number,recommand below 10.
@implementation MUPaperBaseView{
    BOOL viewAlloc[MaxNums];
}

-(instancetype)initWithFrame:(CGRect)frame WithTopTabType:(NSInteger)type{
    if (self = [super initWithFrame:frame]) {
        _contentRect = frame;
        _tabType     = type;
        _More5LineWidth = CGRectGetWidth(self.contentRect) / 5.;
        _tabbarHeight = 30.;
        _blockHeight  = 30.;
        _loadedArray  = [NSMutableArray array];
        _slideEnabled = YES;
       [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - lazy loading
-(UIScrollView *)contentScollView{
    if (!_contentScollView) {
        
        _contentScollView = [UIScrollView new];
        _contentScollView.backgroundColor = [UIColor redColor];
        _contentScollView.delegate = self;
        _contentScollView.tag = 1314;
//        _contentScollView.backgroundColor = UIColorFromRGB(0xfafafa);
        _contentScollView.backgroundColor = [UIColor clearColor];
        _contentScollView.pagingEnabled = YES;
        _contentScollView.showsHorizontalScrollIndicator = NO;
        _contentScollView.alwaysBounceHorizontal = YES;
        _contentScollView.scrollsToTop = NO;
        _contentScollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _contentScollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _contentScollView;
}
-(UIScrollView *)tabbarScollView{
    if (!_tabbarScollView) {
        _tabbarScollView = [UIScrollView new];
        _tabbarScollView.delegate = self;
        _tabbarScollView.backgroundColor = [UIColor whiteColor];
        _tabbarScollView.tag = 1413;
        _tabbarScollView.scrollEnabled = YES;
        _tabbarScollView.alwaysBounceHorizontal = YES;
        _tabbarScollView.showsHorizontalScrollIndicator = NO;
        _tabbarScollView.showsVerticalScrollIndicator = NO;
        _tabbarScollView.bounces = NO;
        _tabbarScollView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tabbarScollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tabbarScollView addSubview:self.lineBottom];
        [_tabbarScollView addSubview:self.topTabBottomLine];
    }
    return _tabbarScollView;
}

-(UIView *)lineBottom{

    if (!_lineBottom) {
        _lineBottom = [UIView new];
//        _lineBottom.backgroundColor = UIColorFromRGB(0xff6262);
        _lineBottom.backgroundColor = [UIColor colorWithRed:242./255. green:242./255. blue:242./255. alpha:1.];
        _lineBottom.clipsToBounds = YES;
        _lineBottom.userInteractionEnabled = YES;
    }
    return _lineBottom;
}

-(UIView *)topTabBottomLine{
    if (!_topTabBottomLine) {
        _topTabBottomLine = [UIView new];
        _topTabBottomLine.backgroundColor = UIColorFromRGB(0xff6262);
//        _topTabBottomLine.backgroundColor = [UIColor orangeColor];
        _topTabBottomLine.clipsToBounds = YES;
        _topTabBottomLine.userInteractionEnabled = YES;
        
    }
    return _topTabBottomLine;
}
-(void)setDefaultPage:(NSInteger)defaultPage{
    _defaultPage = defaultPage;
    _previousNumber = defaultPage;
    self.currentPageNumber = defaultPage;
}
- (void)baseViewLoadData {
    self.tabbarScollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentRect), _tabbarHeight);
    self.contentScollView.frame = CGRectMake(0, _tabbarHeight, CGRectGetWidth(self.contentRect), CGRectGetHeight(self.contentRect) - _tabbarHeight - CGRectGetMinY(self.contentRect));
     self.contentScollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentRect) * _titleArray.count,CGRectGetHeight(self.contentScollView.frame));
    [self addSubview:self.tabbarScollView];
    [self addSubview:self.contentScollView];
    
    [self updateTopTabUI];
    [self updateScrollViewUI];
    [self initUI];
}
#pragma mark -setter
-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self baseViewLoadData];
}
-(void)setUnderlineOrBlockColor:(UIColor *)underlineOrBlockColor{
    _underlineOrBlockColor = underlineOrBlockColor;
    self.topTabBottomLine.backgroundColor = underlineOrBlockColor;
}
-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    if (_buttonArray) {
        for (UIButton *button in _buttonArray) {
            [button setTitleColor:normalColor forState:UIControlStateNormal];
        }
    }
}
-(void)setHighlightedColor:(UIColor *)highlightedColor{
    _highlightedColor = highlightedColor;
    if (self.currentSelectedButton) {
        [self.currentSelectedButton setTitleColor:highlightedColor forState:UIControlStateNormal];
    }
}
- (void)setSeparationLineHidden:(BOOL)separationLineHidden{
    _separationLineHidden = separationLineHidden;
    _lineBottom.hidden = separationLineHidden;
    
}
-(void)setTabbarHeight:(CGFloat)tabbarHeight{
    _tabbarHeight = tabbarHeight;
    CGRect rect = self.tabbarScollView.frame;
    rect.size.height = tabbarHeight;
    self.tabbarScollView.frame = rect;
    CGRect rect1 = self.contentScollView.frame;
    rect1.size.height = CGRectGetHeight(self.contentRect) - tabbarHeight - CGRectGetMinY(self.contentRect);
    rect1.origin.y = tabbarHeight;
    self.contentScollView.frame = rect1;

    CGRect rect2 = self.lineBottom.frame;
    rect2.origin.y = tabbarHeight - 1.;
    self.lineBottom.frame = rect2;

     CGRect rect3 = self.topTabBottomLine.frame;
     rect3.origin.y = tabbarHeight - 1.;
     self.topTabBottomLine.frame = rect2;

    if (_buttonArray) {
        for (UIButton *button in _buttonArray) {
             CGRect rect4 = button.frame;
            rect4.size.height = tabbarHeight;
            button.frame = rect4;
        }
    }
}
-(void)setCornerRadiusRatio:(CGFloat)cornerRadiusRatio{
    _cornerRadiusRatio = cornerRadiusRatio;
}
-(void)setBlockHeight:(CGFloat)blockHeight{
    _blockHeight = blockHeight;
    if (self.tabType == 1) {
        CGRect rect =  _topTabBottomLine.frame;
        rect.size.height = blockHeight;
        _topTabBottomLine.frame = rect;
    }
}
- (void)updateScrollViewUI {
    _contentScollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentRect) * _titleArray.count, 0);
    if (!_slideEnabled) {
        _contentScollView.scrollEnabled = NO;
    }
}
-(void)setObjectArray:(NSArray *)objectArray{
    _objectArray = objectArray;
}
#pragma mark -method
- (void)updateTopTabUI {
//    CGFloat yourCount = 1.0 / _titleArray.count;
    CGFloat additionCount = 0;
    if (_titleArray.count > 5) {
        additionCount = (_titleArray.count - 5.0) / 5.0;
    }
    _tabbarScollView.contentSize = CGSizeMake((1 + additionCount) * CGRectGetWidth(self.contentRect), _tabbarHeight);
  
    if (_defaultPage > 2 && _defaultPage < _titleArray.count) {
        if (_titleArray.count >= 5) {
            _tabbarScollView.contentOffset = CGPointMake(1.0 / 5.0 * (CGRectGetWidth(self.contentRect)-8.) * (_defaultPage - 2), 0);
        }else {
            _tabbarScollView.contentOffset = CGPointMake(1.0 / _titleArray.count * CGRectGetWidth(self.contentRect) * (_defaultPage - 2), 0);
        }
    }
    _buttonArray = [NSMutableArray array];
    _bottomLineWidthArray = [NSMutableArray array];
    _topTabArray = [NSMutableArray array];
    BOOL isCustomView = NO;
    BOOL isString     = NO;
    if (_titleArray.count > 0) {
        isCustomView = [_titleArray[0] isKindOfClass:[UIView class]];
       
    }
    
    if (!isCustomView) {
         isString     = [_titleArray[0] isKindOfClass:[NSString class]];
    }
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        if (_titleArray.count > 5) {
            button.frame = CGRectMake(_More5LineWidth * i, 0, _More5LineWidth, _tabbarHeight);
        }else {
            button.frame = CGRectMake(CGRectGetWidth(self.contentRect) / _titleArray.count * i, 0, CGRectGetWidth(self.contentRect) / _titleArray.count, _tabbarHeight);
        }
        
        if (isCustomView) {
            UIView *customTopView = _titleArray[i];
            customTopView.frame = button.bounds;
            customTopView.userInteractionEnabled = NO;
            customTopView.exclusiveTouch = NO;
            [_topTabArray addObject:customTopView];
            [button addSubview:customTopView];
//            customTopView.center = button.center;
        }else{
            if (isString) {
              
                CGFloat tempidth = [_titleArray[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_titlesFont]}].width;
                if (tempidth > CGRectGetWidth(button.frame)) {
                      [_bottomLineWidthArray addObject:[NSString stringWithFormat:@"%.2f",CGRectGetWidth(button.frame)]];
                }else{
                      [_bottomLineWidthArray addObject:[NSString stringWithFormat:@"%f",tempidth]];
                }
                [button setTitle:_titleArray[i] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines = 0;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
//                button.titleLabel.adjustsFontSizeToFitWidth = _fontSizeAutoFit;
            }else{
             #ifdef DEBUG
                NSLog(@"只接受UIView、NSString类型");
             #endif
            }
        }
        if (i == 0) {//当前选中的按钮
            self.currentSelectedButton = button;
            [button setTitleColor:self.highlightedColor?:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:self.normalColor?:[UIColor blackColor] forState:UIControlStateNormal];
        }

        button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
        [_tabbarScollView addSubview:button];
        [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonArray addObject:button];
    }
    _lineBottom.frame = CGRectMake(0, _tabbarHeight - 1, (1 + additionCount) * [[UIScreen mainScreen] bounds].size.width, _bottomLineHeight);
    if (_titleArray.count <= 5) {
         _topTabBottomLine.frame = CGRectMake(0, _tabbarHeight - _bottomLineHeight, CGRectGetWidth(self.contentRect)/_titleArray.count , _bottomLineHeight);
    }
   
    if (_tabType == 1) {
        _muMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (1 + additionCount) * CGRectGetWidth(self.contentRect), _blockHeight)];
        _muMaskView.backgroundColor = [UIColor clearColor];
        [_topTabBottomLine addSubview:_muMaskView];
    }
}
#pragma mark - Button event Method
- (void)touchAction:(UIButton *)button {
    button.userInteractionEnabled = NO;
    self.clickedButton = button;
    self.isClickedButton = YES;
//    if (self.previousNumber != self.currentSelectedButton.tag) {
    
        self.previousNumber = self.currentSelectedButton.tag;
        [_contentScollView setContentOffset:CGPointMake(CGRectGetWidth(self.contentRect) * button.tag, 0) animated:YES];
        self.currentPageNumber = (CGRectGetWidth(self.contentRect) * button.tag + CGRectGetWidth(self.contentRect) / 2) / CGRectGetWidth(self.contentRect);
//    }
}

- (void)initUI {
    CGFloat yourCount = 1.0 / _titleArray.count;
    CGFloat additionCount = 0;
    if (_titleArray.count > 5) {
        additionCount = (_titleArray.count - 5.0) / 5.0;
        yourCount = 1.0 / 5.0;
    }
    _bottomLinePer = 1.;
    if (_autoFitTitleLine) {
        _bottomLinePer = [_bottomLineWidthArray[0] floatValue] / (CGRectGetWidth(self.contentRect) * yourCount)+.2;
    }
    CGFloat lineBottomDis = yourCount * CGRectGetWidth(self.contentRect) * (1 -_bottomLinePer)/ 2;
    NSInteger defaultPage = (_defaultPage > 0 && _defaultPage < _titleArray.count)?_defaultPage:0;
    switch (_tabType) {
        case 0:
            if (_bottomLineHeight >= 3) {
             
                _topTabBottomLine.frame = CGRectMake(lineBottomDis, _tabbarHeight - 3, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, 3);
            }else {
            
                _topTabBottomLine.frame = CGRectMake(lineBottomDis + CGRectGetWidth(self.contentRect) * yourCount * defaultPage, _tabbarHeight - _bottomLineHeight, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, _bottomLineHeight);
            }
            break;
        case 1: {
            
            if (_autoFitTitleLine) {
                
                _topTabBottomLine.frame = CGRectMake(lineBottomDis +  CGRectGetWidth(self.contentRect) * yourCount * defaultPage, (_tabbarHeight - _blockHeight) / 2.0, yourCount *  CGRectGetWidth(self.contentRect) * _bottomLinePer, _blockHeight);
                if (_cornerRadiusRatio > 0) {
                    _topTabBottomLine.layer.cornerRadius =  _cornerRadiusRatio;
                    _topTabBottomLine.layer.masksToBounds = YES;
                }
            }else{
                _topTabBottomLine.frame = CGRectMake(lineBottomDis +  CGRectGetWidth(self.contentRect) * yourCount * defaultPage , (_tabbarHeight - _blockHeight) / 2.0, yourCount *  CGRectGetWidth(self.contentRect) * _bottomLinePer, _blockHeight);
                if (_cornerRadiusRatio > 0) {
                    _topTabBottomLine.layer.cornerRadius =  _cornerRadiusRatio;
                    _topTabBottomLine.layer.masksToBounds = YES;
                }
            }
        }
            break;
        default:
            break;
    }
  
}

#pragma mark -scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1314) {
      
        NSInteger yourPage = (NSInteger)((scrollView.contentOffset.x + CGRectGetWidth(self.contentRect) / 2) / CGRectGetWidth(self.contentRect));
        
        CGFloat yourCount = 1.0 / _titleArray.count;
        if (_titleArray.count > 5) {
            yourCount = 1.0 / 5.0;
        }
        _bottomLinePer = 1;
        if (_autoFitTitleLine) {
            _bottomLinePer = [_bottomLineWidthArray[yourPage] floatValue] / (CGRectGetWidth(self.contentRect) * yourCount)+.2;
        }
        CGFloat lineBottomDis = yourCount * CGRectGetWidth(self.contentRect) * (1 -_bottomLinePer) / 2;
        if (_tabType == 1) {
            CGPoint maskCenter = _muMaskView.center;
            if (_titleArray.count >= 5) {
                maskCenter.x = _muMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * 0.2);
            }else {
                maskCenter.x = _muMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * yourCount);
            }
            _muMaskView.center = maskCenter;
        }
        if (_titleArray.count > 5) {
            switch (_tabType) {
                case 0:
                    if (_bottomLineHeight >= 3) {
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, _tabbarHeight - 3, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, 3);
                        break;
                    }
                    _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, _tabbarHeight - _bottomLineHeight, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, _bottomLineHeight);
                    break;
                case 1:
                    if (_autoFitTitleLine) {
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, (_tabbarHeight - _blockHeight) / 2.0, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, _blockHeight);
                    }else{
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, (_tabbarHeight - _blockHeight) / 2.0, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, _blockHeight);
                    }
                    break;
                default:
                    break;
            }
        }else {
            switch (_tabType) {
                case 0:
                    if (_bottomLineHeight >= 3) {
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / _titleArray.count + lineBottomDis, _tabbarHeight - 3, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, 3);
                    }else {
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / _titleArray.count + lineBottomDis, _tabbarHeight - _bottomLineHeight, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, _bottomLineHeight);
                    }
                    break;
                case 1:
                    if (_autoFitTitleLine) {
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis, (_tabbarHeight - _blockHeight) / 2.0, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer , _blockHeight);
                    }else{
                        _topTabBottomLine.frame = CGRectMake(scrollView.contentOffset.x / 5 + lineBottomDis-2, (_tabbarHeight - _blockHeight) / 2.0, yourCount * CGRectGetWidth(self.contentRect) * _bottomLinePer, _blockHeight);
                    }
                  
                    break;
                default:
                    break;
            }
        }
        UIButton *changeButton = _buttonArray[yourPage];
        if (self.currentSelectedButton != changeButton) {
            
            NSUInteger previous = self.currentSelectedButton.tag;
            [changeButton setTitleColor:_highlightedColor?:[UIColor grayColor] forState:UIControlStateNormal];
            [self.currentSelectedButton setTitleColor:_normalColor?:[UIColor blackColor] forState:UIControlStateNormal];
            self.currentSelectedButton.transform = CGAffineTransformIdentity;
            self.currentSelectedButton.userInteractionEnabled = YES;
            self.currentSelectedButton = changeButton;
            
            if (self.isClickedButton) {
                if (self.clickedButton == changeButton) {
                    if (self.changedBlock) {
                        self.changedBlock(self.previousNumber, changeButton.tag);
                    }
                    self.isClickedButton = NO;
                }
            }else{
                self.previousNumber = previous;
                if (self.changedBlock) {
                    self.changedBlock(self.previousNumber, changeButton.tag);
                }
            }
            if (_titleScale > 0) {
//                weakify(self)
                __weak typeof(self)weakSelf = self;
                [UIView animateWithDuration:0.3 animations:^{
//                    normalize(self)
                    changeButton.transform = CGAffineTransformMakeScale(weakSelf.titleScale, weakSelf.titleScale);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
                }];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 1314) {
        self.currentPageNumber = (NSInteger)((scrollView.contentOffset.x + CGRectGetWidth(self.contentRect) / 2) / CGRectGetWidth(self.contentRect));
    }
}

-(void)setCurrentPageNumber:(NSInteger)currentPageNumber{
    if (currentPageNumber != _currentPageNumber || currentPageNumber == 0) {
        _currentPageNumber = currentPageNumber;
        if (_titleArray.count > 5) {
            CGFloat topTabOffsetX = 0;
            if (currentPageNumber >= 2) {
                if (currentPageNumber <= _titleArray.count - 3) {
                    topTabOffsetX = (currentPageNumber - 2) * _More5LineWidth;
                }
                else {
                    if (currentPageNumber == _titleArray.count - 2) {
                        topTabOffsetX = (currentPageNumber - 3) * _More5LineWidth;
                    }else {
                        topTabOffsetX = (currentPageNumber - 4) * _More5LineWidth;
                    }
                }
            }
            else {
                if (currentPageNumber == 1) {
                    topTabOffsetX = 0 * _More5LineWidth;
                }else {
                    topTabOffsetX = currentPageNumber * _More5LineWidth;
                }
            }
            [self.tabbarScollView setContentOffset:CGPointMake(topTabOffsetX, 0) animated:YES];
        }
        
        for (NSUInteger number = 0; number < _titleArray.count; number++) {
            if (currentPageNumber == number && number <= _objectArray.count - 1) {
                
                if ([_objectArray[number] isKindOfClass:[NSString class]]) {//如果是字符串
                  Class className = NSClassFromString(_objectArray[number]);
                    if ([className isSubclassOfClass:[UIViewController class]] && (!viewAlloc[currentPageNumber] || viewAlloc[currentPageNumber] == NO)) {//控制器&&(!viewAlloc[currentPageNumber] || viewAlloc[currentPageNumber] == NO)
                        UIViewController *current = className.new;
                        [self createOtherViewControllers:current WithControllerTag:currentPageNumber];
                    }else if ([className isKindOfClass:[UIView class]]){
                        UIView *singleView =className.new;
                        singleView.frame = CGRectMake(CGRectGetWidth(self.contentRect) * currentPageNumber, 0, CGRectGetWidth(self.contentRect), self.frame.size.height - _tabbarHeight);
                        [self.contentScollView addSubview:singleView];
                    }else{
                         NSLog(@"Your Controller or View %li is not found in this project!",(long)currentPageNumber + 1);
                    }
                }else{
                    if ([_objectArray[currentPageNumber] isKindOfClass:[UIViewController class]]) {
                        UIViewController *ctrl = _objectArray[currentPageNumber];
                        if (ctrl && viewAlloc[currentPageNumber] == NO) {
                            [self createOtherViewControllers:ctrl WithControllerTag:currentPageNumber];
                        }else if (!ctrl) {
                            NSLog(@"Your Controller or View %li is not found in this project!",(long)currentPageNumber + 1);
                        }
                    }else if ([_objectArray[currentPageNumber] isKindOfClass:[UIView class]]) {
                        UIView *singleView = _objectArray[currentPageNumber];
                        singleView.frame = CGRectMake(CGRectGetWidth(self.contentRect) * currentPageNumber, 0, CGRectGetWidth(self.contentRect), self.frame.size.height - _tabbarHeight);
                        [self.contentScollView addSubview:singleView];
                    }
                }
            }
        }
    }
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
       
        self.contentRect = self.frame;
        self.tabbarScollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentRect), _tabbarHeight);
        self.contentScollView.frame = CGRectMake(0, _tabbarHeight, CGRectGetWidth(self.contentRect), CGRectGetHeight(self.contentRect) - _tabbarHeight - CGRectGetMinY(self.contentRect));
        
        for (UIView *view in self.contentScollView.subviews) {
            CGRect rect =  view.frame;
            rect.size = CGSizeMake(CGRectGetWidth(self.contentRect), CGRectGetHeight(self.contentScollView.frame));
            view.frame = rect;
        }
    }
}
/**
 *  Create other controllers or views.
 *
 *  @param currentController controllers.
 *  @param tag    controller's tag.
 */
- (void)createOtherViewControllers:(UIViewController *)currentController WithControllerTag:(NSInteger)tag {
    if (!self.weakViewController) {
        
        self.weakViewController = [self getViewControllerFromCurrentView];
    }
    if (!self.weakViewController) {
        return;
    }
    [self.weakViewController addChildViewController:currentController];
    self.lastObject = self.currentObject;
    self.currentObject = currentController;
    [_loadedArray addObject:@{@"tag":@(tag),@"controller":currentController}];
#ifdef DEBUG
        NSLog(@"Use new created controller or view%li",(long)tag + 1);
#endif
    currentController.view.frame = CGRectMake(CGRectGetWidth(self.contentRect) * tag, 0, CGRectGetWidth(self.contentRect), self.frame.size.height - _tabbarHeight);
    [self.contentScollView addSubview:currentController.view];
    viewAlloc[tag] = YES;
}
-(UIViewController*)getViewControllerFromCurrentView{
    
    UIResponder *nextResponder = self.nextResponder;
    //     NSLog(@"%@",NSStringFromClass([nextResponder class]));
    while (nextResponder != nil) {
        
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            self.weakViewController = nil;
            break;
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
//            self.weakViewController = (UIViewController*)nextResponder;
            return (UIViewController *)nextResponder;
            break;
            
        }
        nextResponder = nextResponder.nextResponder;
    }
    return nil;
}
-(void)dealloc{
    
    [self removeObserver:self forKeyPath:@"frame"];
}
@end
