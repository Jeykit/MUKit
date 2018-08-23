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

/**
 *  Create an icon cache with default meta path.
 */
+ (instancetype)sharedInstance;
@property (nonatomic,assign ) BOOL savedFile;  //If YES,it will  save image metadata when runroop free.Don't set it value by hand
@property (nonatomic, assign) CGFloat maxCachedBytes; // Default is 512Mb.
@property (nonatomic, assign) BOOL autoDismissImage; // If you want to reduce memory when the app enter background, set this flag as YES. Default is NO.
@property (nonatomic, strong) MUImageDataFileManager* dataFileManager;
#ifdef FLYIMAGE_WEBP
@property (nonatomic, assign) BOOL autoConvertWebP; // Should convert WebP file to JPEG file automaticlly. Default is NO. If yes, it will speed up retrieving operation for the next time.
@property (nonatomic, assign) CGFloat compressionQualityForWebP; // Default is 0.8.
#endif

/**
 *  Get the image path saved in the disk.
 */
//- (NSString*)imagePathWithKey:(NSString*)key;

/**
 *  Protect the file, which can't be removed.
 *
 *  @param key image key
 */
//- (void)protectFileWithKey:(NSString*)key;

/**
 *  Don't protect the file, which can be removed.
 *
 *  @param key image key
 */
//- (void)unProtectFileWithKey:(NSString*)key;

/**
 *  Add an icon into the FlyImageIconCache.
 *
 *  @param key          unique key
 *  @param size         image size
 *  @param originalImage originalImage
 *  @param cornerRadius cornerRadius
 *  @param completed    callback after add, can be nil
 */
- (void)addImageWithKey:(NSString*)key
                   size:(CGSize)size
          originalImage:(UIImage *)originalImage
           cornerRadius:(CGFloat)cornerRadius
              completed:(MUImageCacheRetrieveBlock)completed;
/**
 *  FlyImageIconCache not support remove an icon from the cache, but you can replace an icon with the same key.
 *  But the new image must has the same size with the previous one.
 *
 *  @param key          unique key
 *  @param originalImage originalImage
 *  @param cornerRadius cornerRadius
 *  @param completed    callback after replace, can be nil
 */
- (void)replaceImageWithKey:(NSString*)key
              originalImage:(UIImage *)originalImage
               cornerRadius:(CGFloat)cornerRadius
                  completed:(MUImageCacheRetrieveBlock)completed;

- (instancetype)initWithMetaPath:(NSString*)metaPath;

/**
 *  Get image from cache asynchronously.
 */
- (void)asyncGetImageWithKey:(NSString*)key
                   completed:(MUImageCacheRetrieveBlock)completed;

/**
 *  Cancel geting an image from cache if the image has not already got.
 */
- (void)cancelGetImageWithKey:(NSString*)key;

/**
 *  Check if image exists in cache synchronized. NO delay.
 */
- (BOOL)isImageExistWithKey:(NSString*)key;

/**
 *  Remove an image from cache.
 */
- (void)removeImageWithKey:(NSString*)key;

/**
 *  Change the old key with a new key
 */
- (void)changeImageKey:(NSString*)oldKey
                newKey:(NSString*)newKey;

/**
 *  Remove all the images from the cache.
 */
- (void)purge;
@end
