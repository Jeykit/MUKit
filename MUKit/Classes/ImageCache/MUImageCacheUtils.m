//
//  MUImageCacheUtils.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageCacheUtils.h"


inline size_t FICByteAlign(size_t width, size_t alignment) {
    return ((width + (alignment - 1)) / alignment) * alignment;
}

inline size_t FICByteAlignForCoreAnimation(size_t bytesPerRow) {
    return FICByteAlign(bytesPerRow, 64);
}

@implementation MUImageCacheUtils
{
    NSLock *_lock;
    NSMutableDictionary * _images;
}


+ (NSString*)directoryPath
{
    
    static NSString* __directoryPath = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        __directoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MUImage"];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        BOOL directoryExists = [fileManager fileExistsAtPath:__directoryPath];
        if (directoryExists == NO) {
            [fileManager createDirectoryAtPath:__directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    
    return __directoryPath;
}

+ (CGFloat)contentsScale
{
    
    static CGFloat __contentsScale = 1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __contentsScale = [UIScreen mainScreen].scale;
    });
    
    return __contentsScale;
}

+ (NSString*)clientVersion
{
    
    static NSString* __clientVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *build = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        
        __clientVersion = [version stringByAppendingString:build];
    });
    
    return __clientVersion;
}

+ (int)pageSize
{
    static int __pageSize = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __pageSize = getpagesize();
    });
    
    return __pageSize;
}

+ (MUImageContentType)contentTypeForImageData:(NSData*)data
{
    
    if (!data) {
        return MUImageContentTypeUnknown;
    }
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return MUImageContentTypeJPEG;
        case 0x89:
            return MUImageContentTypePNG;
        case 0x47:
            return MUImageContentTypeGif;
        case 0x49:
        case 0x4D:
            return MUImageContentTypeTiff;
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return MUImageContentTypeUnknown;
            }
            
            NSString* testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return MUImageContentTypeWebP;
            }
            
            return MUImageContentTypeUnknown;
    }
    return MUImageContentTypeUnknown;
}

// from FastImageCache
CGMutablePathRef _MUCDCreateRoundedRectPath(CGRect rect, CGFloat cornerRadius)
{
    CGMutablePathRef path = CGPathCreateMutable();

    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);

    CGPathMoveToPoint(path, NULL, minX, midY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, midY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, minY, midX, minY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, minX, minY, minX, midY, cornerRadius);

    return path;
}

CGRect _MUImageCalcDrawBounds(CGSize imageSize, CGSize targetSize, NSString* const contentsGravity)
{

    CGFloat x, y, width, height;
    if ([contentsGravity isEqualToString:kCAGravityCenter]) {

        x = (targetSize.width - imageSize.width) / 2;
        y = (targetSize.height - imageSize.height) / 2;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityTop]) {

        x = (targetSize.width - imageSize.width) / 2;
        y = targetSize.height - imageSize.height;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityBottom]) {

        x = (targetSize.width - imageSize.width) / 2;
        y = 0;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityLeft]) {

        x = 0;
        y = (targetSize.height - imageSize.height) / 2;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityRight]) {

        x = targetSize.width - imageSize.width;
        y = (targetSize.height - imageSize.height) / 2;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityTopLeft]) {

        x = 0;
        y = targetSize.height - imageSize.height;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityTopRight]) {

        x = targetSize.width - imageSize.width;
        y = targetSize.height - imageSize.height;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityBottomLeft]) {

        x = 0;
        y = 0;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityBottomRight]) {

        x = targetSize.width - imageSize.width;
        y = 0;
        width = imageSize.width;
        height = imageSize.height;

    } else if ([contentsGravity isEqualToString:kCAGravityResizeAspectFill]) {

        CGFloat scaleWidth = targetSize.width / imageSize.width;
        CGFloat scaleHeight = targetSize.height / imageSize.height;

        if (scaleWidth < scaleHeight) {
            y = 0;
            height = targetSize.height;
            width = scaleHeight * imageSize.width;
            x = (targetSize.width - width) / 2;
        } else {
            x = 0;
            width = targetSize.width;
            height = scaleWidth * imageSize.height;
            y = (targetSize.height - height) / 2;
        }
    } else if ([contentsGravity isEqualToString:kCAGravityResize]) {

        x = y = 0;
        width = targetSize.width;
        height = targetSize.height;

    } else {

        // kCAGravityResizeAspect
        CGFloat scaleWidth = targetSize.width / imageSize.width;
        CGFloat scaleHeight = targetSize.height / imageSize.height;

        if (scaleWidth > scaleHeight) {
            y = 0;
            height = targetSize.height;
            width = scaleHeight * imageSize.width;
            x = (targetSize.width - width) / 2;
        } else {
            x = 0;
            width = targetSize.width;
            height = scaleWidth * imageSize.height;
            y = (targetSize.height - height) / 2;
        }
    }

    return CGRectMake(x, y, width, height);
}

+ (UIImage *)drawImage:(UIImage *)originalImage drawSize:(CGSize)drawSize CornerRadius:(CGFloat)cornerRadius{

    if (!originalImage) {
        return  nil;
    }
    UIImage * decompressedImage = originalImage;
    //1.开启图片图形上下文:注意设置透明度为非透明
    UIGraphicsBeginImageContextWithOptions( drawSize, NO, [MUImageCacheUtils contentsScale]);
    
    //2.开启图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Clip to a rounded rect
    if (cornerRadius > 0) {
        CGPathRef path = _MUCDCreateRoundedRectPath(CGRectMake(0, 0, drawSize.width, drawSize.height), cornerRadius);
        CGContextAddPath(context, path);
        CFRelease(path);
        CGContextEOClip(context);
    }
    [decompressedImage drawInRect: CGRectMake(0, 0, drawSize.width,drawSize.height)];
    //6.获取图片
    decompressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return decompressedImage;
}

@end
