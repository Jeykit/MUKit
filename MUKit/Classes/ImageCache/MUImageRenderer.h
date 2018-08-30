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


@optional

- (void)MUImageRenderer:(MUImageRenderer*)render didDownloadImageURL:(NSURL*)url progressive:(UIImage *)progressiveImage;


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
                   cornerRadius:(CGFloat)cornerRadius
                       progress:(BOOL)progress;

- (void)setPlaceHolderImageName:(NSString*)imageName
                        iconURL:(NSURL*)iconURL
                       drawSize:(CGSize)drawSize
                   cornerRadius:(CGFloat)cornerRadius;

@property (nonatomic, strong ,readonly) NSURL* iconURL;
@property (nonatomic,strong ,readonly) NSURL *originalURL;
@property (nonatomic,assign) BOOL downloading;
@property (nonatomic,assign ,readonly) CGFloat cornerRadius;
@end
