//
//  MUImageCacheManager.h
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/31.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MUImageCacheDownloadCompleted)(NSString* key, UIImage* image ,NSString *filePath);
@interface MUImageCacheManager : NSObject
+ (instancetype)sharedInstance;

- (void)downloadImageWithURL:(NSString*)imageURL
                       drawSize:(CGSize)drawSize
                   cornerRadius:(CGFloat)cornerRadius
                   completed:(MUImageCacheDownloadCompleted)completed;

- (void)downloadIconImageWithURL:(NSString*)iconURL
                    drawSize:(CGSize)drawSize
                   completed:(MUImageCacheDownloadCompleted)completed;

- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger totalSize))block;
@end
