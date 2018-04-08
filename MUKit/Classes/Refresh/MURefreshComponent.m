//
//  MURefreshComponent.m
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import "MURefreshComponent.h"

@interface MURefreshComponent()
@property(nonatomic, assign)CGFloat arrowTime;
@end
@implementation MURefreshComponent

-(instancetype)initWithFrame:(CGRect)frame type:(MURefreshingType)type backgroundImage:(UIImage *)backgroundImage{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        switch (type) {
                case MURefreshingTypeHeader:
                self.imageView.image           = [UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"];
                self.titleLabel.text           = @"下拉刷新";
                self.titleLabel.font           = [UIFont systemFontOfSize:11.];
                self.backgroundImageView.image = backgroundImage;
                break;
                case MURefreshingTypeFooter:
//                self.imageView.image           = [UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"];
                self.titleLabel.text           = @"";
                self.titleLabel.font           = [UIFont systemFontOfSize:11.];
                self.backgroundImageView.image = backgroundImage;
                break;
            default:
                break;
        }
    }
    [self initalizationNormalView:self];
    return self;
}

-(void)initalizationNormalView:(UIView *)view{
    [view addSubview:self.backgroundImageView];
    [view addSubview:self.titleLabel];
    [view addSubview:self.imageView];
    [view addSubview:self.indicatorView];
    [view layoutSubviews];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSubviews_Normal];
}
- (void)layoutSubviews_Normal {
    CGSize size = self.bounds.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    self.backgroundImageView.frame = CGRectMake(0, 0, width, height);
    [UIView performWithoutAnimation:^{
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(width/2., height/2.);
        self.imageView.frame = CGRectMake(0, 0, 12, 12);
        self.indicatorView.center = CGPointMake(CGRectGetMinX(self.titleLabel.frame) - 12., height/2.);
        self.imageView.center = CGPointMake(self.titleLabel.frame.origin.x - 16.0, height/2.0);
    }];
}

#pragma mark -refreshing
-(void)updateRefreshing:(MURefreshingType)type state:(MURefreshingState)state{
   
    [self updatedRefreshing:type state:state];
}
-(void)updatedRefreshing:(MURefreshingType)type state:(MURefreshingState)state{
    
    switch (state) {
            case MURefreshingStateNormal:
            [self endRefreshingAnimation:type];
            break;
            case MURefreshingStateWillRefresh:
            [self willStartRefreshAnimation:type];
            break;
            case MURefreshingStateRefreshing:
            [self startRefreshAnimation:type];
            break;
            case MURefreshingStateRefreDone:
            [self doneRefreshAnimation:type];
            break;
            case MURefreshingStateNoMoreData:
            [self doneRefreshAnimation:type];
            break;
        default:
            break;
    }
}
-(void)endRefreshingAnimation:(MURefreshingType)type{
    switch (type) {
            case MURefreshingTypeHeader:
            self.titleLabel.text = @"下拉刷新";
            break;
            case MURefreshingTypeFooter:
            self.titleLabel.text = @"";
            break;
        default:
            break;
    }
    if (self.indicatorView.hidden) {
        return;
    }
    [self.indicatorView stopAnimating];
    self.imageView.hidden = NO;
    self.indicatorView.hidden = YES;
    [UIView animateWithDuration:0.375 animations:^{
        self.arrowTime = 0.0;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}


- (void)startRefreshAnimation:(MURefreshingType)type{
    self.titleLabel.text = @"";
    [self.indicatorView startAnimating];
    self.indicatorView.hidden = NO;
    if (type != MURefreshingTypeFooter) {
         self.imageView.hidden = YES;
        self.titleLabel.text =  @"正在刷新";
         self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
    }
   
}

- (void)willStartRefreshAnimation:(MURefreshingType)type {
    if (self.arrowTime > 0) {
        return;
    }
    self.titleLabel.text = @"释放刷新";
    [UIView animateWithDuration:0.375 animations:^{
        self.arrowTime = 0.375;
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
    }];
}
- (void)doneRefreshAnimation:(MURefreshingType)type {
    self.titleLabel.text = @"刷新完成";
    [self.indicatorView stopAnimating];
    if (type != MURefreshingTypeFooter) {
        self.imageView.hidden = NO;
        self.indicatorView.hidden = YES;
        [UIView animateWithDuration:self.arrowTime animations:^{
            self.arrowTime = 0.0;
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
    
}

- (void)noMoreDataRefreshAnimation:(MURefreshingType)type {
    self.titleLabel.text = @"我是有底线的";
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
   
    
}
#pragma mark - lazy loading
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel      = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12.];
        _titleLabel.textColor = [UIColor colorWithRed:150./255. green:150./255. blue:150./255. alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _titleLabel;
}
-(UIImageView *)imageView{
    if (!_imageView) {
//         _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"]];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}
-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}
-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        
        _indicatorView        = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(0, 0, 12, 12);
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}
@end
