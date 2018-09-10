//
//  MUTextKitRenderer.m
//  MUKit_Example
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUTextKitRenderer.h"



static NSCharacterSet *_defaultAvoidTruncationCharacterSet()
{
    static NSCharacterSet *truncationCharacterSet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *mutableCharacterSet = [[NSMutableCharacterSet alloc] init];
        [mutableCharacterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [mutableCharacterSet addCharactersInString:@".,!?:;"];
        truncationCharacterSet = mutableCharacterSet;
    });
    return truncationCharacterSet;
}

@implementation MUTextKitRenderer
{
     CGSize _calculatedSize;
     CGSize _fitSize;
     MUTextKitAttribute * _attributes;
}
#pragma mark - Initialization

- (instancetype)initWithTextKitAttributes:(MUTextKitAttribute *)attributes
                          constrainedSize:(const CGSize)constrainedSize
{
    if (self = [super init]) {
        if (attributes.isUsedAutoLayout) {
            _constrainedSize = CGSizeMake(constrainedSize.width, FLT_MAX);
        }else{
            _constrainedSize = constrainedSize;
        }
        _fitSize = CGSizeZero;
        _attributes = attributes;
        _context = [[MUTextKitContext alloc] initWithAttributedString:attributes.attributedString
                                                        lineBreakMode:attributes.lineBreakMode
                                                 maximumNumberOfLines:attributes.maximumNumberOfLines
                                                       exclusionPaths:attributes.exclusionPaths
                                                      constrainedSize:constrainedSize];
        
        // As the renderer should be thread safe, create all subcomponents in the initialization method
        _shadower = [MUTextKitShadower shadowerWithShadowOffset:attributes.shadowOffset
                                                    shadowColor:attributes.shadowColor
                                                  shadowOpacity:attributes.shadowOpacity
                                                   shadowRadius:attributes.shadowRadius];
        
        // We must inset the constrained size by the size of the shadower.
        CGSize shadowConstrainedSize = [[self shadower] insetSizeWithConstrainedSize:_constrainedSize];
        
        
        NSCharacterSet *avoidTailTruncationSet = attributes.avoidTailTruncationSet ?: _defaultAvoidTruncationCharacterSet();
        _truncater = [[MUTextKitTailTruncater alloc] initWithContext:[self context]
                                          truncationAttributedString:attributes.truncationAttributedString
                                              avoidTailTruncationSet:avoidTailTruncationSet];
        
        MUTextKitAttribute *attributes = _attributes;
        // We must inset the constrained size by the size of the shadower.
        _fontSizeAdjuster = [[MUTextKitFontSizeAdjuster alloc] initWithContext:[self context]
                                                               constrainedSize:shadowConstrainedSize
                                                             textKitAttributes:attributes];
        
        // Calcualate size immediately
        [self _calculateSize];
        
    }
    return self;
}

- (void)updateAttributesNow{
    [_context.textStorage replaceCharactersInRange:NSMakeRange(0, _context.textStorage.string.length) withAttributedString:_attributes.attributedString];
    _context.textContainer.maximumNumberOfLines = _attributes.maximumNumberOfLines;
    _context.textContainer.lineBreakMode = _attributes.lineBreakMode;
    _context.textContainer.exclusionPaths = _attributes.exclusionPaths;
    _context.textContainer.size = _constrainedSize;
    if ( !_attributes.isUsedAutoLayout) {
        _context.textContainer.size = _attributes.constrainedSize;
        _constrainedSize = _attributes.constrainedSize;
    }
    
    [self _calculateSize];
}
- (void)_calculateSize
{
    // if we have no scale factors or an unconstrained width, there is no reason to try to adjust the font size
    if (isinf(_constrainedSize.width) == NO && [_attributes.pointSizeScaleFactors count] > 0) {
        _currentScaleFactor = [[self fontSizeAdjuster] scaleFactor];
    }
    
    BOOL isScaled = [self isScaled];
    __block NSTextStorage *scaledTextStorage = nil;
    if (isScaled) {
        // apply the string scale before truncating or else we may truncate the string after we've done the work to shrink it.
        [[self context] performBlockWithLockedTextKitComponents:^(NSLayoutManager *layoutManager, NSTextStorage *textStorage, NSTextContainer *textContainer) {
            NSMutableAttributedString *scaledString = [[NSMutableAttributedString alloc] initWithAttributedString:textStorage];
            [MUTextKitFontSizeAdjuster adjustFontSizeForAttributeString:scaledString withScaleFactor:_currentScaleFactor];
            scaledTextStorage = [[NSTextStorage alloc] initWithAttributedString:scaledString];
            
            [textStorage removeLayoutManager:layoutManager];
            [scaledTextStorage addLayoutManager:layoutManager];
        }];
    }
    
    [[self truncater] truncate];
    
    CGRect constrainedRect = {CGPointZero, _constrainedSize};
    __block CGRect boundingRect;
    __block BOOL maximumOfLinesIsZero = NO;
    // Force glyph generation and layout, which may not have happened yet (and isn't triggered by
    // -usedRectForTextContainer:).
    [[self context] performBlockWithLockedTextKitComponents:^(NSLayoutManager *layoutManager, NSTextStorage *textStorage, NSTextContainer *textContainer) {
        [layoutManager ensureLayoutForTextContainer:textContainer];
        boundingRect = [layoutManager usedRectForTextContainer:textContainer];
        maximumOfLinesIsZero = textContainer.maximumNumberOfLines == 0?YES:NO;
        if (isScaled) {
            // put the non-scaled version back
            [scaledTextStorage removeLayoutManager:layoutManager];
            [textStorage addLayoutManager:layoutManager];
        }
    }];
    
    // TextKit often returns incorrect glyph bounding rects in the horizontal direction, so we clip to our bounding rect
    // to make sure our width calculations aren't being offset by glyphs going beyond the constrained rect.
    CGRect rect = {.size = constrainedRect.size};
    boundingRect = CGRectIntersection(boundingRect, rect);
    _calculatedSize = [_shadower outsetSizeWithInsetSize:boundingRect.size];
    
}
#pragma mark - Drawing
- (void)drawInContext:(CGContextRef)context bounds:(CGRect)bounds;
{
    // We add an assertion so we can track the rare conditions where a graphics context is not present
    NSAssert(context != nil, @"This is no good without a context.");
    CGRect rect = { .size = _constrainedSize };
    bounds = CGRectIntersection(bounds, rect);
    CGRect shadowInsetBounds = [[self shadower] insetRectWithConstrainedRect:bounds];
    CGContextSaveGState(context);
    [[self shadower] setShadowInContext:context];
    UIGraphicsPushContext(context);
    _fitSize = shadowInsetBounds.size;
//    NSLog(@"%@, shadowInsetBounds = %@",self, NSStringFromCGRect(shadowInsetBounds));
    BOOL isScaled = [self isScaled];
    [[self context] performBlockWithLockedTextKitComponents:^(NSLayoutManager *layoutManager, NSTextStorage *textStorage, NSTextContainer *textContainer) {
        
        NSTextStorage *scaledTextStorage = nil;
        if (isScaled) {
            // if we are going to scale the text, swap out the non-scaled text for the scaled version.
            NSMutableAttributedString *scaledString = [[NSMutableAttributedString alloc] initWithAttributedString:textStorage];
            [MUTextKitFontSizeAdjuster adjustFontSizeForAttributeString:scaledString withScaleFactor:_currentScaleFactor];
            scaledTextStorage = [[NSTextStorage alloc] initWithAttributedString:scaledString];
            
            [textStorage removeLayoutManager:layoutManager];
            [scaledTextStorage addLayoutManager:layoutManager];
        }
        
//        NSLog(@"usedRect: %@", NSStringFromCGRect([layoutManager usedRectForTextContainer:textContainer]));
        
        NSRange glyphRange = [layoutManager glyphRangeForBoundingRect:(CGRect){ .size = textContainer.size } inTextContainer:textContainer];
//        NSLog(@"boundingRect: %@", NSStringFromCGRect([layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer]));
        
        [layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:bounds.origin];
        [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:bounds.origin];
        
        if (isScaled) {
            // put the non-scaled version back
            [scaledTextStorage removeLayoutManager:layoutManager];
            [textStorage addLayoutManager:layoutManager];
        }

        }];
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}
- (BOOL)isScaled
{
    return (_currentScaleFactor > 0 && _currentScaleFactor < 1.0);
}
#pragma mark - String Ranges

- (NSUInteger)lineCount
{
    __block NSUInteger lineCount = 0;
    [[self context] performBlockWithLockedTextKitComponents:^(NSLayoutManager *layoutManager, NSTextStorage *textStorage, NSTextContainer *textContainer) {
        for (NSRange lineRange = { 0, 0 }; NSMaxRange(lineRange) < [layoutManager numberOfGlyphs]; lineCount++) {
            [layoutManager lineFragmentRectForGlyphAtIndex:NSMaxRange(lineRange) effectiveRange:&lineRange];
        }
    }];
    return lineCount;
}

- (BOOL)isTruncated
{
 
    return self.firstVisibleRange.length < _attributes.attributedString.length;
    
}

- (NSArray *)visibleRanges
{
    return _truncater.visibleRanges;
}

- (NSRange)firstVisibleRange
{
    NSArray *visibleRanges = [self visibleRanges];
    if (visibleRanges.count > 0) {
        NSValue *value = visibleRanges[0];
        return [value rangeValue];
    }
    return NSMakeRange(NSNotFound, 0);
}

- (CGSize)size
{
    return _calculatedSize;
}

- (CGSize)maximumSize{
    
    return CGSizeMake(ceilf(_calculatedSize.width), ceilf(_calculatedSize.height));
}

- (MUTextKitAttribute *)arrtribute{
    return _attributes;
}

@end
