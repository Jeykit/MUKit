//
//  MUTextKitRenderer.h
//  MUKit_Example
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUTextKitAttribute.h"
#import "MUTextKitContext.h"
#import "MUTextKitShadower.h"
#import "MUTextKitFontSizeAdjuster.h"
#import "MUTextKitTailTruncater.h"


@interface MUTextKitRenderer : NSObject
/**
 Designated Initializer
 @discussion Sizing will occur as a result of initialization, so be careful when/where you use this.
 */
- (instancetype)initWithTextKitAttributes:(MUTextKitAttribute *)textComponentAttributes
                          constrainedSize:(const CGSize)constrainedSize;

/**
 Draw the renderer's text content into the bounds provided.
 
 @param bounds The rect in which to draw the contents of the renderer.
 */
- (void)drawInContext:(CGContextRef)context bounds:(CGRect)bounds;

@property (nonatomic, assign, readonly) CGSize constrainedSize;

@property (nonatomic, strong, readonly) MUTextKitContext *context;

@property (nonatomic, strong, readonly) MUTextKitFontSizeAdjuster *fontSizeAdjuster;

@property (nonatomic, strong, readonly) MUTextKitShadower *shadower;

@property (nonatomic, strong, readonly) MUTextKitTailTruncater *truncater;

@property (nonatomic, assign, readonly) CGFloat currentScaleFactor;

/**
 Returns the computed size of the renderer given the constrained size and other parameters in the initializer.
 */
- (CGSize)size;


/**
 Returns the fit size of the renderer when the maximumNumberOfLines set to 0(zero).
 */
- (CGSize)maximumSize;
#pragma mark - Text Ranges

/**
 The character range from the original attributedString that is displayed by the renderer given the parameters in the
 initializer.
 */
@property (nonatomic, assign, readonly) NSArray *visibleRanges;

/**
 The number of lines shown in the string.
 */
- (NSUInteger)lineCount;

/**
 Whether or not the text is truncated.
 */
- (BOOL)isTruncated;

/**
 Returns the first visible range or an NSRange with location of NSNotFound and size of 0 if no first visible
 range exists
 */
@property (nonatomic, assign, readonly) NSRange firstVisibleRange;
@end
