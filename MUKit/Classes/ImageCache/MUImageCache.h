//
//  MUImageCache.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUImageCacheUtils.h"


@class MUImageDataFileManager;
@interface MUImageCache : NSObject

/**
 *  Create an image cache with default meta path.
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

- (void)addImageWithKey:(NSString*)key
               filename:(NSString*)filename
              completed:(MUImageCacheRetrieveBlock)completed;

- (void)addImageWithKey:(NSString*)key
               filename:(NSString*)filename
               drawSize:(CGSize)drawSize
        contentsGravity:(NSString* const)contentsGravity
           cornerRadius:(CGFloat)cornerRadius
              completed:(MUImageCacheRetrieveBlock)completed;

/**
 *  Get image with customize parameters from cache asynchronously.
 *  Avoid executing `CGDataProviderCreateWithCopyOfData`.
 *
 *  @param key             image key
 *  @param drawSize        render size
 *  @param contentsGravity contentMode of render view
 *  @param cornerRadius    cornerRadius of render view
 *  @param completed       callback
 */
- (void)asyncGetImageWithKey:(NSString*)key
                    drawSize:(CGSize)drawSize
             contentsGravity:(NSString* const)contentsGravity
                cornerRadius:(CGFloat)cornerRadius
                   completed:(MUImageCacheRetrieveBlock)completed;

/**
 *  Get the image path saved in the disk.
 */
- (NSString*)imagePathWithKey:(NSString*)key;

/**
 *  Protect the file, which can't be removed.
 *
 *  @param key image key
 */
- (void)protectFileWithKey:(NSString*)key;

/**
 *  Don't protect the file, which can be removed.
 *
 *  @param key image key
 */
- (void)unProtectFileWithKey:(NSString*)key;


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
