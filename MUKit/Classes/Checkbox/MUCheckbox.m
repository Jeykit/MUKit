//
//  MUCheckbox.m
//  MUKit_Example
//
//  Created by Jekity on 2018/6/5.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUCheckbox.h"
#import <Foundation/Foundation.h>

@implementation MUCheckbox

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self setupDefaults];
        
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults{
    _checkmarkStyle = MUCheckmarkStyleSquare;
    _borderStyle    = MUBorderStyleSquare;
    _borderWidth    = 2.;
    _checkmarkSize   = 0.5;
    _checkboxBackgroundColor = [UIColor clearColor];
    _increasedTouchRadius = 5.;
    _isChecked = YES;
    _useHapticFeedback = YES;
    self.backgroundColor = [UIColor colorWithWhite:1. alpha:0.];
    _uncheckedBorderColor = self.tintColor;
    _checkedBorderColor = self.tintColor;
    _checkmarkColor = self.tintColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
    
    if (_useHapticFeedback) {
    
        if (@available(iOS 10.0, *)) {
            _feedbackGenerator = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
            [_feedbackGenerator prepare];
        }
        
    }


}
- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [self drawBorder:_borderStyle frame:rect];
    if (_isChecked) {
        [self drawCheckmark:_checkmarkStyle frame:rect];
    }
}
- (void)drawBorder:(MUBorderStyle )shappe frame:(CGRect)frame{
    switch (shappe) {
        case MUBorderStyleCircle:
            [self circleBorder:frame];
            break;
        case MUBorderStyleSquare:
            [self  squareBorder:frame];
            break;
        default:
            break;
    }
}
- (void)squareBorder:(CGRect)frame{
    
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:frame];
    if (_isChecked) {
        [_checkedBorderColor setStroke];
    }else{
        [_uncheckedBorderColor setStroke];
    }
    rectanglePath.lineWidth = _borderWidth;
    [rectanglePath stroke];
    [_checkboxBackgroundColor setFill];
    [rectanglePath fill];
}
- (void)circleBorder:(CGRect)frame{
    
    CGRect adjustedRect = CGRectMake(_borderWidth/2., _borderWidth/2., self.bounds.size.width-_borderWidth, self.bounds.size.height-_borderWidth);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:adjustedRect];
    if (_isChecked) {
        [_checkedBorderColor setStroke];
    }else{
        [_uncheckedBorderColor setStroke];
    }
    ovalPath.lineWidth = _borderWidth/2.;
    [ovalPath stroke];
    [_checkboxBackgroundColor setFill];
    [ovalPath fill];
}

-(void)drawCheckmark:(MUCheckmarkStyle)style frame:(CGRect)frame{
    
    CGRect adjustedRect = [self checkmarkRect:frame];
    switch (style) {
        case MUCheckmarkStyleSquare:
            [self squareCheckmark:adjustedRect];
            break;
        case MUCheckmarkStyleCircle:
            [self circleCheckmark:adjustedRect];
            break;
        case MUCheckmarkStyleCross:
            [self crossCheckmark:adjustedRect];
            break;
        case MUCheckmarkStyleTick:
            [self tickCheckmark:adjustedRect];
            break;
        default:
            break;
    }
}
- (void)circleCheckmark:(CGRect)rect{
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [_checkmarkColor setFill];
    [ovalPath fill];
}

- (void)squareCheckmark:(CGRect)rect{
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRect:rect];
    [_checkmarkColor setFill];
    [ovalPath fill];
}
- (void)crossCheckmark:(CGRect)rect{
    
    UIBezierPath *bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint:CGPointMake(CGRectGetMinX(rect)+0.06250*rect.size.width, CGRectGetMinY(rect)+0.06452*rect.size.height)];
    [bezier4Path addLineToPoint:CGPointMake(CGRectGetMinX(rect)+0.93750*rect.size.width, CGRectGetMinY(rect)+0.93548*rect.size.height)];
     [bezier4Path moveToPoint:CGPointMake(CGRectGetMinX(rect)+0.93750*rect.size.width, CGRectGetMinY(rect)+0.06452*rect.size.height)];
      [bezier4Path addLineToPoint:CGPointMake(CGRectGetMinX(rect)+0.06250*rect.size.width, CGRectGetMinY(rect)+0.93548*rect.size.height)];
    [_checkmarkColor setStroke];
    bezier4Path.lineWidth = _checkmarkSize*2.;
    [bezier4Path stroke];
}
- (void)tickCheckmark:(CGRect)rect{
    
    UIBezierPath *bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint:CGPointMake(CGRectGetMinX(rect)+0.04688*rect.size.width, CGRectGetMinY(rect)+0.63548*rect.size.height)];
    [bezier4Path addLineToPoint:CGPointMake(CGRectGetMinX(rect)+0.34896*rect.size.width, CGRectGetMinY(rect)+0.95161*rect.size.height)];
    [bezier4Path addLineToPoint:CGPointMake(CGRectGetMinX(rect)+0.95312*rect.size.width, CGRectGetMinY(rect)+0.04839*rect.size.height)];
    [_checkmarkColor setStroke];
    bezier4Path.lineWidth = _checkmarkSize*2.;
    [bezier4Path stroke];
}
- (CGRect)checkmarkRect:(CGRect)rect{
    
    CGFloat width = CGRectGetMaxX(rect) *_checkmarkSize;
    CGFloat height = CGRectGetMaxY(rect) *_checkmarkSize;
    CGRect adjustedRect = CGRectMake((CGRectGetMaxX(rect) - width)/2., (CGRectGetMaxY(rect) - height)/2., width, height);
    return adjustedRect;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGRect relativeFrame = self.bounds;
    UIEdgeInsets hitTestEdgeInsets =  UIEdgeInsetsMake(-_increasedTouchRadius, -_increasedTouchRadius, -_increasedTouchRadius, -_increasedTouchRadius);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame,point);
    
}
- (void)handleTapGesture:(UITapGestureRecognizer *)gesture{
    self.isChecked = !self.isChecked;
    if (_valueChanged) {
        _valueChanged(_isChecked);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (_useHapticFeedback) {
        // Trigger impact feedback.
        [_feedbackGenerator impactOccurred];
        
        // Keep the generator in a prepared state.
        [_feedbackGenerator prepare];
    }
}
@end
