//
//  MUTextLayoutManager.m
//  MUKit_Example
//
//  Created by Jekity on 2018/9/5.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUTextLayoutManager.h"

@implementation MUTextLayoutManager

- (void)showCGGlyphs:(const CGGlyph *)glyphs
           positions:(const CGPoint *)positions
               count:(NSUInteger)glyphCount
                font:(UIFont *)font
              matrix:(CGAffineTransform)textMatrix
          attributes:(NSDictionary *)attributes
           inContext:(CGContextRef)graphicsContext
{
    
    // NSLayoutManager has a hard coded internal color for hyperlinks which ignores
    // NSForegroundColorAttributeName. To get around this, we force the fill color
    // in the current context to match NSForegroundColorAttributeName.
    UIColor *foregroundColor = attributes[NSForegroundColorAttributeName];
    
    if (foregroundColor)
    {
        CGContextSetFillColorWithColor(graphicsContext, foregroundColor.CGColor);
    }
    
    [super showCGGlyphs:glyphs
              positions:positions
                  count:glyphCount
                   font:font
                 matrix:textMatrix
             attributes:attributes
              inContext:graphicsContext];
}

@end
