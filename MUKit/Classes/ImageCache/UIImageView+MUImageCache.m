//
//  UIImageView+MUImageCache.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "UIImageView+MUImageCache.h"
#import "MUImageRenderer.h"
#import "objc/runtime.h"
#import "MUImageCacheUtils.h"

@interface UIImageView (__MUImageCache) <MUImageRendererDelegate>
@end
@implementation UIImageView (MUImageCache)


static char kRendererKey;
static char kRendererIconKey;
static char kDrawingBlockKey;
static char kCornerRadiusKey;

- (void)setImageURL:(NSString*)url
{
    [self setImageURL:url placeHolderImageName:nil];
}

- (void)setImageURL:(NSString *)imageURL placeHolderImageName:(NSString *)imageName{
   
    
    [self setImageURL:imageURL placeHolderImageName:imageName cornerRadius:0];
   
}
- (void)setImageURL:(NSString *)imageURL placeHolderImageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius{
     MUImageRenderer* renderer = objc_getAssociatedObject(self, &kRendererKey);
    if (renderer == nil) {
        renderer = [[MUImageRenderer alloc] init];
        renderer.delegate = self;
        objc_setAssociatedObject(self, &kRendererKey, renderer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [renderer setPlaceHolderImageName:imageName
                          originalURL:[NSURL URLWithString:imageURL]
                             drawSize:self.bounds.size
                      contentsGravity:self.layer.contentsGravity
                         cornerRadius:cornerRadius];
}
- (NSURL*)downloadingURL
{
    return objc_getAssociatedObject(self, @selector(downloadingURL));
}

- (void)setDownloadingURL:(NSURL*)url
{
    objc_setAssociatedObject(self, @selector(downloadingURL), url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)downloadingPercentage
{
    return [objc_getAssociatedObject(self, @selector(downloadingPercentage)) floatValue];
}

- (void)setDownloadingPercentage:(float)progress
{
    objc_setAssociatedObject(self, @selector(downloadingPercentage), @(progress), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - MUImageRendererDelegate
- (void)MUImageRenderer:(MUImageRenderer*)render willRenderImage:(UIImage*)image imageKey:(NSString *)imageKey imageFilePath:(NSString *)imageFilePath
{
    if (image == nil && self.image == nil) {
        return;
    }
    dispatch_main_async_safe(^{
        
        self.image = image;
        [self setNeedsDisplay];
    });
}



#pragma  mark - icon
- (void)setIconURL:(NSString*)iconURL
{
    [self setIconURL:iconURL placeHolderImageName:nil];
}

- (void)setIconURL:(NSString *)iconURL placeHolderImageName:(NSString *)imageName
{
    [self setIconURL:iconURL placeHolderImageName:imageName cornerRadius:0];
   
}
- (void)setIconURL:(NSString *)iconURL placeHolderImageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius{
    MUImageRenderer* renderer = objc_getAssociatedObject(self, &kRendererIconKey);
    if (renderer == nil) {
        renderer = [[MUImageRenderer alloc] init];
        renderer.delegate = self;
        objc_setAssociatedObject(self, &kRendererIconKey, renderer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [renderer setPlaceHolderImageName:imageName
                              iconURL:[NSURL URLWithString:iconURL]
                             drawSize:self.bounds.size
                         cornerRadius:cornerRadius
     ];
}

#pragma mark - MUImageIconRendererDelegate

- (void)MUImageIconRenderer:(MUImageRenderer*)render willRenderImage:(UIImage*)image imageKey:(NSString *)imageKey imageFilePath:(NSString *)imageFilePath
{
    if (image == nil && self.image == nil) {
        return;
    }
    dispatch_main_async_safe(^{
        
        self.image = image;
        [self setNeedsDisplay];
    });
}

@end
