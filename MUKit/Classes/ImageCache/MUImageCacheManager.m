//
//  MUImageCacheManager.m
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/31.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUImageCacheManager.h"
#import "MUImageCache.h"
#import "MUImageDownloader.h"
#import "MUImageDataFileManager.h"



#define kImageInfoIndexSize 0
#define kImageInfoIndexCornerRadius 1
#define kImageInfoIndexCompleted 2
#define kImageInfoIndexProgressImage 3

@implementation MUImageCacheManager{
    
    NSMutableDictionary *_progressImages;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static MUImageCacheManager* __instance;
    dispatch_once(&onceToken, ^{
        __instance = [[[self class] alloc] init];
    });
    
    return __instance;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _progressImages = [NSMutableDictionary dictionaryWithCapacity:100];
    }
    return self;
}
- (void)asyncGetProgressImageWithURLString:(NSString *)ImageURLString
                      placeHolderImageName:(NSString *)imageName
                                  drawSize:(CGSize)drawSize
                              cornerRadius:(CGFloat)cornerRadius
                                 completed:(MUImageCacheRetrieveBlock)completed{
    
    if ([[MUImageCache sharedInstance] isImageExistWithURLString:ImageURLString]) {
        [[MUImageCache sharedInstance] asyncGetImageWithURLString:ImageURLString
                                             placeHolderImageName:imageName
                                                         drawSize:drawSize
                                                  contentsGravity:kCAGravityResizeAspect
                                                     cornerRadius:cornerRadius
                                                        completed:completed];
    }else{
        [self downloadProgressImageURLString:ImageURLString
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
                                             placeHolderImageName:imageName
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
    if (imageURLString.length == 0) {
        return;
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
- (void)downloadProgressImageURLString:(NSString *)imageURLString
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
    
    if ([_progressImages objectForKey:imageURLString] == nil) {
        
        [_progressImages setObject:@[[NSValue valueWithCGSize:drawSize] ,[NSNumber numberWithDouble:cornerRadius] ,completed] forKey:imageURLString];
    }else{
        NSArray *images = [_progressImages valueForKey:imageURLString];
        if (images.count > 3) {
            UIImage *progressImage = images[kImageInfoIndexProgressImage];
            completed(imageURLString , progressImage ,nil);
        }
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [[MUImageDownloader sharedInstance] downloadImageForURLRequest:request progress:^(UIImage *progressiveImage) {
        
        if ([_progressImages objectForKey:request.URL.absoluteString] != nil) {
            
            UIImage *willShowImage = progressiveImage;
            if (willShowImage) {
                NSArray *images = [[_progressImages valueForKey:request.URL.absoluteString] copy];
                CGSize newDrawSize      = [images[kImageInfoIndexSize] CGSizeValue];
                CGFloat newCornerRadius = [images[kImageInfoIndexCornerRadius] doubleValue];
                MUImageCacheRetrieveBlock completed = images[kImageInfoIndexCompleted];
                willShowImage = [MUImageCacheUtils drawImage:willShowImage drawSize:newDrawSize CornerRadius:newCornerRadius];
                NSMutableArray *mArray = [NSMutableArray arrayWithArray:images];
                [mArray addObject:willShowImage];
                @synchronized (_progressImages) {
                    [_progressImages setObject:mArray forKey:request.URL.absoluteString];
                }
                completed(request.URL.absoluteString , willShowImage ,nil);
            }
        }
        
    } success:^(NSURLRequest *request, NSURL *filePath) {
        
        [[MUImageCache sharedInstance] addImageWithKey:request.URL.absoluteString
                                              filename:filePath.lastPathComponent
                                              drawSize:drawSize
                                          cornerRadius:cornerRadius
                                             completed:completed];
        [_progressImages removeObjectForKey:request.URL.absoluteString];
        
    } failed:^(NSURLRequest *request, NSError *error) {
        [_progressImages removeObjectForKey:request.URL.absoluteString];
        
    } updatedProogress:YES];
}
#pragma clang diagnostic pop
- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger))block{
    __block NSUInteger size = 0;
    [[MUImageCache sharedInstance].dataFileManager calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        size += totalSize;
        if (block) {
            block(size);
        }
    }];
}


- (void)clearCache{
    [[MUImageCache sharedInstance] purge];
}
@end
