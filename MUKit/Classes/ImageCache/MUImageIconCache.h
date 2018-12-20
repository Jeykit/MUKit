//
//  MUImageIconCache.h
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUImageCacheUtils.h"


@class MUImageDataFileManager;
@interface MUImageIconCache : NSObject

@property (nonatomic, assign) CGFloat maxCachedBytes; // Default is 512Mb.

#ifdef FLYIMAGE_WEBP
@property (nonatomic, assign) BOOL autoConvertWebP; // Should convert WebP file to JPEG file automaticlly. Default is NO. If yes, it will speed up retrieving operation for the next time.
@property (nonatomic, assign) CGFloat compressionQualityForWebP; // Default is 0.8.
#endif

@property (nonatomic, assign) BOOL autoDismissImage; // If you want to reduce memory when the app enter background, set this flag as YES. Default is NO.
/**
 *  Create an image cache with default meta path.
 */
+ (instancetype)sharedInstance;

@property (nonatomic, strong) MUImageDataFileManager* dataFileManager;

/**
 *  Cancel geting an image from cache if the image has not already got.
 */
- (void)cancelGetIconWithURLString:(NSString*)imageURLString;

/**
 *  Check if image exists in cache synchronized. NO delay.
 */
- (BOOL)isIconExistWithURLString:(NSString*)imageURLString;

/**
 *  Get image from cache asynchronously.
 */
- (void)asyncGetIconWithURLString:(NSString*)imageURLString
                         completed:(MUImageCacheRetrieveBlock)completed;

/**
 *  add image with customize parameters from cache asynchronously.
 *  Avoid executing `CGDataProviderCreateWithCopyOfData`.
 *
 *  @param imageURLString  imageURLString
 *  @param drawSize        render size
 *  @param cornerRadius    cornerRadius of render view
 *  @param completed       callback
 */
- (void)addIconWithKey:(NSString*)key
               filePath:(NSString*)filePath
               drawSize:(CGSize)drawSize
           cornerRadius:(CGFloat)cornerRadius
              completed:(MUImageCacheRetrieveBlock)completed;

/**
 *  Remove all the images from the cache.
 */
- (void)purge;

/**
 *  auto save metas when runloop in free time
 */
- (void)commit;

@end
