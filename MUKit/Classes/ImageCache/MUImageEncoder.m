//
//  MUImageEncoder.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageEncoder.h"
#import "MUImageCacheUtils.h"

@implementation MUImageEncoder
static NSInteger __bytesPerPixel = 4;
static NSInteger __bitsPerComponent = 8;
static float __alignmentSize = 64;

- (void)encodeWithImageSize:(CGSize)size
                      bytes:(void*)bytes
               drawingBlock:(MUImageEncoderDrawingBlock)drawingBlock
{
    
    CGFloat screenScale = [MUImageCacheUtils contentsScale];
    CGSize pixelSize = CGSizeMake(size.width * screenScale, size.height * screenScale);
    
    // It calculates the bytes-per-row based on the __bitsPerComponent and width arguments.
    size_t bytesPerRow = ceil((pixelSize.width * __bytesPerPixel) / __alignmentSize) * __alignmentSize;
    
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(bytes,
                                                 pixelSize.width,
                                                 pixelSize.height,
                                                 __bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    CGContextTranslateCTM(context, 0, pixelSize.height);
    CGContextScaleCTM(context, 1, -1);
    
    // Call drawing block to allow client to draw into the context
    CGRect contextBounds = CGRectZero;
    contextBounds.size = pixelSize;
    CGContextClearRect(context, contextBounds);
    
    drawingBlock(context, contextBounds);
    CGContextRelease(context);
}

+ (size_t)dataLengthWithImageSize:(CGSize)size
{
    
    CGFloat screenScale = [MUImageCacheUtils contentsScale];
    CGSize pixelSize = CGSizeMake(size.width * screenScale, size.height * screenScale);
    
    size_t bytesPerRow = ceil((pixelSize.width * __bytesPerPixel) / __alignmentSize) * __alignmentSize;
    CGFloat imageLength = bytesPerRow * (NSInteger)pixelSize.height;
    
    int pageSize = [MUImageCacheUtils pageSize];
    size_t bytesToAppend = ceil(imageLength / pageSize) * pageSize;
    
    return bytesToAppend;
}

@end
