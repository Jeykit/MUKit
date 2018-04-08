//
//  MUDefalutTitleCollectionReusableView.m
//  Pods
//
//  Created by Jekity on 2017/9/13.
//
//

#import "MUDefalutTitleCollectionReusableView.h"

@interface MUDefalutTitleCollectionReusableView()
@property(nonatomic, strong)UILabel *label;

@property(nonatomic, strong)UIImageView *imageView;
@end
@implementation MUDefalutTitleCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font      = [UIFont systemFontOfSize:17.];
        _label.text = @"   ";
        self.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.0];
        [self addSubview:_label];

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = _label.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(_imageView.frame)+8., (44. -rect.size.height)/2.);
    CGRect imageRect = _imageView.frame;
    imageRect.origin = CGPointMake(8., (44. -imageRect.size.height)/2.);
//    rect.origin = CGPointMake(CGRectGetMaxX(_imageView.frame)+4., (44. -rect.size.height)/2.);
//    if ([self.reuseIdentifier isEqualToString:@"sectionFooterTitle"]) {
//         rect.origin = CGPointMake(CGRectGetMaxX(_imageView.frame)+4., (44. -rect.size.height)/2.);
//    }
    _imageView.frame = imageRect;
    _label.frame = rect;

}
-(void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
    [_label sizeToFit];
}
-(void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
    [_imageView sizeToFit];
}
@end
