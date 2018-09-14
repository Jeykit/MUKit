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
#import "MUTextKitRenderer.h"
#import "MUTextKitCoreTextAdditions.h"
#import "MUTextKitAttribute.h"
#import "MUHighlightOverlayLayer.h"
#import "MUTextKitRenderer+Positioning.h"
#import "MUSentinel.h"

#import <objc/runtime.h>

#define MU_TEXTNODE_RECORD_ATTRIBUTED_STRINGS 0
typedef BOOL(^asdisplaynode_iscancelled_block_t)(void);
#define MUAsyncTransactionAssertMainThread() NSAssert(0 != pthread_main_np(), @"This method must be called on the main thread");

UIColor *MUDisplayNodeDefaultPlaceholderColor()
{
    static UIColor *defaultPlaceholderColor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultPlaceholderColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    });
    return defaultPlaceholderColor;
}

static const NSTimeInterval MUTextNodeHighlightFadeOutDuration = 0.15;
static const NSTimeInterval MUTextNodeHighlightFadeInDuration = 0.1;
static const CGFloat MUTextNodeHighlightLightOpacity = 0.11;
static const CGFloat MUTextNodeHighlightDarkOpacity = 0.22;
static NSString *MUTextNodeTruncationTokenAttributeName = @"MUTextNodeTruncationAttribute";


@interface MUTextKitNode()<MUAsyncDispalyLayerDelegate>
@property (nonatomic,strong) MUTextKitRenderer *textKitRenderer;
@end

@implementation MUTextKitNode{
    MUAsyncDispalyLayer *_asyncLayer;
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
    
    CGSize _intrinsicContentSize;
    
    CGFloat _preferredMaxLayoutWidth;
    BOOL _isUsedAutoLayout;
    MUSentinel *_sentinel;
    
    NSArray * DefaultLinkAttributeNames;
    CGSize _constrainedSize;
    UIImage *_placeholderImage;
    CALayer *_placeholderLayer;
    
}

+(Class)layerClass{
    return [MUAsyncDispalyLayer class];
}

- (instancetype)init{
    _constrainedSize = CGSizeZero;
    if (self = [super init]) {
        // Load default values
        [self _loadDefalutValues];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    _constrainedSize = frame.size;
    if (self = [super initWithFrame:frame]) {
        // Load default values
        [self _loadDefalutValues];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    _constrainedSize = CGSizeZero;
    if (self = [super initWithCoder:aDecoder]) {
        
        // Load default values
        [self _loadDefalutValues];
    }
    
    return self;
}

- (void)_setNeedsRedraw{
    
    [self.layer setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
    
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
}
- (void)setFrame:(CGRect)frame {
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        _constrainedSize = newSize;
        [self _setNeedsRedraw];
    }
}

- (void)_clearContents {
    CGImageRef image = (__bridge_retained CGImageRef)(self.layer.contents);
    self.layer.contents = nil;
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CFRelease(image);
        });
    }
}

- (void)_loadDefalutValues{
    
    
    
    _sentinel = [MUSentinel new];
    DefaultLinkAttributeNames = @[ NSLinkAttributeName];
    
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];
    [self setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self setContentCompressionResistancePriority:750 forAxis:UILayoutConstraintAxisVertical];
    [self setContentCompressionResistancePriority:750 forAxis:UILayoutConstraintAxisHorizontal];
    
    
    _asyncLayer = (MUAsyncDispalyLayer *)self.layer;
    _asyncLayer.asyncDelegate = self;
    
    _maximumNumberOfLines = 1;
    _truncationMode = NSLineBreakByTruncatingTail;
    _shadowOffset = self.layer.shadowOffset;
    _shadowColor = CGColorRetain(self.layer.shadowColor);
    _shadowOpacity = self.layer.shadowOpacity;
    _shadowRadius = self.shadowRadius;
    
    self.linkAttributeNames = DefaultLinkAttributeNames;
    _intrinsicContentSize = CGSizeZero;
    
    // Placeholders
    // Disabled by default in ASDisplayNode, but add a few options for those who toggle
    // on the special placeholder behavior of ASTextNode.
    _placeholderColor = MUDisplayNodeDefaultPlaceholderColor();
    _placeholderInsets = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0);
}

#pragma mark - layer delegate
-(void)willDisplayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer asynchously:(BOOL)asynchronously{
    
    // for async display, capture the current displaySentinel value to bail early when the job is executed if another is
    // enqueued
    // for sync display, do not support cancellation
    
    // FIXME: what about the degenerate case where we are calling setNeedsDisplay faster than the jobs are dequeuing
    // from the displayQueue?  Need to not cancel early fails from displaySentinel changes.
    
    if (_isUsedAutoLayout && _preferredMaxLayoutWidth <= 0) {
        if (!objc_getAssociatedObject(self, _cmd)) {
            NSLog(@"[MUTextKitNode] you have to set 'preferredMaxLayoutWidth' value greater than 0 when used AutoLayout");
            objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        return;
    }
    if (!_isUsedAutoLayout && CGSizeEqualToSize(_constrainedSize, CGSizeZero)) {
        if (!objc_getAssociatedObject(self, _cmd)) {
            NSLog(@"[MUTextKitNode]  Size of frame will not be CGSizeZero");
            objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        return;
    }
     [self _clearContents];//clear contents when redraw
    // We generate placeholders at measureWithSizeRange: time so that a node is guaranteed to have a placeholder ready to go.
    // This is also because measurement is usually asynchronous, but placeholders need to be set up synchronously.
    // First measurement is guaranteed to be before the node is onscreen, so we can create the image async. but still have it appear sync.
    if (_placeholderEnabled && !_placeholderImage ) {
        
        // Zero-sized nodes do not require a placeholder.
        CGSize layoutSize = _constrainedSize;
        if (layoutSize.width * layoutSize.height > 0.0) {
            _placeholderImage = [self placeholderImage];
            self.layer.contents = _placeholderImage;
        }
    }
    asdisplaynode_iscancelled_block_t isCancelledBlock = nil;
    if (!asynchronously) {
        isCancelledBlock = ^BOOL{
            return NO;
        };
    }else{
        MUSentinel *sentinel = _sentinel;
        [sentinel increase];
        int32_t value = sentinel.value;
        isCancelledBlock = ^BOOL{
            return self == nil || (value != sentinel.value);
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
    //    BOOL opaque = self.layer.opaque;
    CGRect bounds = self.layer.bounds;
    CGFloat contentsScaleForDisplay = [self contentsScale];
    displayBlock = ^id{
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, contentsScaleForDisplay);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        UIImage *image = nil;
        
        MUTextKitRenderer *renderer = [self textKitRenderer];
        [renderer updateAttributesNow];
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
    [_sentinel increase];
}

#pragma mark -Fitting
- (CGSize)sizeToFit{
    
    _constrainedSize = CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX);
    [[self textKitRenderer] updateAttributesNow];
    CGSize contentSize = [[self textKitRenderer] maximumSize];
    CGRect contentFrame = self.frame;
    contentFrame.size = contentSize;
    self.frame = contentFrame;
    return contentSize;
}
- (void)setIsUsedAutoLayout:(BOOL)isUsedAutoLayout{
    _isUsedAutoLayout = isUsedAutoLayout;
    if (isUsedAutoLayout) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth{
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
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

#pragma mark - Shadow Properties

- (CGColorRef)shadowColor
{
    CGColorRef shadowCorlor = _shadowColor;
    return shadowCorlor;
}

- (void)setShadowColor:(CGColorRef)shadowColor
{
    
    if (_shadowColor != shadowColor && CGColorEqualToColor(shadowColor, _shadowColor) == NO) {
        CGColorRelease(_shadowColor);
        _shadowColor = CGColorRetain(shadowColor);
        _cachedShadowUIColor = [UIColor colorWithCGColor:shadowColor];
        
        
        [self _setNeedsRedraw];
        return;
    }
}

- (CGSize)shadowOffset
{
    CGSize shadowOffset = _shadowOffset;
    return shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    {
        
        if (CGSizeEqualToSize(_shadowOffset, shadowOffset)) {
            return;
        }
        _shadowOffset = shadowOffset;
    }
    
    [self _setNeedsRedraw];
}

- (CGFloat)shadowOpacity
{
    CGFloat shadowOpacity = _shadowOpacity;
    
    return shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    {
        
        if (_shadowOpacity == shadowOpacity) {
            return;
        }
        
        _shadowOpacity = shadowOpacity;
    }
    
    [self _setNeedsRedraw];
}

- (CGFloat)shadowRadius
{
    CGFloat shadowRadius = _shadowRadius;
    return shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    {
        
        if (_shadowRadius == shadowRadius) {
            return;
        }
        _shadowRadius = shadowRadius;
    }
    
    [self _setNeedsRedraw];
}

- (UIEdgeInsets)shadowPadding
{
    return [self shadowPaddingWithRenderer:[self textKitRenderer]];
}

- (UIEdgeInsets)shadowPaddingWithRenderer:(MUTextKitRenderer *)renderer
{
    UIEdgeInsets shadowPadding = renderer.shadower.shadowPadding;
    
    return shadowPadding;
}

#pragma mark - Truncation Message
- (void)setTruncationAttributedText:(NSAttributedString *)truncationAttributedText
{
    {
        if (MUObjectIsEqual(_truncationAttributedText, truncationAttributedText)) {
            return;
        }
        _truncationAttributedText = [truncationAttributedText copy];
    }
    
    [self _invalidateTruncationText];
}


- (void)setTruncationMode:(NSLineBreakMode)truncationMode
{
    {
        if (_truncationMode == truncationMode) {
            return;
        }
        
        _truncationMode = truncationMode;
    }
    
    [self _setNeedsRedraw];
}

- (BOOL)isTruncated
{
    MUTextKitRenderer *renderer = [self textKitRenderer];
    return renderer.isTruncated;
}

- (void)setPointSizeScaleFactors:(NSArray *)pointSizeScaleFactors
{
    {
        if ([_pointSizeScaleFactors isEqualToArray:pointSizeScaleFactors]) {
            return;
        }
        _pointSizeScaleFactors = pointSizeScaleFactors;
    }
    
    [self _setNeedsRedraw];
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    {
        if (_maximumNumberOfLines == maximumNumberOfLines) {
            return;
        }
        _maximumNumberOfLines = maximumNumberOfLines;
    }
    
    [self _setNeedsRedraw];
}

- (NSUInteger)lineCount
{
    NSUInteger count = [[self textKitRenderer] lineCount];
    return count;
}

#pragma mark - Renderer Management

- (MUTextKitRenderer *)textKitRenderer{
    if (!_textKitRenderer) {
        CGSize constrainedSize = _constrainedSize;
        constrainedSize.width -= (_textContainerInset.left + _textContainerInset.right);
        constrainedSize.height -= (_textContainerInset.top + _textContainerInset.bottom);
        if (_preferredMaxLayoutWidth > 0) {
            _preferredMaxLayoutWidth -= (_textContainerInset.left + _textContainerInset.right);
        }
        MUTextKitAttribute *atturibute = [self _rendererAttributes:nil];
        atturibute.constrainedSize = constrainedSize;
        atturibute.preferredMaxLayoutWidth = _preferredMaxLayoutWidth;
        _textKitRenderer = [[MUTextKitRenderer alloc]initWithTextKitAttributes:atturibute  constrainedSize:constrainedSize];
    }else{
        MUTextKitAttribute *attribute = _textKitRenderer.arrtribute;
        [self _rendererAttributes:attribute];
        CGSize constrainedSize = _constrainedSize;
        constrainedSize.width -= (_textContainerInset.left + _textContainerInset.right);
        if (_preferredMaxLayoutWidth > 0) {
            _preferredMaxLayoutWidth -= (_textContainerInset.left + _textContainerInset.right);
        }
        attribute.preferredMaxLayoutWidth = _preferredMaxLayoutWidth;
        constrainedSize.height -= (_textContainerInset.top + _textContainerInset.bottom);
        attribute.constrainedSize = constrainedSize;
        
    }
    return _textKitRenderer;
}
- (MUTextKitAttribute *)_rendererAttributes:(MUTextKitAttribute *)_attribute
{
    
    if (!_attribute) {
        _attribute = [[MUTextKitAttribute alloc]init];
    }
    _attribute.attributedString = _attributedText;
    _attribute.truncationAttributedString = _truncationAttributedText;
    _attribute.maximumNumberOfLines = _maximumNumberOfLines;
    _attribute.exclusionPaths = _exclusionPaths;
    _attribute.pointSizeScaleFactors = _pointSizeScaleFactors;
    _attribute.shadowOffset = _shadowOffset;
    _attribute.shadowOpacity = _shadowOpacity;
    _attribute.shadowRadius = _shadowRadius;
    _attribute.shadowColor = _cachedShadowUIColor;
    _attribute.isUsedAutoLayout = _isUsedAutoLayout;
    _attribute.preferredMaxLayoutWidth = _preferredMaxLayoutWidth;
    
    
    return _attribute;
}
#pragma mark - Layout and Sizing

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    BOOL needsUpdate = !UIEdgeInsetsEqualToEdgeInsets(textContainerInset, _textContainerInset);
    if (needsUpdate) {
        _textContainerInset = textContainerInset;
    }
    
    if (needsUpdate) {
        [self _setNeedsRedraw];
    }
}

- (UIEdgeInsets)textContainerInset
{
    UIEdgeInsets textContainerInset = _textContainerInset;
    return textContainerInset;
}
#pragma mark - Text Layout
- (void)setExclusionPaths:(NSArray *)exclusionPaths
{
    {
        if (MUObjectIsEqual(exclusionPaths, _exclusionPaths)) {
            return;
        }
        
        _exclusionPaths = [exclusionPaths copy];
    }
    
    [self _setNeedsRedraw];
}

- (NSArray *)exclusionPaths
{
    NSArray *exclusionPaths = [_exclusionPaths copy];
    return exclusionPaths;
}
#pragma mark - attributes
- (void)setAttributedText:(NSAttributedString *)attributedText{
    if (attributedText == nil) {
        attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
    }
    
    if (MUObjectIsEqual(attributedText, _attributedText)) {
        return;
    }
    _attributedText = MUCleanseAttributedStringOfCoreTextAttributes(attributedText);
    _highlightedLinkAttributeName = nil;
    _highlightedLinkAttributeValue = nil;
    // Since truncation text matches style of attributedText, invalidate it now.
    [self _invalidateTruncationText];
    
    // Force display to create renderer with new size and redisplay with new string
    [self _setNeedsRedraw];
}

-(NSAttributedString *)attributedText{
    
    NSAttributedString *attributeString = [_attributedText copy];
    if (!attributeString) {
        attributeString = [[NSAttributedString alloc] initWithString:@"" attributes:nil];
    }
    return attributeString;
}


#pragma mark - Truncation Message

- (void)_invalidateTruncationText
{
    {
        _composedTruncationText = nil;
    }
    [self _setNeedsRedraw];
    
}
static inline BOOL MUObjectIsEqual(id<NSObject> obj, id<NSObject> otherObj)
{
    return obj == otherObj || [obj isEqual:otherObj];
}

#pragma mark - Highlighting

- (MUTextNodeHighlightStyle)highlightStyle
{
    MUTextNodeHighlightStyle highlightStyle = _highlightStyle;
    
    return highlightStyle;
}

- (void)setHighlightStyle:(MUTextNodeHighlightStyle)highlightStyle
{
    _highlightStyle = highlightStyle;
    
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
                
                MUTextKitRenderer *renderer = [self textKitRenderer];
                
                
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
    
    NSArray *rects = [[self textKitRenderer] rectsForTextRange:textRange measureOption:measureOption];
    NSMutableArray *adjustedRects = [NSMutableArray array];
    
    for (NSValue *rectValue in rects) {
        CGRect rect = [rectValue CGRectValue];
        rect = MUTextNodeAdjustRenderRectForShadowPadding(rect, self.shadowPadding);
        
        NSValue *adjustedRectValue = [NSValue valueWithCGRect:rect];
        [adjustedRects addObject:adjustedRectValue];
    }
    return adjustedRects;
}

- (CGRect)trailingRect
{
    
    CGRect rect = [[self textKitRenderer] trailingRect];
    return MUTextNodeAdjustRenderRectForShadowPadding(rect, self.shadowPadding);
}

- (CGRect)frameForTextRange:(NSRange)textRange
{
    CGRect frame = [[self textKitRenderer] frameForTextRange:textRange];
    return MUTextNodeAdjustRenderRectForShadowPadding(frame, self.shadowPadding);
}

#pragma mark - Placeholders

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{

    _placeholderColor = placeholderColor;
    
    // prevent placeholders if we don't have a color
    self.placeholderEnabled = placeholderColor != nil;
}

- (UIImage *)placeholderImage
{
    // FIXME: Replace this implementation with reusable CALayers that have .backgroundColor set.
    // This would completely eliminate the memory and performance cost of the backing store.
    CGSize size = _constrainedSize;
    if ((size.width * size.height) < DBL_EPSILON) {
        return nil;
    }
    
    
    UIGraphicsBeginImageContext(size);
    [self.placeholderColor setFill];
    
    MUTextKitRenderer *renderer = [self textKitRenderer];
    NSRange visibleRange = renderer.firstVisibleRange;
    
    // cap height is both faster and creates less subpixel blending
    NSArray *lineRects = [self _rectsForTextRange:visibleRange measureOption:MUTextKitRendererMeasureOptionLineHeight];
    
    // fill each line with the placeholder color
    for (NSValue *rectValue in lineRects) {
        CGRect lineRect = [rectValue CGRectValue];
        CGRect fillBounds = CGRectIntegral(UIEdgeInsetsInsetRect(lineRect, self.placeholderInsets));
        
        if (fillBounds.size.width > 0.0 && fillBounds.size.height > 0.0) {
            UIRectFill(fillBounds);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
    
    MUTextKitRenderer *renderer = [self textKitRenderer];
    NSRange visibleRange = renderer.firstVisibleRange;
    NSAttributedString *attributedString = _attributedText;
    NSAttributedString *truncationAttributedString = _truncationAttributedText;
    NSRange clampedRange = NSIntersectionRange(visibleRange, NSMakeRange(0, attributedString.length));
    
    // Check in a 9-point region around the actual touch point so we make sure
    // we get the best attribute for the touch.
    __block CGFloat minimumGlyphDistance = CGFLOAT_MAX;
    
    // Final output vars
    __block id linkAttributeValue = nil;
    __block BOOL inTruncationMessage = NO;
    
    __weak typeof(self)weakSelf = self;
    [renderer enumerateTextIndexesAtPosition:point usingBlock:^(NSUInteger characterIndex, CGRect glyphBoundingRect, BOOL *stop) {
        __strong typeof(weakSelf)self = weakSelf;
        
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
        for (NSString *attributeName in self.linkAttributeNames) {
            NSRange range;
            id value  = [attributedString attribute:attributeName atIndex:characterIndex longestEffectiveRange:&range inRange:clampedRange];
            
            if (value == nil&&characterIndex < clampedRange.length) {//末尾文字
                NSString *subString = [attributedString.string substringWithRange:NSMakeRange(characterIndex, clampedRange.length - characterIndex)];
                
                value = [truncationAttributedString attribute:attributeName atIndex:0 longestEffectiveRange:&range inRange:NSMakeRange(0, truncationAttributedString.string.length)];
                NSString *string = value;
                if ([string containsString:subString]) {
                    
                    *truncationStringTapped = YES;
                }else{
                    *truncationStringTapped = NO;
                    value = nil;
                }
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
- (CGSize)intrinsicContentSize{
    
    if (self.translatesAutoresizingMaskIntoConstraints) {
        return CGSizeZero;
    }
    CGSize size = _intrinsicContentSize;
    if (!CGSizeEqualToSize(_constrainedSize, self.frame.size)) {
        [[self textKitRenderer] updateAttributesNow];
        _intrinsicContentSize  = [[self textKitRenderer]maximumSize];
        size = _intrinsicContentSize;
        
    }
    
    return size;
}
@end

