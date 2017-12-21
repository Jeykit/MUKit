//
//  MUOverlayView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/8.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUOverlayView.h"

@implementation MUOverlayView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _checkmarkView = [[MUCheckmarkView alloc]initWithFrame:CGRectMake(frame.size.width - 28., frame.size.height - 28., 24., 24.)];
        _checkmarkView.hidden = YES;
        [self addSubview:_checkmarkView];
        _circleView = [[MUCircleView alloc]initWithFrame:CGRectMake(frame.size.width - 28., frame.size.height - 28., 24., 24.)];
        [self addSubview:_circleView];
    }
    return self;
}
//-(void)setTintColor:(UIColor *)tintColor{
//    _tintColor = tintColor;
////    _checkmarkView.bodyColor      = [UIColor whiteColor];
//    _checkmarkView.checkmarkColor = tintColor;
//    
////    _circleView.borderColor       = tintColor;
//}
@end
