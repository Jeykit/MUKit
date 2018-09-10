//
//  MUTextKitAttribute.h
//  MUKit_Example
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUTextKitAttribute : NSObject
/**
 The string to be drawn.  MUTextKit will not augment this string with default colors, etc. so this must be complete.
 */
@property (nonatomic,copy) NSAttributedString *attributedString;
/**
 The string to use as the truncation string, usually just "...".  If you have a range of text you would like to
 restrict highlighting to (for instance if you have "... Continue Reading", use the ASTextKitTruncationAttributeName
 to mark the specific range of the string that should be highlightable.
 */
@property (nonatomic,copy) NSAttributedString *truncationAttributedString;
/**
 This is the character set that ASTextKit should attempt to avoid leaving as a trailing character before your
 truncation token.  By default this set includes "\s\t\n\r.,!?:;" so you don't end up with ugly looking truncation
 text like "Hey, this is some fancy Truncation!\n\n...".  Instead it would be truncated as "Hey, this is some fancy
 truncation...".  This is not always possible.
 
 Set this to the empty charset if you want to just use the "dumb" truncation behavior.  A nil value will be
 substituted with the default described above.
 */
@property (nonatomic,strong) NSCharacterSet *avoidTailTruncationSet;
/**
 The line-break mode to apply to the text.  Since this also impacts how TextKit will attempt to truncate the text
 in your string, we only support NSLineBreakByWordWrapping and NSLineBreakByCharWrapping.
 */
@property (nonatomic,assign) NSLineBreakMode lineBreakMode;
/**
 The maximum number of lines to draw in the drawable region.  Leave blank or set to 0 to define no maximum.
 This is required to apply scale factors to shrink text to fit within a number of lines
 */
@property (nonatomic,assign) NSUInteger maximumNumberOfLines;
/**
 An array of UIBezierPath objects representing the exclusion paths inside the receiver's bounding rectangle. Default value: nil.
 */
@property (nonatomic,strong) NSArray<UIBezierPath *> *exclusionPaths;
/**
 The shadow offset for any shadows applied to the text.  The coordinate space for this is the same as UIKit, so a
 positive width means towards the right, and a positive height means towards the bottom.
 */
@property (nonatomic,assign) CGSize shadowOffset;
/**
 The color to use in drawing the text's shadow.
 */
@property (nonatomic,strong) UIColor *shadowColor;
/**
 The opacity of the shadow from 0 to 1.
 */
@property (nonatomic,assign) CGFloat shadowOpacity;
/**
 The radius that should be applied to the shadow blur.  Larger values mean a larger, more blurred shadow.
 */
@property (nonatomic,assign) CGFloat shadowRadius;
/**
 An array of scale factors in descending order to apply to the text to try to make it fit into a constrained size.
 */
@property (nonatomic,strong) NSArray *pointSizeScaleFactors;

@property (nonatomic,assign) CGSize constrainedSize;

@property (nonatomic,assign) CGFloat preferredMaxLayoutWidth;

@property (nonatomic,assign) BOOL isUsedAutoLayout;

@end
