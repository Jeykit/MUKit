//
//  MUVideoIndicatorView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/8.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUVideoIndicatorView.h"

@implementation MUVideoIndicatorView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Add gradient layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[
                             (__bridge id)[[UIColor clearColor] CGColor],
                             (__bridge id)[[UIColor blackColor] CGColor]
                             ];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // Add gradient layer
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = @[
                                 (__bridge id)[[UIColor clearColor] CGColor],
                                 (__bridge id)[[UIColor blackColor] CGColor]
                                 ];
        
        [self.layer insertSublayer:gradientLayer atIndex:0];
        
        _slomoIcon = [[MUSlomoIconView alloc]initWithFrame:CGRectMake(5., (CGRectGetHeight(frame) - 8.)/2.- 3, 12., 12.)];
        [self addSubview:_slomoIcon];
        
        _videoIcon = [[MUVideoIconView alloc]initWithFrame:CGRectMake(5., (CGRectGetHeight(frame) - 8.)/2., 14., 8.)];
        [self addSubview:_videoIcon];

        CGFloat width = CGRectGetMaxX(_videoIcon.frame);
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, (CGRectGetHeight(frame) - 15.)/2., frame.size.width - width, 15.)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:12.];
        _timeLabel.text = @"00:00";
        [self addSubview:_timeLabel];
        
    }
    return self;
}
@end
