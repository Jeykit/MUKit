//
//  MUTextKitNode.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 2018/9/7.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUTextKitNode.h"
#import "MUAsyncDispalyLayer.h"
#import "MUAsyncTransaction.h"
#import "MUAsyncTransactionGroup.h"
#import <atomic>
#import "MUTextKitRenderer.h"
#import "MUTextKitCoreTextAdditions.h"
#import "MUTextKitAttribute.h"
#import "MUHighlightOverlayLayer.h"
#import "MUTextKitRenderer+Positioning.h"

#define MU_TEXTNODE_RECORD_ATTRIBUTED_STRINGS 0
typedef BOOL(^asdisplaynode_iscancelled_block_t)(void);
#define MUAsyncTransactionAssertMainThread() NSAssert(0 != pthread_main_np(), @"This method must be called on the main thread");

static const NSTimeInterval MUTextNodeHighlightFadeOutDuration = 0.15;
static const NSTimeInterval MUTextNodeHighlightFadeInDuration = 0.1;
static const CGFloat MUTextNodeHighlightLightOpacity = 0.11;
static const CGFloat MUTextNodeHighlightDarkOpacity = 0.22;
static NSString *MUTextNodeTruncationTokenAttributeName = @"MUTextNodeTruncationAttribute";

static NSArray *DefaultLinkAttributeNames = @[ NSLinkAttributeName];

@interface MUTextKitNode()<MUAsyncDispalyLayerDelegate>
@property (nonatomic,strong) MUTextKitRenderer *textKitRenderer;
@end

@implementation MUTextKitNode{
    NSRecursiveLock *_recursiveLock;
    std::atomic_uint _displaySentinel;//原子操作
    //    std::unique_lock<std::mutex>locker (std::mutex);
     MUAsyncDispalyLayer *_asyncLayer;
     MUTextKitAttribute * _attribute;
     NSAttributedString *_attributedText;
     NSAttributedString *_composedTruncationText;
    CGSize _shadowOffset;
    CGColorRef _shadowColor;
    UIColor *_cachedShadowUIColor;
    CGFloat _shadowOpacity;
    CGFloat _shadowRadius;
    
    UIEdgeInsets _textContainerInset;
    
    NSArray *_exclusionPaths;
    MUTextNodeHighlightStyle _highlightStyle;
    NSRange _highlightRange;
    MUHighlightOverlayLayer *_activeHighlightLayer;
    NSString *_highlightedLinkAttributeName;
    id _highlightedLinkAttributeValue;
}

+(Class)layerClass{
    return [MUAsyncDispalyLayer class];
}

- (instancetype)init{
    if (self = [super init]) {
        _asyncLayer = (MUAsyncDispalyLayer *)self.layer;
        _asyncLayer.asyncDelegate = self;
        _recursiveLock = [[NSRecursiveLock alloc]init];
        _attribute     = [[MUTextKitAttribute alloc]init];
        
        // Load default values
        [self _loadDefalutValues];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _asyncLayer = (MUAsyncDispalyLayer *)self.layer;
        _asyncLayer.asyncDelegate = self;
        _recursiveLock = [[NSRecursiveLock alloc]init];
        _attribute     = [[MUTextKitAttribute alloc]init];
        
        
          // Load default values
        [self _loadDefalutValues];
    }
    return self;
}
- (void)_loadDefalutValues{
    
    _maximumNumberOfLines = 1;
    _truncationMode = NSLineBreakByTruncatingTail;
    _shadowOffset = self.layer.shadowOffset;
    _shadowColor = CGColorRetain(self.layer.shadowColor);
    _shadowOpacity = self.layer.shadowOpacity;
    _shadowRadius = self.shadowRadius;
    
     self.linkAttributeNames = DefaultLinkAttributeNames;
}
-(void)willDisplayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer asynchously:(BOOL)asynchronously{
    
    // for async display, capture the current displaySentinel value to bail early when the job is executed if another is
    // enqueued
    // for sync display, do not support cancellation
    
    // FIXME: what about the degenerate case where we are calling setNeedsDisplay faster than the jobs are dequeuing
    // from the displayQueue?  Need to not cancel early fails from displaySentinel changes.
    asdisplaynode_iscancelled_block_t isCancelledBlock = nil;
    if (!asynchronously) {
        isCancelledBlock = ^BOOL{
            return NO;
        };
    }else{
        uint displaySentinelValue = ++_displaySentinel;
        isCancelledBlock = ^BOOL{
            return self == nil || (displaySentinelValue != self->_displaySentinel.load());
        };
    }
    asyncdisplay_async_transaction_operation_block_t displayBlock = [self _displayBlockWithAsynchronous:YES isCancelledBlock:nil ];
    asyncdisplay_async_transaction_operation_complection_block_t complectionBlock = ^(id<NSObject> value,BOOL canceled){
        
        if (!canceled) {
            asyncLayer.contentsScale = [self contentsScale];;
            UIImage *image = (UIImage *)value;
            asyncLayer.contents = (id)image.CGImage;
        }
    };
    MUAsyncTransaction *transaction = [[MUAsyncTransaction alloc] initWithCallbackQueue:dispatch_get_main_queue() completionBlock:nil];
    [transaction addAsyncOperationWithBlock:displayBlock priority:MUDefaultTransactionPriority queue:[MUAsyncDispalyLayer displayQueue] completion:complectionBlock];
    [[MUAsyncTransactionGroup mainTransactionGroup]addTransaction:transaction];
}

- (asyncdisplay_async_transaction_operation_block_t)_displayBlockWithAsynchronous:(BOOL)asynchronous
                                                                 isCancelledBlock:(asdisplaynode_iscancelled_block_t)isCancelledBlock
{
    asyncdisplay_async_transaction_operation_block_t displayBlock = nil;
    // We always create a graphics context, unless a -display method is used, OR if we are a subnode drawing into a rasterized parent
    BOOL opaque = self.layer.opaque;
    CGRect bounds = self.layer.bounds;
    CGFloat contentsScaleForDisplay = [self contentsScale];
    displayBlock = ^id{
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, contentsScaleForDisplay);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        UIImage *image = nil;
        
        MUTextKitRenderer *renderer = [self textKitRenderer];
        NSLog(@"maximumSize = %@",NSStringFromCGSize( [renderer maximumSize]));
        [renderer drawInContext:currentContext bounds:bounds];
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    };
    return displayBlock;
}

#pragma -mark MUAsyncDispalyLayerDelegate
-(void)displayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer asynchously:(BOOL)asyncronously{
    
}
-(void)cancelDisplayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer{
    _displaySentinel.fetch_add(1);
}

- (CGFloat)contentsScale
{
    
    static CGFloat __contentsScale = 1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __contentsScale = [UIScreen mainScreen].scale;
    });
    
    return __contentsScale;
}
-(void)setNeedsDisplay{
    [self.layer setNeedsDisplay];//没有这句，不会调用代理方法
}

#pragma mark - Shadow Properties

- (CGColorRef)shadowColor
{
    [_recursiveLock lock];
    CGColorRef shadowCorlor = _shadowColor;
    [_recursiveLock unlock];
    return shadowCorlor;
}

- (void)setShadowColor:(CGColorRef)shadowColor
{
    [_recursiveLock lock];

    if (_shadowColor != shadowColor && CGColorEqualToColor(shadowColor, _shadowColor) == NO) {
        CGColorRelease(_shadowColor);
        _shadowColor = CGColorRetain(shadowColor);
        _cachedShadowUIColor = [UIColor colorWithCGColor:shadowColor];
         [_recursiveLock unlock];

        [self setNeedsDisplay];
        return;
    }

     [_recursiveLock unlock];
}

- (CGSize)shadowOffset
{
    [_recursiveLock lock];
    CGSize shadowOffset = _shadowOffset;
    [_recursiveLock unlock];
    return shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    {
        [_recursiveLock lock];

        if (CGSizeEqualToSize(_shadowOffset, shadowOffset)) {
            [_recursiveLock unlock];
            return;
        }
        _shadowOffset = shadowOffset;
        [_recursiveLock unlock];
    }

    [self setNeedsDisplay];
}

- (CGFloat)shadowOpacity
{
    [_recursiveLock lock];
    CGFloat shadowOpacity = _shadowOpacity;
    [_recursiveLock unlock];

    return shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    {
        [_recursiveLock lock];

        if (_shadowOpacity == shadowOpacity) {
            [_recursiveLock unlock];
            return;
        }

        _shadowOpacity = shadowOpacity;
        [_recursiveLock unlock];
    }

    [self setNeedsDisplay];
}

- (CGFloat)shadowRadius
{
    [_recursiveLock lock];
    CGFloat shadowRadius = _shadowRadius;
    [_recursiveLock unlock];
    return shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    {
        [_recursiveLock lock];

        if (_shadowRadius == shadowRadius) {
            [_recursiveLock unlock];
            return;
        }

        _shadowRadius = shadowRadius;
        [_recursiveLock unlock];
    }

    [self setNeedsDisplay];
}

- (UIEdgeInsets)shadowPadding
{
    return [self shadowPaddingWithRenderer:[self textKitRenderer]];
}

- (UIEdgeInsets)shadowPaddingWithRenderer:(MUTextKitRenderer *)renderer
{
    [_recursiveLock lock];
    UIEdgeInsets shadowPadding = renderer.shadower.shadowPadding;
    [_recursiveLock unlock];

    return shadowPadding;
}

#pragma mark - Truncation Message

//static NSAttributedString *DefaultTruncationAttributedString()
//{
//    static NSAttributedString *defaultTruncationAttributedString;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaultTruncationAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"\u2026", @"Default truncation string")];
//    });
//    return defaultTruncationAttributedString;
//}

- (void)setTruncationAttributedText:(NSAttributedString *)truncationAttributedText
{
    {
        [_recursiveLock lock];
        if (MUObjectIsEqual(_truncationAttributedText, truncationAttributedText)) {
            [_recursiveLock unlock];
            return;
        }
        _truncationAttributedText = [truncationAttributedText copy];
        [_recursiveLock unlock];
    }
    
    [self _invalidateTruncationText];
}


- (void)setTruncationMode:(NSLineBreakMode)truncationMode
{
    {
        [_recursiveLock lock];
        if (_truncationMode == truncationMode) {
            [_recursiveLock unlock];
            return;
        }
        
        _truncationMode = truncationMode;
         [_recursiveLock unlock];
    }
    
    [self setNeedsDisplay];
}

- (BOOL)isTruncated
{
    [_recursiveLock lock];
    MUTextKitRenderer *renderer = [self textKitRenderer];
     [_recursiveLock unlock];
    return renderer.isTruncated;
}

- (void)setPointSizeScaleFactors:(NSArray *)pointSizeScaleFactors
{
    {
        [_recursiveLock lock];
        if ([_pointSizeScaleFactors isEqualToArray:pointSizeScaleFactors]) {
            [_recursiveLock unlock];
            return;
        }
        _pointSizeScaleFactors = pointSizeScaleFactors;
        [_recursiveLock unlock];
    }

    [self setNeedsDisplay];
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    {
        [_recursiveLock lock];
        if (_maximumNumberOfLines == maximumNumberOfLines) {
             [_recursiveLock unlock];
            return;
        }

        _maximumNumberOfLines = maximumNumberOfLines;
        [_recursiveLock unlock];
    }

    [self setNeedsDisplay];
}

- (NSUInteger)lineCount
{
    [_recursiveLock lock];
    NSUInteger count = [[self textKitRenderer] lineCount];
    [_recursiveLock unlock];
    return count;
}

#pragma mark - Renderer Management

- (MUTextKitRenderer *)textKitRenderer{
    if (!_textKitRenderer) {
        __block CGSize constrainedSize = CGSizeZero;
        if ([NSThread isMainThread]) {
            constrainedSize = self.frame.size;
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                constrainedSize = self.frame.size;
            });
        }
        constrainedSize.width -= (_textContainerInset.left + _textContainerInset.right);
        constrainedSize.height -= (_textContainerInset.top + _textContainerInset.bottom);
        
        _textKitRenderer = [[MUTextKitRenderer alloc]initWithTextKitAttributes:[self _rendererAttributes]  constrainedSize:constrainedSize];
    }
    return _textKitRenderer;
}
- (MUTextKitAttribute *)_rendererAttributes
{
    _attribute.attributedString = _attributedText;
    _attribute.truncationAttributedString = _truncationAttributedText;
    _attribute.maximumNumberOfLines = _maximumNumberOfLines;
    _attribute.exclusionPaths = _exclusionPaths;
    _attribute.pointSizeScaleFactors = _pointSizeScaleFactors;
    _attribute.shadowOffset = _shadowOffset;
    _attribute.shadowOpacity = _shadowOpacity;
    _attribute.shadowRadius = _shadowRadius;
    _attribute.shadowColor = _cachedShadowUIColor;

  
    return _attribute;
}
#pragma mark - Layout and Sizing

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    [_recursiveLock lock];;
    BOOL needsUpdate = !UIEdgeInsetsEqualToEdgeInsets(textContainerInset, _textContainerInset);
    if (needsUpdate) {
        _textContainerInset = textContainerInset;
    }
   [_recursiveLock unlock];
    
    if (needsUpdate) {
        [self setNeedsLayout];
    }
}

- (UIEdgeInsets)textContainerInset
{
    [_recursiveLock lock];
    UIEdgeInsets textContainerInset = _textContainerInset;
    [_recursiveLock unlock];
    return textContainerInset;
}
#pragma mark - Text Layout
- (void)setExclusionPaths:(NSArray *)exclusionPaths
{
    {
        [_recursiveLock lock];
        if (MUObjectIsEqual(exclusionPaths, _exclusionPaths)) {
            [_recursiveLock unlock];
            return;
        }
        
        _exclusionPaths = [exclusionPaths copy];
        [_recursiveLock unlock];
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (NSArray *)exclusionPaths
{
    [_recursiveLock lock];
    NSArray *exclusionPaths = [_exclusionPaths copy];
    [_recursiveLock unlock];
    return exclusionPaths;
}
#pragma mark - attributes
- (void)setAttributedText:(NSAttributedString *)attributedText{
    if (attributedText == nil) {
         attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
    }
    
    [_recursiveLock lock];
    if (MUObjectIsEqual(attributedText, _attributedText)) {
        [_recursiveLock unlock];
        return;
    }
     _attributedText = MUCleanseAttributedStringOfCoreTextAttributes(attributedText);
    //set value
    _attribute.attributedString = _attributedText;
    
    // Since truncation text matches style of attributedText, invalidate it now.
    [self _invalidateTruncationText];
    
    // Force display to create renderer with new size and redisplay with new string
    [self setNeedsDisplay];
}

-(NSAttributedString *)attributedText{
    
    [_recursiveLock lock];
    NSAttributedString *attributeString = [_attributedText copy];
    [_recursiveLock unlock];
    return attributeString;
}
#pragma mark - Truncation Message

- (void)_invalidateTruncationText
{
    {
        [_recursiveLock lock];
        _composedTruncationText = nil;
        [_recursiveLock unlock];
    }
    [self setNeedsDisplay];
    
}
static inline BOOL MUObjectIsEqual(id<NSObject> obj, id<NSObject> otherObj)
{
    return obj == otherObj || [obj isEqual:otherObj];
}

#pragma mark - Highlighting

- (MUTextNodeHighlightStyle)highlightStyle
{
    [_recursiveLock lock];
    MUTextNodeHighlightStyle highlightStyle = _highlightStyle;
    [_recursiveLock unlock];
    
    return highlightStyle;
}

- (void)setHighlightStyle:(MUTextNodeHighlightStyle)highlightStyle
{
    [_recursiveLock lock];
    
    _highlightStyle = highlightStyle;
    
    [_recursiveLock unlock];
}

- (NSRange)highlightRange
{
    return _highlightRange;
}

- (void)setHighlightRange:(NSRange)highlightRange
{
    [self setHighlightRange:highlightRange animated:NO];
}

- (void)setHighlightRange:(NSRange)highlightRange animated:(BOOL)animated
{
    [self _setHighlightRange:highlightRange forAttributeName:nil value:nil animated:animated];
}

- (void)_setHighlightRange:(NSRange)highlightRange forAttributeName:(NSString *)highlightedAttributeName value:(id)highlightedAttributeValue animated:(BOOL)animated
{
    _highlightedLinkAttributeName = highlightedAttributeName;
    _highlightedLinkAttributeValue = highlightedAttributeValue;
    
    if (!NSEqualRanges(highlightRange, _highlightRange) && ((0 != highlightRange.length) || (0 != _highlightRange.length))) {
        
        _highlightRange = highlightRange;
        
        if (_activeHighlightLayer) {
            if (animated) {
                __weak CALayer *weakHighlightLayer = _activeHighlightLayer;
                _activeHighlightLayer = nil;
                
                weakHighlightLayer.opacity = 0.0;
                
                CFTimeInterval beginTime = CACurrentMediaTime();
                CABasicAnimation *possibleFadeIn = (CABasicAnimation *)[weakHighlightLayer animationForKey:@"opacity"];
                if (possibleFadeIn) {
                    // Calculate when we should begin fading out based on the end of the fade in animation,
                    // Also check to make sure that the new begin time hasn't already passed
                    CGFloat newBeginTime = (possibleFadeIn.beginTime + possibleFadeIn.duration);
                    if (newBeginTime > beginTime) {
                        beginTime = newBeginTime;
                    }
                }
                
                CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
                fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                fadeOut.fromValue = possibleFadeIn.toValue ? : @(((CALayer *)weakHighlightLayer.presentationLayer).opacity);
                fadeOut.toValue = @0.0;
                fadeOut.fillMode = kCAFillModeBoth;
                fadeOut.duration = MUTextNodeHighlightFadeOutDuration;
                fadeOut.beginTime = beginTime;
                
                dispatch_block_t prev = [CATransaction completionBlock];
                [CATransaction setCompletionBlock:^{
                    [weakHighlightLayer removeFromSuperlayer];
                }];
                
                [weakHighlightLayer addAnimation:fadeOut forKey:fadeOut.keyPath];
                
                [CATransaction setCompletionBlock:prev];
                
            } else {
                [_activeHighlightLayer removeFromSuperlayer];
                _activeHighlightLayer = nil;
            }
        }
        if (0 != highlightRange.length) {
            // Find layer in hierarchy that allows us to draw highlighting on.
            CALayer *highlightTargetLayer = self.layer;
            
            if (highlightTargetLayer != nil) {
                [_recursiveLock lock];
                MUTextKitRenderer *renderer = [self textKitRenderer];
                [_recursiveLock unlock];
                
                NSArray *highlightRects = [renderer rectsForTextRange:highlightRange measureOption:MUTextKitRendererMeasureOptionBlock];
                NSMutableArray *converted = [NSMutableArray arrayWithCapacity:highlightRects.count];
                for (NSValue *rectValue in highlightRects) {
                    UIEdgeInsets shadowPadding = renderer.shadower.shadowPadding;
                    CGRect rendererRect = MUTextNodeAdjustRenderRectForShadowPadding(rectValue.CGRectValue, shadowPadding);
                    
                    // The rects returned from renderer don't have `textContainerInset`,
                    // as well as they are using the `constrainedSize` for layout,
                    // so we can simply increase the rect by insets to get the full blown layout.
                    rendererRect.size.width += _textContainerInset.left + _textContainerInset.right;
                    rendererRect.size.height += _textContainerInset.top + _textContainerInset.bottom;
                    
                    CGRect highlightedRect = [self.layer convertRect:rendererRect toLayer:highlightTargetLayer];
                    
                    // We set our overlay layer's frame to the bounds of the highlight target layer.
                    // Offset highlight rects to avoid double-counting target layer's bounds.origin.
                    highlightedRect.origin.x -= highlightTargetLayer.bounds.origin.x;
                    highlightedRect.origin.y -= highlightTargetLayer.bounds.origin.y;
                    [converted addObject:[NSValue valueWithCGRect:highlightedRect]];
                }
                
                MUHighlightOverlayLayer *overlayLayer = [[MUHighlightOverlayLayer alloc] initWithRects:converted];
                overlayLayer.highlightColor = [[self class] _highlightColorForStyle:self.highlightStyle];
                overlayLayer.frame = highlightTargetLayer.bounds;
                overlayLayer.masksToBounds = NO;
                overlayLayer.opacity = [[self class] _highlightOpacityForStyle:self.highlightStyle];
                [highlightTargetLayer addSublayer:overlayLayer];
                
                if (animated) {
                    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
                    fadeIn.fromValue = @0.0;
                    fadeIn.toValue = @(overlayLayer.opacity);
                    fadeIn.duration = MUTextNodeHighlightFadeInDuration;
                    fadeIn.beginTime = CACurrentMediaTime();
                    
                    [overlayLayer addAnimation:fadeIn forKey:fadeIn.keyPath];
                }
                
                [overlayLayer setNeedsDisplay];
                
                _activeHighlightLayer = overlayLayer;
            }
        }
    }
}
+ (CGFloat)_highlightOpacityForStyle:(MUTextNodeHighlightStyle)style
{
    return (style == MUTextNodeHighlightStyleLight) ? MUTextNodeHighlightLightOpacity : MUTextNodeHighlightDarkOpacity;
}

+ (CGColorRef)_highlightColorForStyle:(MUTextNodeHighlightStyle)style
{
    return [UIColor colorWithWhite:(style == MUTextNodeHighlightStyleLight ? 0.0 : 1.0) alpha:1.0].CGColor;
}
#pragma mark - Text rects

static CGRect MUTextNodeAdjustRenderRectForShadowPadding(CGRect rendererRect, UIEdgeInsets shadowPadding) {
    rendererRect.origin.x -= shadowPadding.left;
    rendererRect.origin.y -= shadowPadding.top;
    return rendererRect;
}

- (NSArray *)rectsForTextRange:(NSRange)textRange
{
    return [self _rectsForTextRange:textRange measureOption:MUTextKitRendererMeasureOptionCapHeight];
}

- (NSArray *)highlightRectsForTextRange:(NSRange)textRange
{
    return [self _rectsForTextRange:textRange measureOption:MUTextKitRendererMeasureOptionBlock];
}

- (NSArray *)_rectsForTextRange:(NSRange)textRange measureOption:(MUTextKitRendererMeasureOption)measureOption
{
   
    [_recursiveLock lock];
    NSArray *rects = [[self textKitRenderer] rectsForTextRange:textRange measureOption:measureOption];
    NSMutableArray *adjustedRects = [NSMutableArray array];
    
    for (NSValue *rectValue in rects) {
        CGRect rect = [rectValue CGRectValue];
        rect = MUTextNodeAdjustRenderRectForShadowPadding(rect, self.shadowPadding);
        
        NSValue *adjustedRectValue = [NSValue valueWithCGRect:rect];
        [adjustedRects addObject:adjustedRectValue];
    }
    [_recursiveLock unlock];
    return adjustedRects;
}

- (CGRect)trailingRect
{
     [_recursiveLock lock];
    
    CGRect rect = [[self textKitRenderer] trailingRect];
    [_recursiveLock unlock];
    return MUTextNodeAdjustRenderRectForShadowPadding(rect, self.shadowPadding);
}

- (CGRect)frameForTextRange:(NSRange)textRange
{
     [_recursiveLock lock];
     CGRect frame = [[self textKitRenderer] frameForTextRange:textRange];
      [_recursiveLock unlock];
    return MUTextNodeAdjustRenderRectForShadowPadding(frame, self.shadowPadding);
}
#pragma mark - Attributes

- (id)linkAttributeValueAtPoint:(CGPoint)point
                  attributeName:(out NSString **)attributeNameOut
                          range:(out NSRange *)rangeOut
{
    BOOL isTruncationStringTapped = NO;
    return [self _linkAttributeValueAtPoint:point
                              attributeName:attributeNameOut
                                      range:rangeOut
              inAdditionalTruncationMessage:NULL
                            forHighlighting:NO
            isTruncationStringTapped:&isTruncationStringTapped];
}

- (id)_linkAttributeValueAtPoint:(CGPoint)point
                   attributeName:(out NSString **)attributeNameOut
                           range:(out NSRange *)rangeOut
   inAdditionalTruncationMessage:(out BOOL *)inAdditionalTruncationMessageOut
                 forHighlighting:(BOOL)highlighting
                 isTruncationStringTapped:(BOOL *)truncationStringTapped
{

    [_recursiveLock lock];
    MUTextKitRenderer *renderer = [self textKitRenderer];
    NSRange visibleRange = renderer.firstVisibleRange;
    NSAttributedString *attributedString = _attributedText;
    NSAttributedString *truncationAttributedString = _truncationAttributedText;
    [_recursiveLock unlock];
    NSRange clampedRange = NSIntersectionRange(visibleRange, NSMakeRange(0, attributedString.length));
    
    // Check in a 9-point region around the actual touch point so we make sure
    // we get the best attribute for the touch.
    __block CGFloat minimumGlyphDistance = CGFLOAT_MAX;
    
    // Final output vars
    __block id linkAttributeValue = nil;
    __block BOOL inTruncationMessage = NO;
    
    [renderer enumerateTextIndexesAtPosition:point usingBlock:^(NSUInteger characterIndex, CGRect glyphBoundingRect, BOOL *stop) {
        CGPoint glyphLocation = CGPointMake(CGRectGetMidX(glyphBoundingRect), CGRectGetMidY(glyphBoundingRect));
        CGFloat currentDistance = sqrt(pow(point.x - glyphLocation.x, 2.f) + pow(point.y - glyphLocation.y, 2.f));
        if (currentDistance >= minimumGlyphDistance) {
            // If the distance computed from the touch to the glyph location is
            // not the minimum among the located link attributes, we can just skip
            // to the next location.
            return;
        }
        
        // Check if it's outside the visible range, if so, then we mark this touch
        // as inside the truncation message, because in at least one of the touch
        // points it was.
        if (!(NSLocationInRange(characterIndex, visibleRange))) {
            inTruncationMessage = YES;
        }
        
        if (inAdditionalTruncationMessageOut != NULL) {
            *inAdditionalTruncationMessageOut = inTruncationMessage;
        }
        
        // Short circuit here if it's just in the truncation message.  Since the
        // truncation message may be beyond the scope of the actual input string,
        // we have to make sure that we don't start asking for attributes on it.
        if (inTruncationMessage) {
            return;
        }
        
        for (NSString *attributeName in _linkAttributeNames) {
            NSRange range;
            id value  = [attributedString attribute:attributeName atIndex:characterIndex longestEffectiveRange:&range inRange:clampedRange];
            
            if (value == nil) {//末尾文字
                value = [truncationAttributedString attribute:attributeName atIndex:0 longestEffectiveRange:&range inRange:NSMakeRange(0, truncationAttributedString.string.length)];
                *truncationStringTapped = YES;
            }
            NSString *name = attributeName;
            
            if (value == nil || name == nil) {
                // Didn't find anything
                continue;
            }
            
            if (value != nil || name != nil) {
                // We found a minimum glyph distance link attribute, so set the min
                // distance, and the out params.
                minimumGlyphDistance = currentDistance;
                
                if (rangeOut != NULL && value != nil) {
                    *rangeOut = range;
                    // Limit to only the visible range, because the attributed string will
                    // return values outside the visible range.
                    if (NSMaxRange(*rangeOut) > NSMaxRange(visibleRange)) {
                        (*rangeOut).length = MAX(NSMaxRange(visibleRange) - (*rangeOut).location, 0);
                    }
                }
                
                if (attributeNameOut != NULL) {
                    if (*truncationStringTapped) {
                        *attributeNameOut = MUTextNodeTruncationTokenAttributeName;
                    }else{
                        *attributeNameOut = name;
                    }
                    
                }
                
                // Set the values for the next iteration
                linkAttributeValue = value;
                
                break;
            }
        }
    }];
    
    return linkAttributeValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    NSRange range = NSMakeRange(0, 0);
    NSString *linkAttributeName = nil;
    BOOL inAdditionalTruncationMessage = NO;
    BOOL isTruncationStringTapped = NO;
    id linkAttributeValue = [self _linkAttributeValueAtPoint:point
                                               attributeName:&linkAttributeName
                                                       range:&range
                               inAdditionalTruncationMessage:&inAdditionalTruncationMessage
                                             forHighlighting:YES
                             isTruncationStringTapped:&isTruncationStringTapped];
    
    NSUInteger lastCharIndex = NSIntegerMax;
    BOOL linkCrossesVisibleRange = (lastCharIndex > range.location) && (lastCharIndex < NSMaxRange(range) - 1);
    
  if (range.length && !linkCrossesVisibleRange && linkAttributeValue != nil && linkAttributeName != nil) {
      
      if (!isTruncationStringTapped) {
          
          [self _setHighlightRange:range forAttributeName:linkAttributeName value:linkAttributeValue animated:YES];
      }else{
          _highlightedLinkAttributeName = linkAttributeName;
          _highlightedLinkAttributeValue = linkAttributeValue;
      }
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self _clearHighlightIfNecessary];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([self _pendingLinkTap]&&self.tappedLinkAttribute) {
         CGPoint point = [[touches anyObject] locationInView:self];
        self.tappedLinkAttribute(_highlightedLinkAttributeName, _highlightedLinkAttributeValue, point, _highlightRange);
    }
    
    if ([self _pendingTruncationTap]&&self.textNodeTappedTruncationToken) {
        self.textNodeTappedTruncationToken();
    }
    
    [self _clearHighlightIfNecessary];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint locationInView = [touch locationInView:self];
    // on 3D Touch enabled phones, this gets fired with changes in force, and usually will get fired immediately after touchesBegan:withEvent:
    if (CGPointEqualToPoint([touch previousLocationInView:self], locationInView))
        return;
    BOOL isTruncationStringTapped = NO;
    // If touch has moved out of the current highlight range, clear the highlight.
    if (_highlightRange.length > 0) {
        NSRange range = NSMakeRange(0, 0);
        [self _linkAttributeValueAtPoint:locationInView
                           attributeName:NULL
                                   range:&range
           inAdditionalTruncationMessage:NULL
                         forHighlighting:YES
         isTruncationStringTapped:&isTruncationStringTapped];
        
        if (!NSEqualRanges(_highlightRange, range)) {
            [self _clearHighlightIfNecessary];
        }
    }
}
///**
// * @return the additional truncation message range within the as-rendered text.
// * Must be called from main thread
// */
//- (NSRange)_additionalTruncationMessageRangeWithVisibleRange:(NSRange)visibleRange
//{
//    [_recursiveLock lock];
//
//    // Check if we even have an additional truncation message.
//    if (!_additionalTruncationMessage) {
//        return NSMakeRange(NSNotFound, 0);
//    }
//
//    // Character location of the unicode ellipsis (the first index after the visible range)
//    NSInteger truncationTokenIndex = NSMaxRange(visibleRange);
//
//    NSUInteger additionalTruncationMessageLength = _additionalTruncationMessage.length;
//    // We get the location of the truncation token, then add the length of the
//    // truncation attributed string +1 for the space between.
//    NSRange range = NSMakeRange(truncationTokenIndex + _truncationAttributedText.length + 1, additionalTruncationMessageLength);
//    [_recursiveLock unlock];
//
//    return range;
//}
- (void)_clearHighlightIfNecessary
{
    if ([self _pendingLinkTap] || [self _pendingTruncationTap]) {
        [self setHighlightRange:NSMakeRange(0, 0) animated:YES];
    }
}

- (BOOL)_pendingLinkTap
{
    return (_highlightedLinkAttributeValue != nil && ![self _pendingTruncationTap]);
}

- (BOOL)_pendingTruncationTap
{

    return [_highlightedLinkAttributeName isEqualToString:MUTextNodeTruncationTokenAttributeName];
}
- (void)tappedLinkAttribute:(NSString *)linkText tappedBlock:(void (^)(NSString * _Nonnull, CGPoint * _Nonnull, NSRange))block{
//    _attributedText
}

- (CGSize)intrinsicContentSize{
    
    [_recursiveLock lock];
    CGSize size = [[self textKitRenderer]maximumSize];
    [_recursiveLock unlock];
    return size;
}
@end

