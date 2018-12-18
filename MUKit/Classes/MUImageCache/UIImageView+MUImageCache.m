//
//  UIImageView+MUImageCache.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "UIImageView+MUImageCache.h"
#import "objc/runtime.h"
#import <SDWebImage/UIImageView+WebCache.h>


// from FastImageCache
CGMutablePathRef _FICDCreateRoundedRectPath(CGRect rect, CGFloat cornerRadius)
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGPathMoveToPoint(path, NULL, minX, midY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, midY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, maxX, minY, midX, minY, cornerRadius);
    CGPathAddArcToPoint(path, NULL, minX, minY, minX, midY, cornerRadius);
    
    return path;
}


@implementation UIImageView (MUImageCache)

+ (CGFloat)contentsScale
{
    
    static CGFloat __contentsScale = 1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __contentsScale = [UIScreen mainScreen].scale;
    });
    
    return __contentsScale;
}


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
    
    
    [self MUImageCache:imageURL placeHolderImageName:imageName];
    
}
- (void)setImageURL:(NSString *)imageURL placeHolderImageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius{
    if (!imageURL&&imageURL.length==0) {
        return;
    }
  
}

#pragma  mark - icon
- (void)setIconURL:(NSString*)iconURL
{
    [self setIconURL:iconURL placeHolderImageName:@""];
}

- (void)setIconURL:(NSString *)iconURL placeHolderImageName:(NSString *)imageName
{
   [self MUImageCache:iconURL placeHolderImageName:imageName cornerRadius:0];
    
}
- (void)setIconURL:(NSString *)iconURL placeHolderImageName:(NSString *)imageName  cornerRadius:(CGFloat)cornerRadius{
    if (!iconURL&&iconURL.length==0) {
        return;
    }
    [self MUImageCache:iconURL placeHolderImageName:imageName cornerRadius:cornerRadius];
}

- (void)MUImageCache:(NSString *)urlString placeHolderImageName:(NSString *)imageName{
    
    UIImage *placeHolderImage = nil;
    if (imageName.length > 0) {
       placeHolderImage =  [UIImage imageNamed:imageName];
    }
    [self MUImageCache:urlString placeHolderImageName:imageName cornerRadius:0];
}

- (void)MUImageCache:(NSString *)urlString placeHolderImageName:(NSString *)imageName cornerRadius:(CGFloat)cornerRadius{
    
    UIImage *placeHolderImage = nil;
    if (imageName.length > 0) {
        placeHolderImage =  [UIImage imageNamed:imageName];
    }
    
    if (placeHolderImage && cornerRadius > 0) {
          self.image = [self clipImage:placeHolderImage cornerRadius:cornerRadius];
    }else{
        
        self.image = placeHolderImage;
    }
    __weak typeof(self)weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong typeof(weakSelf)self = weakSelf;
          self.image = [self clipImage:image cornerRadius:cornerRadius];
      
    }];
}

- (UIImage *)clipImage:(UIImage *)originalImage cornerRadius:(CGFloat)cornerRadius{
    
    if (cornerRadius > 0) {
        
        CGFloat contentsScale = [UIImageView contentsScale];
        
        UIImage* decompressedImage = originalImage;
        
        CGRect imageRect =  self.bounds;
        //        dispatch_main_sync_safe(^{
        //1.开启图片图形上下文:注意设置透明度为非透明
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, contentsScale);
        
        //2.开启图形上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        // Clip to a rounded rect
        if (cornerRadius > 0) {
            CGPathRef path = _FICDCreateRoundedRectPath(CGRectMake(0, 0,  imageRect.size.width,  imageRect.size.height), cornerRadius);
            CGContextAddPath(context, path);
            CFRelease(path);
            CGContextEOClip(context);
        }
        //Avoid image upside down when draws image
        [decompressedImage drawInRect: imageRect];
        //        CGImageRelease(decompressedImageRef);
        //6.获取图片
        decompressedImage = UIGraphicsGetImageFromCurrentImageContext();
        //7.关闭图形上下文
        UIGraphicsEndImageContext();
        
        return decompressedImage;
    }
  return  originalImage;
}
@end
