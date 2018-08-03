//
//  MUImageEncoder.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MUImageEncoderDrawingBlock)(CGContextRef context, CGRect contextBounds);

/**
 *  Convert an image to bitmap format.
 */

@interface MUImageEncoder : NSObject
/**
 *  Draw an image, and save the bitmap data into memory buffer.
 *
 *  @param size         image size
 *  @param bytes        memory buffer
 *  @param drawingBlock drawing function
 */
- (void)encodeWithImageSize:(CGSize)size
                      bytes:(void*)bytes
               drawingBlock:(MUImageEncoderDrawingBlock)drawingBlock;

/**
 *  Calculate buffer size with image size.
 *
 *  @param size image size
 */
+ (size_t)dataLengthWithImageSize:(CGSize)size;
@end
