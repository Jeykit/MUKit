//
//  MUImageRenderer.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MUImageRenderer;
@protocol MUImageRendererDelegate <NSObject>

/**
 *  Callback before download image.
 */
- (void)MUImageRenderer:(MUImageRenderer*)render
        willRenderImage:(UIImage*)image
               imageKey:(NSString *)imageKey
           imageFilePath:(NSString *)imageFilePath;

- (void)MUImageIconRenderer:(MUImageRenderer*)render
            willRenderImage:(UIImage*)image
                   imageKey:(NSString *)imageKey
               imageFilePath:(NSString *)imageFilePath;

- (void)MUImageIconRenderer:(MUImageRenderer*)render
                   drawImage:(UIImage*)image
                     context:(CGContextRef)context
                      bounds:(CGRect)contextBounds;

@optional

- (void)MUImageRenderer:(MUImageRenderer*)render didDownloadImageURL:(NSURL*)url progress:(float)progress;

@end

/**
 *  Internal class to download, draw, and retrieve images.
 */
@interface MUImageRenderer : NSObject

@property (nonatomic, weak) id<MUImageRendererDelegate> delegate;

- (void)setPlaceHolderImageName:(NSString*)imageName
                    originalURL:(NSURL*)originalURL
                       drawSize:(CGSize)drawSize
                contentsGravity:(NSString* const)contentsGravity
                   cornerRadius:(CGFloat)cornerRadius;

- (void)setPlaceHolderImageName:(NSString*)imageName
                        iconURL:(NSURL*)iconURL
                       drawSize:(CGSize)drawSize;
@end
