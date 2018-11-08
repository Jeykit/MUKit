//
//  MUAssetCell.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/7.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUAssetCell.h"
#import "MUVideoIndicatorView.h"
#import "MUCheckmarkView.h"
#import "MUCircleView.h"


@implementation MUAssetCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        [self.contentView addSubview:_imageView];
        
        
        _videoIndicatorView =  [[MUVideoIndicatorView alloc]initWithFrame:CGRectMake(0, height - 24., width, 24.)];
        _videoIndicatorView.hidden = YES;
        _videoIndicatorView.userInteractionEnabled = NO;
        [self.contentView addSubview:_videoIndicatorView];
        
        _overlayView = [[MUOverlayView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        _overlayView.userInteractionEnabled = NO;
        _overlayView.hidden = YES;
        [self.contentView addSubview:_overlayView];
    }
    return self;
}
-(void)setPicked:(BOOL)picked{
    _picked = picked;
    if (picked) {
        _overlayView.circleView.hidden    = YES;
        _overlayView.checkmarkView.hidden = NO;
        _overlayView.backgroundColor = [UIColor colorWithWhite:1. alpha:0.375];
    }else{
        _overlayView.circleView.hidden    = NO;
        _overlayView.checkmarkView.hidden = YES;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
}
-(void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    _overlayView.tintColor = tintColor;
}
@end
