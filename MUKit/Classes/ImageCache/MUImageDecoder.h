//
//  MUImageDecoder.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUImageCacheUtils.h"

@interface MUImageDecoder : NSObject

/**
 *  Convert memory buffer to icon.
 *
 *  @param bytes    memory file
 *  @param offset   offset position at the memory file
 *  @param length   size of memory buffer
 *  @param drawSize render size
 */
- (UIImage*)iconImageWithBytes:(void*)bytes
                        offset:(size_t)offset
                        length:(size_t)length
                      drawSize:(CGSize)drawSize;

/**
 *  Decode a single image file.
 *
 *  @param file            FlyImageDataFile instance
 *  @param contentType     only support PNG/JPEG
 *  @param bytes           address of the memory
 *  @param length          file size
 *  @param drawSize        drawing size, not image  size
 *  @param contentsGravity contentsGravity of the image
 *  @param cornerRadius    cornerRadius of the image
 */
- (UIImage*)imageWithFile:(void*)file
              contentType:(MUImageContentType)contentType
                    bytes:(void*)bytes
                   length:(size_t)length
                 drawSize:(CGSize)drawSize
          contentsGravity:(NSString* const)contentsGravity
             cornerRadius:(CGFloat)cornerRadius;

#ifdef FLYIMAGE_WEBP
- (UIImage*)imageWithWebPData:(NSData*)imageData hasAlpha:(BOOL*)hasAlpha;
#endif

@end
