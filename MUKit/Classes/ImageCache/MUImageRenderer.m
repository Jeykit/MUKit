//
//  MUImageRenderer.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageRenderer.h"
#import "MUImageCache.h"
#import "MUImageCacheUtils.h"
#import "MUImageDownloader.h"
#import "MUImageIconCache.h"



@interface MUImageRenderer ()

@end

@implementation MUImageRenderer {
    NSString* _placeHolderImageName;
    //    NSURL* _originalURL;
    CGSize _drawSize;
    NSString* _contentsGravity;
    CGFloat _cornerRadius;
    BOOL _progress;
    
    MUImageDownloadHandlerId* _downloadHandlerId;
    MUImageDownloadHandlerId* _downloadIconHandlerId;
}

- (instancetype)init
{
    if (self = [super init]) {
        // event
        if ([MUImageCache sharedInstance].autoDismissImage) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationWillEnterForeground:)
                                                         name:UIApplicationWillEnterForegroundNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidEnterBackground:)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelDownload];
    
    if ([MUImageCache sharedInstance].autoDismissImage) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}
- (CGFloat)cornerRadius{
    return _cornerRadius;
}
#pragma image-------
- (void)applicationDidEnterBackground:(UIApplication*)application
{
    [self cancelDownload];
    
    // clear image data to reduce memory
    [self renderImage:nil imageKey:nil imageFileURL:nil];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // repaint
    [self render];
}

- (void)cancelDownload
{
    if (_downloadHandlerId != nil) {
        [[MUImageDownloader sharedInstance] cancelDownloadHandler:_downloadHandlerId];
        _downloadHandlerId = nil;
    }
    
    if (_downloadIconHandlerId != nil) {
        [[MUImageDownloader sharedInstance] cancelDownloadHandler:_downloadIconHandlerId];
        _downloadIconHandlerId = nil;
    }
    // try to cancel getting image operation.
    //    if (_originalURL) {
    //        [[MUImageCache sharedInstance] cancelGetImageWithKey:_originalURL.absoluteString];
    //    }
    
}

- (void)setPlaceHolderImageName:(NSString*)imageName
                    originalURL:(NSURL*)originalURL
                       drawSize:(CGSize)drawSize
                contentsGravity:(NSString* const)contentsGravity
                   cornerRadius:(CGFloat)cornerRadius
                       progress:(BOOL)progress
{
    
    if (_originalURL != nil && [_originalURL.absoluteString isEqualToString:originalURL.absoluteString]) {
        return;
    }
    
    if (!self.downloading || !progress) {
        [self cancelDownload];
        
    }
    
    _placeHolderImageName = imageName;
    _originalURL = originalURL;
    _progress = progress;
    _drawSize = CGSizeMake(round(drawSize.width), round(drawSize.height));
    _contentsGravity = contentsGravity;
    _cornerRadius = cornerRadius;
    
    [self render];
}

- (void)render
{
    
    //0 clear
    [self renderImage:nil imageKey:nil imageFileURL:nil];
    // if has already downloaded original image
    NSString* originalKey = _originalURL.absoluteString;
    if (originalKey != nil && [[MUImageCache sharedInstance] isImageExistWithKey:originalKey]) {
        __weak __typeof__(self) weakSelf = self;
        [[MUImageCache sharedInstance] asyncGetImageWithKey:originalKey
                                                   drawSize:_drawSize
                                            contentsGravity:_contentsGravity
                                               cornerRadius:_cornerRadius
                                                  completed:^(NSString* key, UIImage* image ,NSString *filePath) {
                                                      dispatch_main_async_safe(^{
                                                          [weakSelf renderOriginalImage:image key:key imageFileURL:filePath];
                                                      });
                                                  }];
        return;
    }
   
    UIImage *progressive = [[MUImageCacheUtils sharedInstance]getProgressiveImageWithKey:originalKey];
    if (progressive) {
         [self renderImage:progressive imageKey:nil imageFileURL:nil];
    }else if (_placeHolderImageName != nil) {
        UIImage* placeHolderImage = [UIImage imageNamed:_placeHolderImageName];
        [self renderImage:placeHolderImage imageKey:nil imageFileURL:nil];
    }else if (originalKey != nil) {
        [self renderImage:nil imageKey:nil imageFileURL:nil];
    }
   
    if (originalKey == nil) {
        return;
    }
    [self downloadOriginal];
}

- (void)downloadOriginal
{
    
    
    __weak __typeof__(self) weakSelf = self;
    __block NSURL* downloadingURL = _originalURL;
    __block NSString* downloadingKey = downloadingURL.absoluteString;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:downloadingURL];
    request.timeoutInterval = 30; // Default 30 seconds
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
    _downloadHandlerId = [[MUImageDownloader sharedInstance]
                          downloadImageForURLRequest:request
                          progress:^(UIImage *progressiveImage) {
                              if ( [_delegate respondsToSelector:@selector(MUImageRenderer:didDownloadImageURL:progressive:)]){
                                  if (progressiveImage) {
                                      UIImage *renderImage = [MUImageCacheUtils drawImageWithdrawSize:_drawSize CornerRadius:_cornerRadius originalImage:progressiveImage];
                                      [[MUImageCacheUtils sharedInstance] addProgressiveImageWithKey:downloadingKey progressive:renderImage];
                                      [_delegate MUImageRenderer:self didDownloadImageURL:downloadingURL progressive:renderImage];
                                  }
                              }
                          }
                          success:^(NSURLRequest* request, NSURL* filePath) {
                              _downloadHandlerId = nil;
                              
                              [[MUImageCacheUtils sharedInstance] removeProgressiveImageWithKey:downloadingKey];
                              
                              [[MUImageCache sharedInstance] addImageWithKey:downloadingKey
                                                                    filename:filePath.lastPathComponent
                                                                    drawSize:_drawSize
                                                             contentsGravity:_contentsGravity
                                                                cornerRadius:_cornerRadius
                                                                   completed:^(NSString *key, UIImage *image ,NSString *filePaths) {
                                                                       dispatch_main_async_safe(^{
                                                                           
                                                                           [weakSelf renderOriginalImage:image key:key imageFileURL:filePaths];
                                                                       });
                                                                   }];
                              
                          }
                          failed:^(NSURLRequest* request, NSError* error) {
                              _downloadHandlerId = nil;
                            [[MUImageCacheUtils sharedInstance] removeProgressiveImageWithKey:downloadingKey];
                          }
                          updatedProogress:_progress];
#pragma clang diagnostic pop
}

- (void)renderOriginalImage:(UIImage*)image key:(NSString*)key imageFileURL:(NSString *)imageFileURL
{
    if ( ![key isEqualToString:_originalURL.absoluteString] ) {
        return;
    }
    [self renderImage:image imageKey:key imageFileURL:imageFileURL];
}

- (void)renderImage:(UIImage*)image imageKey:(NSString *)imageKey imageFileURL:(NSString *)imageFileURL
{
    [_delegate MUImageRenderer:self willRenderImage:image imageKey:imageKey imageFilePath:imageFileURL];
}

#pragma mark -icon
- (void)setPlaceHolderImageName:(NSString*)imageName
                        iconURL:(NSURL*)iconURL
                       drawSize:(CGSize)drawSize
                   cornerRadius:(CGFloat)cornerRadius
{
    
    if (_iconURL != nil && [_iconURL.absoluteString isEqualToString:iconURL.absoluteString]) {
        return;
    }
    
    if (!self.downloading) {
        [self cancelDownload];
        
    }
    
    _iconURL = iconURL;
    _cornerRadius = cornerRadius;
    _drawSize = CGSizeMake(round(drawSize.width), round(drawSize.height));
    
    [self renderWithPlaceHolderImageName:imageName];
}

- (void)renderWithPlaceHolderImageName:(NSString*)imageName
{
    //0 clear
    [self renderImage:nil key:nil imageFileURL:nil];
    NSString* key = _iconURL.absoluteString;
    // if has already downloaded image
    if (key != nil && [[MUImageIconCache sharedInstance] isImageExistWithKey:key]) {
        __weak __typeof__(self) weakSelf = self;
        [[MUImageIconCache sharedInstance] asyncGetImageWithKey:key
                                                      completed:^(NSString* key, UIImage* image ,NSString *filePath) {
                                                          dispatch_main_async_safe(^{
                                                              
                                                              [weakSelf renderImage:image key:key imageFileURL:filePath];
                                                          });
                                                      }];
        
        return;
    }
   if (imageName != nil) {
        UIImage* placeHolderImage = [UIImage imageNamed:imageName];
        dispatch_main_async_safe(^{
            [self doRenderImage:placeHolderImage imageKey:nil imageFileURL:nil];
        });
    }else if (key != nil) {
        // clear
        dispatch_main_async_safe(^{
            [self doRenderImage:nil imageKey:nil imageFileURL:nil];
        });
    }
    
    if (key == nil) {
        return;
    }
    
    [self downloadImage];
}

- (void)downloadImage
{
    __weak __typeof__(self) weakSelf = self;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:_iconURL];
    request.timeoutInterval = 30; // Default 30 seconds
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
    _downloadIconHandlerId = [[MUImageDownloader sharedInstance]
                              downloadImageForURLRequest:request
                              success:^(NSURLRequest* request, NSURL* filePath) {
                                  
                                  NSString *downloadedKey = request.URL.absoluteString;
                               
                                      
                                      [[MUImageCache sharedInstance] addImageWithKey:downloadedKey
                                                                            filename:[filePath lastPathComponent]
                                                                           completed:nil];
                                 
                                  
                                  // In case downloaded image is not equal with the new url
                                  if ( ![downloadedKey isEqualToString:weakSelf.iconURL.absoluteString] ) {
                                      return;
                                  }
                                  
                                  _downloadIconHandlerId = nil;
                                  [weakSelf drawIconWithKey:downloadedKey url:filePath];
                                  
                              }
                              failed:^(NSURLRequest* request, NSError* error) {
                                  _downloadIconHandlerId = nil;
                              }];
#pragma clang diagnostic pop
}

- (void)drawIconWithKey:(NSString*)key url:(NSURL*)url
{
    __weak __typeof__(self) weakSelf = self;
    NSURL *newURL = url;
    NSData *fileData = [NSData dataWithContentsOfURL:newURL];
    UIImage *image = [MUImageCacheUtils getImageWithDada:fileData];
    [[MUImageIconCache sharedInstance] addImageWithKey:key size:_drawSize originalImage:image cornerRadius:_cornerRadius completed:^(NSString *key, UIImage *image, NSString *filePath) {
         [weakSelf renderImage:image key:key imageFileURL:filePath];
    }];
  
}

- (void)renderImage:(UIImage*)image key:(NSString*)key imageFileURL:(NSString *)imageFileURL
{
    if ( ![_iconURL.absoluteString isEqualToString:key] ) {
        return;
    }
     [self doRenderImage:image imageKey:key imageFileURL:imageFileURL];
}

- (void)doRenderImage:(UIImage*)image imageKey:(NSString *)imageKey imageFileURL:(NSString *)imageFileURL
{
    [_delegate MUImageIconRenderer:self willRenderImage:image imageKey:imageKey imageFilePath:imageFileURL];
}
@end
