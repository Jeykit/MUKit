//
//  MUTipsView.m
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#import "MUTipsView.h"

@interface MUTipsView()
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIButton *innerButton;
@property(nonatomic, assign)CGFloat centerY;
@end
@implementation MUTipsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        
//        self.userInteractionEnabled = NO;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font          = [UIFont systemFontOfSize:11.];
        _titleLabel.textColor     = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 24.;
         _centerY = CGRectGetHeight(self.frame) * 0.38;
        [self addSubview:_titleLabel];
        
    }
    return self;
}
-(void)setTipsImage:(UIImage *)tipsImage{
    _tipsImage = tipsImage;
    _imageView.image = tipsImage;
    _imageView.frame = CGRectMake(0, 0, CGImageGetWidth(tipsImage.CGImage)/2., CGImageGetHeight(tipsImage.CGImage)/2.);
    
    _imageView.center = CGPointMake(self.center.x, _centerY);
}
-(void)setTipsString:(NSString *)tipsString{
    _tipsString = tipsString;
    _titleLabel.frame         = CGRectMake(12., 0, CGRectGetWidth(self.frame) - 24., 0);
    _titleLabel.text          = tipsString;
    [_titleLabel sizeToFit];
    if (!CGRectEqualToRect(_imageView.frame, CGRectZero)) {
        _titleLabel.center = CGPointMake(_imageView.center.x, CGRectGetMaxY(_imageView.frame) + 12.);
    }else{
        _titleLabel.center = CGPointMake(self.center.x, _centerY);

    }
}
-(UIButton *)button{
    if (!_innerButton) {
        
        _innerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) * .62, 44.)];
        [_innerButton addTarget:self action:@selector(buttonByClicked) forControlEvents:UIControlEventTouchUpInside];
        CGPoint center = CGPointZero;
        if (!CGRectEqualToRect(_titleLabel.frame, CGRectZero)) {
            CGSize fontSize = [_titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame) - 24., MAXFLOAT)];
            center = CGPointMake(_titleLabel.center.x, _titleLabel.center.y + fontSize.height + 44.);
        }else if (!CGRectEqualToRect(_imageView.frame, CGRectZero)){
            center = CGPointMake(_imageView.center.x, CGRectGetMaxY(_imageView.frame) + 44.);
        }else{
            center = CGPointMake(self.center.x, _centerY);
        }
        _innerButton.center = center;
        [self addSubview:_innerButton];
    }
    return _innerButton;
}
-(void)buttonByClicked{
    
    if (self.buttonByTaped) {
        self.buttonByTaped(self.innerButton);
    }
}

@end
