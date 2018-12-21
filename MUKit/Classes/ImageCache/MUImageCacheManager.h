//
//  MUImageCacheManager.h
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/31.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUImageCacheUtils.h"


@interface MUImageCacheManager : NSObject


+ (instancetype)sharedInstance;
/**
 *  Get image with customize parameters from cache asynchronously.
 *  Avoid executing `CGDataProviderCreateWithCopyOfData`.
 *
 *  @param ImageURLString  ImageURLString
 *  @param drawSize        render size
 *  @param cornerRadius    cornerRadius of render view
 *  @param completed       callback
 */


- (void)asyncGetImageWithURLString:(NSString*)ImageURLString
              placeHolderImageName:(NSString *)imageName
                          drawSize:(CGSize)drawSize
                      cornerRadius:(CGFloat)cornerRadius
                         completed:(MUImageCacheRetrieveBlock)completed;



/**
 *  Get image with customize parameters from cache asynchronously.
 *  Avoid executing `CGDataProviderCreateWithCopyOfData`.
 *
 *  @param ImageURLString  ImageURLString
 *  @param drawSize        render size
 *  @param cornerRadius    cornerRadius of render view
 *  @param completed       callback
 */

- (void)asyncGetProgressImageWithURLString:(NSString*)ImageURLString
             placeHolderImageName:(NSString *)imageName
                         drawSize:(CGSize)drawSize
                     cornerRadius:(CGFloat)cornerRadius
                        completed:(MUImageCacheRetrieveBlock)completed;

/**
 *  Cancel geting an image from cache if the image has not already got.
 */
- (void)cancelGetImageWithURLString:(NSString*)ImageURLString;


- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger totalSize))block;

- (void)clearCache;
@end
