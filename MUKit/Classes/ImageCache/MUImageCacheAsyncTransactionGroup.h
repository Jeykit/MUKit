//
//  MUImageCacheAsyncTransactionGroup.h
//  AFNetworking
//
//  Created by Jekity on 2018/8/23.
//

#import <Foundation/Foundation.h>


@class MUImageDownloader;
@interface MUImageCacheAsyncTransactionGroup : NSObject
- (void)registerTransactionGroupAsMainRunloopObserver:(MUImageDownloader *)target;
@end
