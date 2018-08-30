//
//  MUURLSessionManager.h
//  MUKit_Example
//
//  Created by Jekity on 2018/8/25.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface MUURLSessionManager : NSObject


/**
 Creates and returns a manager for a session created with the specified configuration. This is the designated initializer.
 
 @param configuration The configuration used to create the managed session.
 
 @return A manager for a newly-created session.
 */
- (instancetype )initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

- (NSURLSessionDataTask *)downloadDataTaskWithRequest:(NSURLRequest *)request
                                             progress:(void(^)(UIImage *progressiveImage))progress
                                                   destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                             completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;
@end
NS_ASSUME_NONNULL_END
