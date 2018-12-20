//
//  MUImageDecoder.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageDecoder.h"

#ifdef FLYIMAGE_WEBP
#import "webp/decode.h"
#endif

static void __ReleaseAsset(void* info, const void* data, size_t size)
{
    if (info != NULL) {
        CFRelease(info); // will cause dealloc of FlyImageDataFile
    }
}

#ifdef FLYIMAGE_WEBP
// This gets called when the UIImage gets collected and frees the underlying image.
static void free_image_data(void* info, const void* data, size_t size)
{
    if (info != NULL) {
        WebPFreeDecBuffer(&(((WebPDecoderConfig*)info)->output));
        free(info);
    }
    
    if (data != NULL) {
        free((void*)data);
    }
}
#endif

@implementation MUImageDecoder

- (UIImage*)iconImageWithBytes:(void*)bytes
                        offset:(size_t)offset
                        length:(size_t)length
                      drawSize:(CGSize)drawSize
{
    
    // Create CGImageRef whose backing store *is* the mapped image table entry. We avoid a memcpy this way.
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, bytes + offset, length, __ReleaseAsset);
    
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
    NSInteger bitsPerComponent = 8;
    NSInteger bitsPerPixel = 4 * 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    static NSInteger bytesPerPixel = 4;
    static float kAlignment = 64;
    CGFloat screenScale = [MUImageCacheUtils contentsScale];
    size_t bytesPerRow = ceil((drawSize.width * screenScale * bytesPerPixel) / kAlignment) * kAlignment;
    
    CGImageRef imageRef = CGImageCreate(drawSize.width * screenScale,
                                        drawSize.height * screenScale,
                                        bitsPerComponent,
                                        bitsPerPixel,
                                        bytesPerRow,
                                        colorSpace,
                                        bitmapInfo,
                                        dataProvider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colorSpace);
    
    if (imageRef == nil) {
        return nil;
    }
    
    UIImage *image = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}


- (CGImageRef)imageRefWithFile:(void*)file
                   contentType:(MUImageContentType)contentType
                         bytes:(void*)bytes
                        length:(size_t)length
{
    if (contentType == MUImageContentTypeUnknown || contentType == MUImageContentTypeGif || contentType == MUImageContentTypeTiff) {
        return nil;
    }
     CFRetain(file);
    // Create CGImageRef whose backing store *is* the mapped image table entry. We avoid a memcpy this way.
    CGImageRef imageRef = nil;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(file, bytes, length, nil);
    if (contentType == MUImageContentTypeJPEG) {
        if (dataProvider != NULL || dataProvider) {
            imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, YES, kCGRenderingIntentDefault);
        }
        
    } else if (contentType == MUImageContentTypePNG) {
        if (dataProvider != NULL || dataProvider) {
            imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, YES, kCGRenderingIntentDefault);
        }
        
    } else if (contentType == MUImageContentTypeWebP) {
#ifdef FLYIMAGE_WEBP
        // `WebPGetInfo` weill return image width and height
        int width = 0, height = 0;
        if (!WebPGetInfo(bytes, length, &width, &height)) {
            return nil;
        }
        
        WebPDecoderConfig* config = malloc(sizeof(WebPDecoderConfig));
        if (!WebPInitDecoderConfig(config)) {
            return nil;
        }
        
        config->options.no_fancy_upsampling = 1;
        config->options.bypass_filtering = 1;
        config->options.use_threads = 1;
        config->output.colorspace = MODE_RGBA;
        
        // Decode the WebP image data into a RGBA value array
        VP8StatusCode decodeStatus = WebPDecode(bytes, length, config);
        if (decodeStatus != VP8_STATUS_OK) {
            return nil;
        }
        
        // Construct UIImage from the decoded RGBA value array
        uint8_t* data = WebPDecodeRGBA(bytes, length, &width, &height);
        dataProvider = CGDataProviderCreateWithData(config, data, config->options.scaled_width * config->options.scaled_height * 4, free_image_data);
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
        
        imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, bitmapInfo, dataProvider, NULL, YES, renderingIntent);
#endif
    }
    if (dataProvider != NULL || dataProvider) {
        CGDataProviderRelease(dataProvider);
    }
    CFRelease(file);
    return imageRef;
}


- (UIImage *)decompressedImageWithImage:(UIImage *)image
                                   data:(NSData *__autoreleasing  _Nullable *)data
                                options:(nullable NSDictionary<NSString*, NSObject*>*)optionsDict {
    // GIF do not decompress
    return image;
}

- (UIImage*)imageWithFile:(void*)file
              contentType:(MUImageContentType)contentType
                    bytes:(void*)bytes
                   length:(size_t)length
                 drawSize:(CGSize)drawSize
          contentsGravity:(NSString* const)contentsGravity
             cornerRadius:(CGFloat)cornerRadius
{
    if (contentType == MUImageContentTypeGif) {
        NSData *data = [NSData dataWithBytes:bytes length:length];
        //        NSLog(@"data====%ld",data.length);
        return [self animatedGIFWithData:data];
    }
    
    CGImageRef imageRef = [self imageRefWithFile:file contentType:contentType bytes:bytes length:length];
    if (imageRef == nil) {
        return nil;
    }
    @autoreleasepool{
        CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        CGFloat contentsScale = 1;
        if (drawSize.width < imageSize.width && drawSize.height < imageSize.height) {
            contentsScale = [MUImageCacheUtils contentsScale];
        }
        
//        NSString *contentGra = [contentsGravity copy];
        
        
        UIImage* decompressedImage = [UIImage imageWithCGImage:imageRef
                                                                  scale:contentsScale
                                               
                                                            orientation:UIImageOrientationUp];
    
//        CGRect imageRect = _MUImageCalcDrawBounds(imageSize,
//                                                  drawSize,
//                                                  contentGra);
        //1.开启图片图形上下文:注意设置透明度为非透明
        UIGraphicsBeginImageContextWithOptions( drawSize, NO, contentsScale);
        
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
        //7.关闭图形上下文
        UIGraphicsEndImageContext();
       
        CGImageRelease(imageRef);
        
        return decompressedImage;
    }
}

#ifdef FLYIMAGE_WEBP
- (UIImage*)imageWithWebPData:(NSData*)imageData hasAlpha:(BOOL*)hasAlpha
{
    
    // `WebPGetInfo` weill return image width and height
    int width = 0, height = 0;
    if (!WebPGetInfo(imageData.bytes, imageData.length, &width, &height)) {
        return nil;
    }
    
    WebPDecoderConfig* config = malloc(sizeof(WebPDecoderConfig));
    if (!WebPInitDecoderConfig(config)) {
        return nil;
    }
    
    config->options.no_fancy_upsampling = 1;
    config->options.bypass_filtering = 1;
    config->options.use_threads = 1;
    config->output.colorspace = MODE_RGBA;
    
    // Decode the WebP image data into a RGBA value array
    VP8StatusCode decodeStatus = WebPDecode(imageData.bytes, imageData.length, config);
    if (decodeStatus != VP8_STATUS_OK) {
        return nil;
    }
    
    // set alpha value
    if (hasAlpha != nil) {
        *hasAlpha = config->input.has_alpha;
    }
    
    // Construct UIImage from the decoded RGBA value array
    uint8_t* data = WebPDecodeRGBA(imageData.bytes, imageData.length, &width, &height);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(config, data, config->options.scaled_width * config->options.scaled_height * 4, free_image_data);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, bitmapInfo, dataProvider, NULL, YES, renderingIntent);
    UIImage* decodeImage = [UIImage imageWithCGImage:imageRef];
    
    UIGraphicsBeginImageContextWithOptions(decodeImage.size, !config->input.has_alpha, 1);
    [decodeImage drawInRect:CGRectMake(0, 0, decodeImage.size.width, decodeImage.size.height)];
    UIImage* decompressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return decompressedImage;
}
#endif

#pragma mark-GIF
- (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSUInteger duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
    return animatedImage;
}


- (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    if (!cfFrameProperties) {
        return frameDuration;
    }
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
