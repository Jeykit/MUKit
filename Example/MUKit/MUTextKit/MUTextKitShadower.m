//
//  MUTextKitShadower.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUTextKitShadower.h"

#import <tgmath.h>

static inline CGSize _insetSize(CGSize size, UIEdgeInsets insets)
{
    size.width -= (insets.left + insets.right);
    size.height -= (insets.top + insets.bottom);
    return size;
}

static inline UIEdgeInsets _invertInsets(UIEdgeInsets insets)
{
    
    UIEdgeInsets invertInsets = UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
    return invertInsets;
}

@implementation MUTextKitShadower {
    UIEdgeInsets _calculatedShadowPadding;
}

+ (MUTextKitShadower *)shadowerWithShadowOffset:(CGSize)shadowOffset
                                    shadowColor:(UIColor *)shadowColor
                                  shadowOpacity:(CGFloat)shadowOpacity
                                   shadowRadius:(CGFloat)shadowRadius
{
    /**
     * For all cases where no shadow is drawn, we share this singleton shadower to save resources.
     */
    static dispatch_once_t onceToken;
    static MUTextKitShadower *sharedNonShadower;
    dispatch_once(&onceToken, ^{
        sharedNonShadower = [[MUTextKitShadower alloc] initWithShadowOffset:CGSizeZero shadowColor:nil shadowOpacity:0 shadowRadius:0];
    });
    
    BOOL hasShadow = shadowOpacity > 0 && (shadowRadius > 0 || CGSizeEqualToSize(shadowOffset, CGSizeZero) == NO) && CGColorGetAlpha(shadowColor.CGColor) > 0;
    if (hasShadow == NO) {
        return sharedNonShadower;
    } else {
        return [[MUTextKitShadower alloc] initWithShadowOffset:shadowOffset shadowColor:shadowColor shadowOpacity:shadowOpacity shadowRadius:shadowRadius];
    }
}

- (instancetype)initWithShadowOffset:(CGSize)shadowOffset
                         shadowColor:(UIColor *)shadowColor
                       shadowOpacity:(CGFloat)shadowOpacity
                        shadowRadius:(CGFloat)shadowRadius
{
    if (self = [super init]) {
        _shadowOffset = shadowOffset;
        _shadowColor = shadowColor;
        _shadowOpacity = shadowOpacity;
        _shadowRadius = shadowRadius;
        _calculatedShadowPadding = UIEdgeInsetsMake(-INFINITY, -INFINITY, INFINITY, INFINITY);
    }
    return self;
}

/*
 * This method is duplicated here because it gets called frequently, and we were
 * wasting valuable time constructing a state object to ask it.
 */
- (BOOL)_shouldDrawShadow
{
    return _shadowOpacity != 0.0 && (_shadowRadius != 0 || !CGSizeEqualToSize(_shadowOffset, CGSizeZero)) && CGColorGetAlpha(_shadowColor.CGColor) > 0;
}

- (void)setShadowInContext:(CGContextRef)context
{
    if ([self _shouldDrawShadow]) {
        CGColorRef textShadowColor = CGColorRetain(_shadowColor.CGColor);
        CGSize textShadowOffset = _shadowOffset;
        CGFloat textShadowOpacity = _shadowOpacity;
        CGFloat textShadowRadius = _shadowRadius;
        
        if (textShadowOpacity != 1.0) {
            CGFloat inherentAlpha = CGColorGetAlpha(textShadowColor);
            
            CGColorRef oldTextShadowColor = textShadowColor;
            textShadowColor = CGColorCreateCopyWithAlpha(textShadowColor, inherentAlpha * textShadowOpacity);
            CGColorRelease(oldTextShadowColor);
        }
        
        CGContextSetShadowWithColor(context, textShadowOffset, textShadowRadius, textShadowColor);
        
        CGColorRelease(textShadowColor);
    }
}


- (UIEdgeInsets)shadowPadding
{
    if (_calculatedShadowPadding.top == -INFINITY) {
        if (![self _shouldDrawShadow]) {
            return UIEdgeInsetsZero;
        }
        
        UIEdgeInsets shadowPadding = UIEdgeInsetsZero;
        
        // min values are expected to be negative for most typical shadowOffset and
        // blurRadius settings:
        shadowPadding.top = fmin(0.0f, _shadowOffset.height - _shadowRadius);
        shadowPadding.left = fmin(0.0f, _shadowOffset.width - _shadowRadius);
        
        shadowPadding.bottom = fmin(0.0f, -_shadowOffset.height - _shadowRadius);
        shadowPadding.right = fmin(0.0f, -_shadowOffset.width - _shadowRadius);
        
        _calculatedShadowPadding = shadowPadding;
    }
    
    return _calculatedShadowPadding;
}

- (CGSize)insetSizeWithConstrainedSize:(CGSize)constrainedSize
{
    return _insetSize(constrainedSize, _invertInsets([self shadowPadding]));
}

- (CGRect)insetRectWithConstrainedRect:(CGRect)constrainedRect
{
    return UIEdgeInsetsInsetRect(constrainedRect, _invertInsets([self shadowPadding]));
}

- (CGSize)outsetSizeWithInsetSize:(CGSize)insetSize
{
    return _insetSize(insetSize, [self shadowPadding]);
}

- (CGRect)outsetRectWithInsetRect:(CGRect)insetRect
{
    return UIEdgeInsetsInsetRect(insetRect, [self shadowPadding]);
}

- (CGRect)offsetRectWithInternalRect:(CGRect)internalRect
{
    return (CGRect){
        .origin = [self offsetPointWithInternalPoint:internalRect.origin],
        .size = internalRect.size
    };
}

- (CGPoint)offsetPointWithInternalPoint:(CGPoint)internalPoint
{
    UIEdgeInsets shadowPadding = [self shadowPadding];
    return (CGPoint){
        internalPoint.x + shadowPadding.left,
        internalPoint.y + shadowPadding.top
    };
}

- (CGPoint)offsetPointWithExternalPoint:(CGPoint)externalPoint
{
    UIEdgeInsets shadowPadding = [self shadowPadding];
    return (CGPoint){
        externalPoint.x - shadowPadding.left,
        externalPoint.y - shadowPadding.top
    };
}

@end
