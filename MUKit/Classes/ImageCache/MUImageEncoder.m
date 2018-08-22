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
{
     NSLock* _lock;
}
static NSInteger __bytesPerPixel = 4;
static NSInteger __bitsPerComponent = 8;
static float __alignmentSize = 64;

BOOL MUCGImageRefContainsAlpha(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

CGColorSpaceRef MUCGColorSpaceGetDeviceRGB(void) {
    static CGColorSpaceRef colorSpace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSpace = CGColorSpaceCreateDeviceRGB();
    });
    return colorSpace;
}
- (instancetype)init{
    
    if(self = [super init]){
        _lock = [NSLock new];
    }
    return self;
}
- (UIImage *)encodeWithImageSize:(CGSize)size bytes:(void *)bytes originalImage:(UIImage *)originalImage cornerRadius:(CGFloat)cornerRadius{
    if (originalImage.images) {
        // Do not decode animated images
        return originalImage;
    }
    @autoreleasepool{
        
        CGImageRef imageRef = originalImage.CGImage;
        // device color space
        CGColorSpaceRef colorspaceRef = MUCGColorSpaceGetDeviceRGB();
        BOOL hasAlpha = MUCGImageRefContainsAlpha(imageRef);
        // iOS display alpha info (BRGA8888/BGRX8888)
//        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
//        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        
        CGFloat screenScale = [MUImageCacheUtils contentsScale];
        CGSize pixelSize = CGSizeMake(size.width * screenScale, size.height * screenScale);
        
        // It calculates the bytes-per-row based on the __bitsPerComponent and width arguments.
        size_t bytesPerRow = ceil((pixelSize.width * __bytesPerPixel) / __alignmentSize) * __alignmentSize;
        size_t width = pixelSize.width;
        size_t height = pixelSize.height;
        
        CGRect imageRect = CGRectMake(0, 0, width, height);
        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        CGContextRef context = CGBitmapContextCreate(bytes,
                                                     width,
                                                     height,
                                                     __bitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     bitmapInfo);
        if (context == NULL) {
            return originalImage;
        }
        
        if (cornerRadius > 0) {
            CGPathRef path = _FICDCreateRoundedRectPath(imageRect, ceilf(cornerRadius) * [MUImageCacheUtils contentsScale]);
            CGContextAddPath(context, path);
            CFRelease(path);
            CGContextEOClip(context);
        }
        
        [_lock lock];
        CFRetain(imageRef);
        CFRetain(context);
        if (context&&imageRef) {
            CGContextClearRect(context, imageRect);
            CGContextDrawImage(context, imageRect, imageRef);
        }
        // Draw the image into the context and retrieve the new bitmap image without alpha
        CGImageRef imageRefWithoutAlpha = nil;
        if (context) {
            imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        }
        CFRelease(imageRef);
        CFRelease(context);
         [_lock unlock];
        UIImage *imageWithoutAlpha = [[UIImage alloc] initWithCGImage:imageRefWithoutAlpha scale:screenScale orientation:originalImage.imageOrientation];
        CGContextRelease(context);
        CGImageRelease(imageRefWithoutAlpha);
        return imageWithoutAlpha;
    }
    
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
