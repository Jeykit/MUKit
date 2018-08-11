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

- (void)downloadImageWithURL:(NSString*)imageURL
                       drawSize:(CGSize)drawSize
                   cornerRadius:(CGFloat)cornerRadius
                   completed:(MUImageCacheDownloadCompleted)completed;

- (void)downloadIconImageWithURL:(NSString*)iconURL
                    drawSize:(CGSize)drawSize
                   completed:(MUImageCacheDownloadCompleted)completed;

//获取存储在磁盘上的image
- (void)asyncGetImageWithKey:(NSString*)key
                    drawSize:(CGSize)drawSize
                cornerRadius:(CGFloat)cornerRadius
                   completed:(MUImageCacheRetrieveBlock)completed;

- (void)asyncGetImageWithKey:(NSString*)key
                    drawSize:(CGSize)drawSize
                   completed:(MUImageCacheRetrieveBlock)completed;

- (void)asyncGetImageWithKey:(NSString*)key
                   completed:(MUImageCacheRetrieveBlock)completed;

//获取存储在磁盘上的icon
- (void)asyncGetIconWithKey:(NSString*)key
                   completed:(MUImageCacheRetrieveBlock)completed;

- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger totalSize))block;

- (void)clearCache;
@end
