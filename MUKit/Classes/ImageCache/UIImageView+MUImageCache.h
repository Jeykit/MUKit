//
//  UIImageView+MUImageCache.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Draw an image in the context with specific bounds.
 */
typedef void (^MUImageIconDrawingBlock)(UIImage* image, CGContextRef context, CGRect contextBounds);

@interface UIImageView (MUImageCache)
/**
 *  Convenient method of setPlaceHolderImageName:iconURL.
 */
- (void)setIconURL:(NSString*)iconURL;
/**
 *  Download an icon, and save it using [FlyImageIconCache shareInstance].
 */
- (void)setIconURL:(NSString*)iconURL placeHolderImageName:(NSString*)imageName;

/**
 *  Download an icon, and save it using [FlyImageIconCache shareInstance].
 */
- (void)setIconURL:(NSString*)iconURL placeHolderImageName:(NSString*)imageName cornerRadius:(CGFloat)cornerRadius;
/**
 *  Set a customize drawing block. If not, it will use the default drawing method.
 */
- (void)setIconDrawingBlock:(MUImageIconDrawingBlock)block;

/**
 *  Convenient method of setPlaceHolderImageName:thumbnailURL:originalURL
 *
 *  @param url originalURL
 */
- (void)setImageURL:(NSString*)url;

/**
 *  Download images and render them with the below order:
 *  1. PlaceHolder
 *  2. Thumbnail Image
 *  3. Original Image
 *
 *  These images will be saved into [FlyImageCache shareInstance]
 */
- (void)setImageURL:(NSString*)imageURL placeHolderImageName:(NSString*)imageName;

- (void)setImageURL:(NSString*)imageURL placeHolderImageName:(NSString*)imageName cornerRadius:(CGFloat)cornerRadius;

@end
