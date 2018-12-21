//
//  MUImageDownloader.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MUImageDownloadProgressBlock)(UIImage *progressiveImage);
typedef void (^MUImageDownloadSuccessBlock)(NSURLRequest* request, NSURL* filePath);
typedef void (^MUImageDownloadFailedBlock)(NSURLRequest* request, NSError* error);
typedef NSUUID MUImageDownloadHandlerId; // Unique ID of handler

@class MUImageDownloader;
@protocol MUImageDownloaderDelegate <NSObject>

@optional
/**
 *  Callback before sending request.
 */
- (void)MUImageDownloader:(MUImageDownloader*)manager
          willSendRequest:(NSURLRequest*)request;

/**
 *  Callback after complete download.
 */
- (void)MUImageDownloader:(MUImageDownloader*)manager
       didReceiveResponse:(NSURLResponse*)response
                 filePath:(NSURL*)filePath
                    error:(NSError*)error
                  request:(NSURLRequest*)request;

/**
 *  Callback after cancel some request.
 */
- (void)MUImageDownloader:(MUImageDownloader*)manager
        willCancelRequest:(NSURLRequest*)request;

@end

@interface MUImageDownloader : NSObject

@property (nonatomic, weak) id<MUImageDownloaderDelegate> delegate;
@property (nonatomic, copy) NSString* destinationPath;
@property (nonatomic, assign) NSInteger maxDownloadingCount; // Default is 5;

/**
 *  Create a FlyImageDownloader with a default destination path.
 */
+ (instancetype)sharedInstance;
/**
 *  Create a FlyImageDownloader with a specific destination path.
 */
- (instancetype)initWithDestinationPath:(NSString*)destinationPath;

- (MUImageDownloadHandlerId*)downloadImageForURLRequest:(NSURLRequest*)request;

/**
 *  Send a download request with callbacks
 */
- (MUImageDownloadHandlerId*)downloadImageForURLRequest:(NSURLRequest*)request
                                                success:(MUImageDownloadSuccessBlock)success
                                                 failed:(MUImageDownloadFailedBlock)failed;


/**
 *  Send a download request with callbacks
 */
- (MUImageDownloadHandlerId*)downloadImageForURLRequest:(NSURLRequest*)request
                                               progress:(MUImageDownloadProgressBlock)progress
                                                success:(MUImageDownloadSuccessBlock)success
                                                 failed:(MUImageDownloadFailedBlock)failed
                                                 updatedProogress:(BOOL)updatedProogress;

/**
 *  Cancel a downloading request.
 *
 *  @param handlerId can't be nil
 */
- (void)cancelDownloadHandler:(MUImageDownloadHandlerId*)handlerId;

@end
