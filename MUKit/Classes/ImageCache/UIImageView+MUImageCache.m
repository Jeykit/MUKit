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
    NSURL *tempUrl = [NSURL URLWithString:imageURL];
    [renderer setPlaceHolderImageName:imageName
                          originalURL:tempUrl
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
//    NSLog(@"image====%@",image);
    self.image = image;
    [self setNeedsDisplay];
//    dispatch_main_async_safe(^{
//    });
}

- (void)MUImageRenderer:(MUImageRenderer*)render didDownloadImageURL:(NSURL*)url progress:(float)progress
{
    self.downloadingURL = url;
    self.downloadingPercentage = progress;
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
    id corner = objc_getAssociatedObject(self, &kCornerRadiusKey);
    if (!corner) {
        if (cornerRadius > 0) {
             objc_setAssociatedObject(self, &kCornerRadiusKey, @(cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }else{
        if (ceilf([corner floatValue]) != ceilf(cornerRadius)) {
             objc_setAssociatedObject(self, &kCornerRadiusKey, @(ceilf(cornerRadius)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }

    [renderer setPlaceHolderImageName:imageName
                              iconURL:[NSURL URLWithString:iconURL]
                             drawSize:self.bounds.size];
}
- (void)setIconDrawingBlock:(MUImageIconDrawingBlock)block
{
    objc_setAssociatedObject(self, &kDrawingBlockKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)drawImage:(UIImage*)image inContext:(CGContextRef)context bounds:(CGRect)contextBounds
{
    MUImageIconDrawingBlock block = objc_getAssociatedObject(self, &kDrawingBlockKey);
    if (block != nil) {
        block(image, context, contextBounds);
        return;
    }
    
     id corner = objc_getAssociatedObject(self, &kCornerRadiusKey);
        if (corner && ceilf([corner floatValue]) > 0) {
            CGPathRef path = _FICDCreateRoundedRectPath(contextBounds, ceilf([corner floatValue]) * [MUImageCacheUtils contentsScale]);
            CGContextAddPath(context, path);
            CFRelease(path);
            CGContextEOClip(context);
        }
        UIGraphicsPushContext(context);
        CGRect drawRect = _MUImageCalcDrawBounds(image.size, contextBounds.size, self.layer.contentsGravity);
        [image drawInRect:drawRect];
        UIGraphicsPopContext();
}

#pragma mark - MUImageIconRendererDelegate
- (void)MUImageIconRenderer:(MUImageRenderer*)render
                   drawImage:(UIImage*)image
                     context:(CGContextRef)context
                      bounds:(CGRect)contextBounds
{
    
    [self drawImage:image inContext:context bounds:contextBounds];

}

- (void)MUImageIconRenderer:(MUImageRenderer*)render willRenderImage:(UIImage*)image imageKey:(NSString *)imageKey imageFilePath:(NSString *)imageFilePath
{
    if (image == nil && self.image == nil) {
        return;
    }
    
    self.image = image;
    [self setNeedsDisplay];
}
@end
