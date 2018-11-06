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


- (void)setWaitingDownloadingComplected:(BOOL)waitingDownloadingComplected{
    objc_setAssociatedObject(self, @selector(waitingDownloadingComplected), [NSNumber numberWithBool:waitingDownloadingComplected], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)waitingDownloadingComplected{
    
    return [objc_getAssociatedObject(self, @selector(waitingDownloadingComplected)) boolValue];
}

- (void)setUpdateWithProgress:(BOOL)updateWithProgress{
     objc_setAssociatedObject(self, @selector(updateWithProgress), [NSNumber numberWithBool:updateWithProgress], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)updateWithProgress{
     return [objc_getAssociatedObject(self, @selector(updateWithProgress)) boolValue];
}
- (void)setImageURL:(NSString*)url
{
    [self setImageURL:url placeHolderImageName:@""];
}

- (void)setImageURL:(NSString *)imageURL placeHolderImageName:(NSString *)imageName{
    
    
    [self setImageURL:imageURL placeHolderImageName:imageName cornerRadius:0];
    
}
- (void)setImageURL:(NSString *)imageURL placeHolderImageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius{
    if (!imageURL&&imageURL.length==0) {
        return;
    }
    MUImageRenderer* renderer = objc_getAssociatedObject(self, @selector(setImageURL:placeHolderImageName:cornerRadius:));
    if (renderer == nil) {
        renderer = [[MUImageRenderer alloc] init];
        renderer.delegate = self;
        renderer.downloading = self.waitingDownloadingComplected;
        objc_setAssociatedObject(self, @selector(setImageURL:placeHolderImageName:cornerRadius:), renderer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [renderer setPlaceHolderImageName:imageName
                          originalURL:[NSURL URLWithString:imageURL]
                             drawSize:self.bounds.size
                      contentsGravity:self.layer.contentsGravity
                         cornerRadius:cornerRadius
     progress:self.updateWithProgress
     ];
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
    __weak typeof(self)weakSelf = self;
    dispatch_main_async_safe(^{
        __strong typeof(weakSelf)self = weakSelf;
        self.image = image;
        [self setNeedsDisplay];
    });
}



#pragma  mark - icon
- (void)setIconURL:(NSString*)iconURL
{
    [self setIconURL:iconURL placeHolderImageName:@""];
}

- (void)setIconURL:(NSString *)iconURL placeHolderImageName:(NSString *)imageName
{
    [self setIconURL:iconURL placeHolderImageName:imageName cornerRadius:0];
    
}
- (void)setIconURL:(NSString *)iconURL placeHolderImageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius{
    if (!iconURL&&iconURL.length==0) {
        return;
    }
    MUImageRenderer* renderer = objc_getAssociatedObject(self, @selector(setIconURL:placeHolderImageName:cornerRadius:));
    if (renderer == nil) {
        renderer = [[MUImageRenderer alloc] init];
        renderer.delegate = self;
        renderer.downloading = self.waitingDownloadingComplected;
        objc_setAssociatedObject(self, @selector(setIconURL:placeHolderImageName:cornerRadius:), renderer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    __weak typeof(self)weakSelf = self;
    dispatch_main_async_safe(^{
        __strong typeof(weakSelf)self = weakSelf;
        self.image = image;
        [self setNeedsDisplay];
    });
}

- (void)MUImageRenderer:(MUImageRenderer *)render didDownloadImageURL:(NSURL *)url progressive:(UIImage *)progressiveImage{
    
    if (progressiveImage) {
        __weak typeof(self)weakSelf = self;
        dispatch_main_async_safe(^{
            __strong typeof(weakSelf)self = weakSelf;
            self.image = progressiveImage;
            [self setNeedsDisplay];
        });
    }
}

@end
