//
//  MUPaperView.m
//  AFNetworking
//
//  Created by Jekity on 2017/12/8.
//

#import "MUPaperView.h"
#import "MUPaperBaseView.h"

@interface MUPaperView()
@property(nonatomic, strong)MUPaperBaseView *baseView;
@property(nonatomic, assign)BOOL loaded;
@property(nonatomic, assign)CGFloat More5LineWidth;
@end

#define MaxNums  10 //Max limit number,recommand below 10.
@implementation MUPaperView{
    NSArray *titlesArray;
    NSArray *classArray;
}
-(instancetype)initWithFrame:(CGRect)frame WithTopArray:(NSArray *)topArray WithObjects:(NSArray *)objects{
    if (self = [super initWithFrame:frame]) {
        titlesArray = topArray;
        classArray  = objects;
        _More5LineWidth = CGRectGetWidth(frame) / 5.;
        
    }
    return self;
}
-(void)setPagerStyles:(MUPagerStyle)pagerStyles{
    _pagerStyles = pagerStyles;
    self.baseView.tabType = pagerStyles;
    
}
-(MUPaperBaseView *)baseView{
    if (!_baseView) {
        _baseView = [[MUPaperBaseView alloc] initWithFrame:self.bounds WithTopTabType:0];
        [self addSubview:_baseView];
    }
    return _baseView;
}
#pragma mark -setter method
-(void)setDefaultPage:(NSInteger)defaultPage{
    _defaultPage = defaultPage;
    _defaultPage = (_defaultPage > 0 && _defaultPage < titlesArray.count)?_defaultPage:0;
    //    self.baseView.contentScollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*_defaultPage, 0);
}

-(void)setSelectBottomLinePer:(CGFloat)selectBottomLinePer{
    _selectBottomLinePer = selectBottomLinePer;
}
-(void)setSlideEnabled:(BOOL)slideEnabled{
    _slideEnabled = slideEnabled;
    self.baseView.slideEnabled = slideEnabled;
}

-(void)setSliderHeight:(CGFloat)sliderHeight{
    _sliderHeight = sliderHeight;
    self.baseView.blockHeight = sliderHeight>30.?sliderHeight:30.;
}
-(void)setTopTabbarBackgroundColor:(UIColor *)topTabbarBackgroundColor{
    _topTabbarBackgroundColor = topTabbarBackgroundColor;
    self.baseView.tabbarScollView.backgroundColor = topTabbarBackgroundColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (!_loaded) {
        self.baseView.cornerRadiusRatio = _sliderCornerRadiusRatio > 0?_sliderCornerRadiusRatio:0;
        self.baseView.titlesFont = _titleFont > 0?_titleFont:12.;
        self.baseView.fontSizeAutoFit = _fontSizeAutoFit;
        self.baseView.blockHeight = _sliderHeight;
        self.baseView.normalColor = _titleColor?:[UIColor blackColor];
        CGFloat tabHeight = _topTabHeight > 30.?_topTabHeight:30.;
        self.baseView.bottomLineHeight = _underlineHeight > 0?:1.;
        self.baseView.highlightedColor = _hightlightTitleColor?:[UIColor whiteColor];
        self.baseView.tabbarHeight = tabHeight;
        self.baseView.autoFitTitleLine = _autoFitTitleLine;
        self.baseView.objectArray = classArray;
        self.baseView.titleArray  = titlesArray;
        self.baseView.titleScale = _titleScale > 0?_titleScale:1;
        self.baseView.defaultPage = self.defaultPage;
        self.baseView.underlineOrBlockColor = _underlineColor ? :[UIColor lightGrayColor];
        self.baseView.separationLineHidden = _separationLineHidden;
        
        self.baseView.changedBlock = _slidedPageBlock;
        
        self.loaded = YES;
    }
}
@end
