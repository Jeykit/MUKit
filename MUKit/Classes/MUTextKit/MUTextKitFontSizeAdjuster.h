//
//  MUTextKitFontSizeAdjuster.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUTextKitAttribute.h"

@class MUTextKitContext;
@interface MUTextKitFontSizeAdjuster : NSObject

@property (nonatomic, assign) CGSize constrainedSize;
/**
 *  Creates a class that will return a scale factor the will make a string fit inside the constrained size.
 *
 *  "Fitting" means that both the longest word in the string will fit without breaking in the constrained
 *  size's width AND that the entire string will try to fit within attribute's maximumLineCount. The amount
 *  that the string will scale is based upon the attribute's pointSizeScaleFactors. If the string cannot fit
 *  in the given width/number of lines, the smallest scale factor will be returned.
 *
 *  @param context                 The text kit context
 *  @param constrainedSize         The constrained size to render into
 *  @param textComponentAttributes The renderer's text attributes
 */
- (instancetype)initWithContext:(MUTextKitContext *)context
                constrainedSize:(CGSize)constrainedSize
              textKitAttributes:(MUTextKitAttribute *)textComponentAttributes;

/**
 *  Returns the best fit scale factor for the text
 */
- (CGFloat)scaleFactor;

/**
 *  Takes all of the attributed string attributes dealing with size (font size, line spacing, kerning, etc) and
 *  scales them by the scaleFactor. I wouldn't be surprised if I missed some in here.
 */
+ (void)adjustFontSizeForAttributeString:(NSMutableAttributedString *)attrString withScaleFactor:(CGFloat)scaleFactor;
@end
