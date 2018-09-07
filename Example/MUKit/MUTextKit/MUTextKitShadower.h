//
//  MUTextKitShadower.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUTextKitShadower : NSObject
+ (MUTextKitShadower *)shadowerWithShadowOffset:(CGSize)shadowOffset
                                    shadowColor:(UIColor *)shadowColor
                                  shadowOpacity:(CGFloat)shadowOpacity
                                   shadowRadius:(CGFloat)shadowRadius;

/**
 * @abstract The offset from the top-left corner at which the shadow starts.
 * @discussion A positive width will move the shadow to the right.
 *             A positive height will move the shadow downwards.
 */
@property (nonatomic, readonly, assign) CGSize shadowOffset;

//! CGColor in which the shadow is drawn
@property (nonatomic, readonly, strong) UIColor *shadowColor;

//! Alpha of the shadow
@property (nonatomic, readonly, assign) CGFloat shadowOpacity;

//! Radius, in pixels
@property (nonatomic, readonly, assign) CGFloat shadowRadius;

/**
 * @abstract The edge insets which represent shadow padding
 * @discussion Each edge inset is less than or equal to zero.
 *
 * Example:
 *  CGRect boundsWithoutShadowPadding; // Large enough to fit text, not large enough to fit the shadow as well
 *  UIEdgeInsets shadowPadding = [shadower shadowPadding];
 *  CGRect boundsWithShadowPadding = UIEdgeInsetsRect(boundsWithoutShadowPadding, shadowPadding);
 */
- (UIEdgeInsets)shadowPadding;

- (CGSize)insetSizeWithConstrainedSize:(CGSize)constrainedSize;

- (CGRect)insetRectWithConstrainedRect:(CGRect)constrainedRect;

- (CGSize)outsetSizeWithInsetSize:(CGSize)insetSize;

- (CGRect)outsetRectWithInsetRect:(CGRect)insetRect;

- (CGRect)offsetRectWithInternalRect:(CGRect)internalRect;

- (CGPoint)offsetPointWithInternalPoint:(CGPoint)internalPoint;

- (CGPoint)offsetPointWithExternalPoint:(CGPoint)externalPoint;

/**
 * @abstract draws the shadow for text in the provided CGContext
 * @discussion Call within the text node's +drawRect method
 */
- (void)setShadowInContext:(CGContextRef)context;

@end
