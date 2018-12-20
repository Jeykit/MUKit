//
//  MUImageCacheManager.m
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/31.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUImageCacheManager.h"
#import "MUImageCache.h"
#import "MUImageIconCache.h"
#import "MUImageDownloader.h"
#import "MUImageDataFileManager.h"

@interface MUImageCacheManager()

@end


@implementation MUImageCacheManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static MUImageCacheManager* __instance;
    dispatch_once(&onceToken, ^{
        __instance = [[[self class] alloc] init];
    });
    
    return __instance;
}
- (void)asyncGetIconWithURLString:(NSString *)ImageURLString
             placeHolderImageName:(NSString *)imageName
                         drawSize:(CGSize)drawSize
                     cornerRadius:(CGFloat)cornerRadius
                        completed:(MUImageCacheRetrieveBlock)completed{
    
    if ([[MUImageCache sharedInstance] isImageExistWithURLString:ImageURLString]) {
        
        [[MUImageCache sharedInstance] asyncGetImageWithURLString:ImageURLString
                                                        completed:^(NSString *key, UIImage *image, NSString *filePath) {
                                                            
                                                            [[MUImageIconCache sharedInstance] addIconWithKey:key                filePath:filePath
                                                                                                     drawSize:drawSize
                                                                                                 cornerRadius:cornerRadius completed:completed];
                                                        }];;
    }
    if ([[MUImageIconCache sharedInstance] isIconExistWithURLString:ImageURLString]) {
        [[MUImageIconCache sharedInstance] asyncGetIconWithURLString:ImageURLString
                                                           completed:completed];
    }else{
        
        [self downloadIconURLString:ImageURLString
               placeHolderImageName:imageName
                           drawSize:drawSize
                       cornerRadius:cornerRadius
                          completed:completed];
    }
    
}

- (void)asyncGetImageWithURLString:(NSString *)ImageURLString
              placeHolderImageName:(NSString *)imageName
                          drawSize:(CGSize)drawSize
                      cornerRadius:(CGFloat)cornerRadius
                         completed:(MUImageCacheRetrieveBlock)completed{
    
 
   
    if ([[MUImageCache sharedInstance] isImageExistWithURLString:ImageURLString]) {
        [[MUImageCache sharedInstance] asyncGetImageWithURLString:ImageURLString
                                                         drawSize:drawSize
                                                  contentsGravity:kCAGravityResizeAspect
                                                     cornerRadius:cornerRadius
                                                        completed:completed];
    }else{
        [self downloadOriginalURLString:ImageURLString
                   placeHolderImageName:imageName
                               drawSize:drawSize
                           cornerRadius:cornerRadius
                              completed:completed];
    }
}

- (void)cancelGetIconWithURLString:(NSString *)ImageURLString{
    
    [[MUImageIconCache sharedInstance] cancelGetIconWithURLString:ImageURLString];
}

- (void)cancelGetImageWithURLString:(NSString *)ImageURLString{
    
    [[MUImageCache sharedInstance] cancelGetImageWithURLString:ImageURLString];
}

- (void)downloadOriginalURLString:(NSString *)imageURLString
             placeHolderImageName:(NSString *)imageName
                         drawSize:(CGSize)drawSize
                     cornerRadius:(CGFloat)cornerRadius
                        completed:(MUImageCacheRetrieveBlock)completed
{
    
    if (imageName.length > 0) {//clear previous image
        UIImage *placeHolderImage = [UIImage imageNamed:imageName];
        completed(imageURLString ,placeHolderImage ,nil);
    }else{
        completed(imageURLString ,nil ,nil);
    }
    [[MUImageDownloader sharedInstance]downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]] success:^(NSURLRequest *request, NSURL *filePath) {
        
         [[MUImageCache sharedInstance] addImageWithKey:request.URL.absoluteString
                                               filename:filePath.lastPathComponent
                                               drawSize:drawSize
                                           cornerRadius:cornerRadius
                                              completed:completed];
        
    } failed:^(NSURLRequest *request, NSError *error) {
        
    }];
}
- (void)downloadIconURLString:(NSString *)imageURLString
             placeHolderImageName:(NSString *)imageName
                         drawSize:(CGSize)drawSize
                     cornerRadius:(CGFloat)cornerRadius
                        completed:(MUImageCacheRetrieveBlock)completed
{
    
    if (imageName.length > 0) {//clear previous image
        UIImage *placeHolderImage = [UIImage imageNamed:imageName];
        completed(imageURLString ,placeHolderImage ,nil);
    }else{
        completed(imageURLString ,nil ,nil);
    }
    [[MUImageDownloader sharedInstance]downloadImageForURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]] success:^(NSURLRequest *request, NSURL *filePath) {
        
        [[MUImageCache sharedInstance] addImageWithKey:request.URL.absoluteString
                                              filename:filePath.lastPathComponent
                                              drawSize:CGSizeZero
                                          cornerRadius:0
                                             completed:nil];
        
        [[MUImageIconCache sharedInstance] addIconWithKey:request.URL.absoluteString
                                                 filePath:filePath.path
                                                 drawSize:drawSize
                                             cornerRadius:cornerRadius completed:completed];
        
    } failed:^(NSURLRequest *request, NSError *error) {
        
    }];
}
- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger))block{
    __block NSUInteger size = 0;
    [[MUImageCache sharedInstance].dataFileManager calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        size += totalSize;
        if (block) {
            block(size);
        }
    }];
    [[MUImageIconCache sharedInstance].dataFileManager calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        size += totalSize;
        if (block) {
            block(size);
        }
    }];
}


- (void)clearCache{
    [[MUImageCache sharedInstance] purge];
    [[MUImageIconCache sharedInstance] purge];
}
@end
