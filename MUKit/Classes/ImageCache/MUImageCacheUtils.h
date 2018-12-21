//
//  MUImageCacheUtils.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImage* (^RetrieveOperationBlock)(void);
typedef void (^MUImageCacheRetrieveBlock)(NSString* key, UIImage* image ,NSString *filePath);
typedef void (^MUImageCacheDownloadCompleted)(NSString* key, UIImage* image ,NSString *filePath);

size_t FICByteAlign(size_t bytesPerRow, size_t alignment);
size_t FICByteAlignForCoreAnimation(size_t bytesPerRow);

typedef NS_ENUM(NSInteger, MUImageContentType) {
    MUImageContentTypeUnknown,
    MUImageContentTypeJPEG,
    MUImageContentTypePNG,
    MUImageContentTypeWebP,
    MUImageContentTypeGif,
    MUImageContentTypeTiff };

@interface MUImageCacheUtils : NSObject

+ (NSString*)directoryPath;

+ (CGFloat)contentsScale;

+ (NSString*)clientVersion;
/**
 *  Memory page size, default is 4096
 */
+ (int)pageSize;

/**
 *  Compute the content type for an image data
 *
 *  @param data image data
 *
 */
+ (MUImageContentType)contentTypeForImageData:(NSData*)data;

+ (UIImage *)drawImage:(UIImage *)originalImage drawSize:(CGSize)drawSize CornerRadius:(CGFloat)cornerRadius;
@end

/**
 *  Copy from FastImageCache.
 *
 *  @param rect         draw area
 *  @param cornerRadius draw cornerRadius
 *
 */
CGMutablePathRef _MUCDCreateRoundedRectPath(CGRect rect, CGFloat cornerRadius);

/**
 *  calculate drawing bounds with original image size, target size and contentsGravity of layer.
 *
 *  @param imageSize image size
 *  @param targetSize target size
 *  @param contentsGravity layer's attribute
 */
CGRect _MUImageCalcDrawBounds(CGSize imageSize, CGSize targetSize, NSString* const contentsGravity);

#define MUImageErrorLog(fmt, ...) NSLog((@"MUImage Error: " fmt), ##__VA_ARGS__)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
#define dispatch_main_sync_safe(block)                   \
if ([NSThread isMainThread]) {                       \
block();                                         \
} else {                                             \
dispatch_sync(dispatch_get_main_queue(), block); \
}

#define dispatch_main_async_safe(block)                   \
if ([NSThread isMainThread]) {                        \
block();                                          \
} else {                                              \
dispatch_async(dispatch_get_main_queue(), block); \
}
#pragma clang diagnostic pop


