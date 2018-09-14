//
//  MUTextKitNode.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 2018/9/7.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 * Highlight styles.
 */
typedef NS_ENUM(NSUInteger, MUTextNodeHighlightStyle) {
    /**
     * Highlight style for text on a light background.
     */
    MUTextNodeHighlightStyleLight,
    
    /**
     * Highlight style for text on a dark background.
     */
    MUTextNodeHighlightStyleDark
};

NS_ASSUME_NONNULL_BEGIN
@interface MUTextKitNode : UIView

/**
 @abstract The styled text displayed by the node.
 @discussion Defaults to nil, no text is shown.
 For inline image attachments, add an attribute of key NSAttachmentAttributeName, with a value of an NSTextAttachment.
 */
@property (nullable, nonatomic, copy) NSAttributedString *attributedText;

#pragma mark - Truncation

/**
 @abstract The attributedText to use when the text must be truncated.
 @discussion Defaults to a localized ellipsis character.
 */
@property (nullable, nonatomic, copy) NSAttributedString *truncationAttributedText;

/**
 @abstract Determines how the text is truncated to fit within the receiver's maximum size.
 @discussion Defaults to NSLineBreakByWordWrapping.
 @note Setting a truncationMode in attributedString will override the truncation mode set here.
 */
@property (nonatomic, assign) NSLineBreakMode truncationMode;

/**
 @abstract If the text node is truncated. Text must have been sized first.
 */
@property (nonatomic, readonly, assign, getter=isTruncated) BOOL truncated;

/**
 @abstract The maximum number of lines to render of the text before truncation.
 @default 0 (No limit)
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfLines;

/**
 @abstract The number of lines in the text. Text must have been sized first.
 */
@property (nonatomic, readonly, assign) NSUInteger lineCount;

/**
 * An array of path objects representing the regions where text should not be displayed.
 *
 * @discussion The default value of this property is an empty array. You can
 * assign an array of UIBezierPath objects to exclude text from one or more regions in
 * the text node's bounds. You can use this property to have text wrap around images,
 * shapes or other text like a fancy magazine.
 */
@property (nullable, nonatomic, strong) NSArray<UIBezierPath *> *exclusionPaths;

/**
 @abstract An array of descending scale factors that will be applied to this text node to try to make it fit within its constrained size
 @discussion This array should be in descending order and NOT contain the scale factor 1.0. For example, it could return @[@(.9), @(.85), @(.8)];
 @default nil (no scaling)
 */
@property (nullable, nonatomic, copy) NSArray<NSNumber *> *pointSizeScaleFactors;

/**
 @abstract Text margins for text laid out in the text node.
 @discussion defaults to UIEdgeInsetsZero.
 This property can be useful for handling text which does not fit within the view by default. An example: like UILabel,
 ASTextNode will clip the left and right of the string "judar" if it's rendered in an italicised font.
 */
@property (nonatomic, assign) UIEdgeInsets textContainerInset;

@property (nonatomic, assign, nullable) CGColorRef shadowColor;                // default=opaque rgb black
@property (nonatomic, assign)           CGFloat shadowOpacity;                 // default=0.0
@property (nonatomic, assign)           CGSize shadowOffset;                   // default=(0, -3)
@property (nonatomic, assign)           CGFloat shadowRadius;                  // default=3
@property (nonatomic,assign) CGFloat preferredMaxLayoutWidth;
@property (nonatomic,assign) BOOL isUsedAutoLayout;


#pragma mark - Fitting
- (CGSize)sizeToFit;

#pragma mark - Actions

/**
 @abstract The set of attribute names to consider links.  Defaults to NSLinkAttributeName.
 */
@property (nonatomic, copy) NSArray<NSString *> *linkAttributeNames;

/**
 @abstract Indicates whether the receiver has an entity at a given point.
 @param point The point, in the receiver's coordinate system.
 @param attributeNameOut The name of the attribute at the point. Can be NULL.
 @param rangeOut The ultimate range of the found text. Can be NULL.
 @result YES if an entity exists at `point`; NO otherwise.
 */
- (nullable id)linkAttributeValueAtPoint:(CGPoint)point attributeName:(out NSString * _Nullable * _Nullable)attributeNameOut range:(out NSRange * _Nullable)rangeOut;
/**
 @abstract The style to use when highlighting text.
 */
@property (nonatomic, assign) MUTextNodeHighlightStyle highlightStyle;

/**
 @abstract The range of text highlighted by the receiver. Changes to this property are not animated by default.
 */
@property (nonatomic, assign) NSRange highlightRange;

/**
 @abstract Set the range of text to highlight, with optional animation.
 
 @param highlightRange The range of text to highlight.
 
 @param animated Whether the text should be highlighted with an animation.
 */
- (void)setHighlightRange:(NSRange)highlightRange animated:(BOOL)animated;

#pragma mark - Positioning

/**
 @abstract Returns an array of rects bounding the characters in a given text range.
 @param textRange A range of text. Must be valid for the receiver's string.
 @discussion Use this method to detect all the different rectangles a given range of text occupies.
 The rects returned are not guaranteed to be contiguous (for example, if the given text range spans
 a line break, the rects returned will be on opposite sides and different lines). The rects returned
 are in the coordinate system of the receiver.
 */
- (NSArray<NSValue *> *)rectsForTextRange:(NSRange)textRange ;

/**
 @abstract Returns an array of rects used for highlighting the characters in a given text range.
 @param textRange A range of text. Must be valid for the receiver's string.
 @discussion Use this method to detect all the different rectangles the highlights of a given range of text occupies.
 The rects returned are not guaranteed to be contiguous (for example, if the given text range spans
 a line break, the rects returned will be on opposite sides and different lines). The rects returned
 are in the coordinate system of the receiver. This method is useful for visual coordination with a
 highlighted range of text.
 */
- (NSArray<NSValue *> *)highlightRectsForTextRange:(NSRange)textRange ;

/**
 @abstract Returns a bounding rect for the given text range.
 @param textRange A range of text. Must be valid for the receiver's string.
 @discussion The height of the frame returned is that of the receiver's line-height; adjustment for
 cap-height and descenders is not performed. This method raises an exception if textRange is not
 a valid substring range of the receiver's string.
 */
- (CGRect)frameForTextRange:(NSRange)textRange ;

/**
 @abstract Returns the trailing rectangle of space in the receiver, after the final character.
 @discussion Use this method to detect which portion of the receiver is not occupied by characters.
 The rect returned is in the coordinate system of the receiver.
 */
- (CGRect)trailingRect ;

#pragma mark - Placeholders

/**
 * @abstract ASTextNode has a special placeholder behavior when placeholderEnabled is YES.
 *
 * @discussion Defaults to NO.  When YES, it draws rectangles for each line of text,
 * following the true shape of the text's wrapping.  This visually mirrors the overall
 * shape and weight of paragraphs, making the appearance of the finished text less jarring.
 */
@property (nonatomic, assign) BOOL placeholderEnabled;

/**
 @abstract The placeholder color.
 */
@property (nullable, nonatomic, strong) UIColor *placeholderColor;

/**
 @abstract Inset each line of the placeholder.
 */
@property (nonatomic, assign) UIEdgeInsets placeholderInsets;
/**
 @abstract Indicates to the delegate that a link was tapped within a text node.
  attribute The attribute that was tapped. Will not be nil.
  value The value of the tapped attribute.
  point The point within textNode, in textNode's coordinate system, that was tapped.
  textRange The range of highlighted text.
 */
@property (nonatomic,copy)  void (^tappedLinkAttribute)(NSString *attribute,id value,CGPoint point ,NSRange textRange);
@property (nonatomic,copy) void (^textNodeTappedTruncationToken)(void);


@end
NS_ASSUME_NONNULL_END
