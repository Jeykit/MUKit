//
//  MUImageDownloader.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageDownloader.h"
#import "MUImageCacheUtils.h"
#import "MUImageDataFileManager.h"
#import "MUImageCache.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import "MUImageCacheAsyncTransactionGroup.h"
#import "MUURLSessionManager.h"


@interface MUImageDownloaderResponseHandler : NSObject
@property (nonatomic, strong) NSUUID* uuid;
@property (nonatomic, strong) MUImageDownloadProgressBlock processingBlock;
@property (nonatomic, strong) MUImageDownloadSuccessBlock successBlock;
@property (nonatomic, strong) MUImageDownloadFailedBlock failedBlock;
@end

@implementation MUImageDownloaderResponseHandler

- (instancetype)initWithUUID:(NSUUID*)uuid
                    progress:(MUImageDownloadProgressBlock)progress
                     success:(MUImageDownloadSuccessBlock)success
                      failed:(MUImageDownloadFailedBlock)failed
{
    if (self = [super init]) {
        self.uuid = uuid;
        self.processingBlock = progress;
        self.successBlock = success;
        self.failedBlock = failed;
    }
    return self;
}

@end

@interface MUImageDownloaderMergedTask : NSObject
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSMutableArray* handlers;
@property (nonatomic, strong) NSURLSessionTask* task;

@end

@implementation MUImageDownloaderMergedTask

- (instancetype)initWithIdentifier:(NSString*)identifier task:(NSURLSessionTask*)task
{
    if (self = [super init]) {
        self.identifier = identifier;
        self.task = task;
        self.handlers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addResponseHandler:(MUImageDownloaderResponseHandler*)handler
{
    [self.handlers addObject:handler];
}

- (void)removeResponseHandler:(MUImageDownloaderResponseHandler*)handler
{
    [self.handlers removeObject:handler];
}

- (void)clearHandlers
{
    [self.handlers removeAllObjects];
}

@end

@interface NSString (Extension)
- (NSString*)md5;
@end

@implementation NSString (Extension)
- (NSString*)md5
{
    const char* cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],
            result[1],
            result[2],
            result[3],
            result[4],
            result[5],
            result[6],
            result[7],
            result[8],
            result[9],
            result[10],
            result[11],
            result[12],
            result[13],
            result[14],
            result[15]];
}
@end

@interface MUImageDownloader ()
@property (nonatomic, strong) NSMutableDictionary* downloadFile;
@property (nonatomic, strong) NSMutableDictionary* mergedTasks;
@property (nonatomic, strong) NSMutableArray* queuedMergedTasks;
@property (nonatomic, assign) NSInteger activeRequestCount;
@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@property (nonatomic, strong) dispatch_queue_t responseQueue;
@property (nonatomic, strong) NSMutableArray * complectedTasks;
@property (nonatomic,strong) MUImageCacheAsyncTransactionGroup *transactionGroup;
@end

static NSString* kMUImageKeySuccessArray = @"sa";
static NSString* kMUImageKeyFilePath = @"fp";
static NSString* kMUImageKeyRequest = @"r";
@implementation MUImageDownloader {
    MUURLSessionManager* _sessionManager;
    NSLock *_lock;
}



+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static MUImageDownloader* __instance = nil;
    dispatch_once(&onceToken, ^{
        NSString *folderPath = [MUImageCache sharedInstance].dataFileManager.folderPath;
        __instance = [[[self class] alloc] initWithDestinationPath:folderPath];
    });
    
    return __instance;
}
- (instancetype)initWithDestinationPath:(NSString*)destinationPath
{
    if (self = [super init]) {
        
        _maxDownloadingCount = 5;
        _mergedTasks = [[NSMutableDictionary alloc] initWithCapacity:_maxDownloadingCount];
        _queuedMergedTasks = [[NSMutableArray alloc] initWithCapacity:_maxDownloadingCount];
        _complectedTasks = [NSMutableArray arrayWithCapacity:100];
        
        _lock = [[NSLock alloc]init];
        _destinationPath = [destinationPath copy];
        
        
        NSString* name = [NSString stringWithFormat:@"com.MUImage.imagedownloader.synchronizationqueue-%@", [[NSUUID UUID] UUIDString]];
        self.synchronizationQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        name = [NSString stringWithFormat:@"com.MUImage.imagedownloader.responsequeue-%@", [[NSUUID UUID] UUIDString]];
        self.responseQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
        
        NSString* configurationIdentifier = [NSString stringWithFormat:@"com.MUImage.downloadsession.%@", [[NSUUID UUID] UUIDString]];
        NSURLSessionConfiguration* configuration = [MUImageDownloader configurationWithIdentifier:configurationIdentifier];
        _sessionManager = [[MUURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        //register runloop
        _transactionGroup = [MUImageCacheAsyncTransactionGroup new];
        [_transactionGroup registerTransactionGroupAsMainRunloopObserver:self];
    }
    return self;
}

+ (NSURLSessionConfiguration*)configurationWithIdentifier:(NSString*)identifier
{
    NSURLSessionConfiguration* configuration;
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 1100)
    configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
#else
    configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
#endif
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    
    return configuration;
}

- (MUImageDownloadHandlerId*)downloadImageForURLRequest:(NSURLRequest*)request
{
    return [self downloadImageForURLRequest:request
                                   progress:nil
                                    success:nil
                                     failed:nil
                           updatedProogress:NO];
}

- (MUImageDownloadHandlerId*)downloadImageForURLRequest:(NSURLRequest*)request
                                                success:(MUImageDownloadSuccessBlock)success
                                                 failed:(MUImageDownloadFailedBlock)failed
{
    return [self downloadImageForURLRequest:request
                                   progress:nil
                                    success:success
                                     failed:failed
                           updatedProogress:NO];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
- (MUImageDownloadHandlerId*)downloadImageForURLRequest:(NSURLRequest*)request
                                               progress:(MUImageDownloadProgressBlock)progress
                                                success:(MUImageDownloadSuccessBlock)success
                                                 failed:(MUImageDownloadFailedBlock)failed
                                       updatedProogress:(BOOL)updatedProogress
{
    NSParameterAssert(request != nil);
    
    __block MUImageDownloadHandlerId* handlerId = nil;
    dispatch_sync(_synchronizationQueue, ^{
        if (request.URL.absoluteString == nil) {
            if (failed) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
                dispatch_main_sync_safe(^{
                    failed(request, error);
                });
            }
            return;
        }
        
        NSString *identifier = [request.URL.absoluteString md5];
        handlerId = [NSUUID UUID];
        
        // 1) Append the success and failure blocks to a pre-existing request if it already exists
        MUImageDownloaderMergedTask *existingMergedTask = self.mergedTasks[identifier];
        if (existingMergedTask != nil) {
            MUImageDownloaderResponseHandler *handler = [[MUImageDownloaderResponseHandler alloc]
                                                         initWithUUID:handlerId
                                                         progress:progress
                                                         success:success
                                                         failed:failed];
            [existingMergedTask addResponseHandler:handler];
            return;
        }
        
        
        
        NSURLSessionTask *task = nil;
        if (progress && updatedProogress) {
            task = [self handlerDownload:request progress:progress identifier:identifier];
        }else{
            task =  [self handlerDownload:request identifier:identifier];
        }
        // 4) Store the response handler for use when the request completes
        existingMergedTask = [[MUImageDownloaderMergedTask alloc] initWithIdentifier:identifier task:task];
        self.mergedTasks[ identifier ] = existingMergedTask;
        
        MUImageDownloaderResponseHandler *handler = [[MUImageDownloaderResponseHandler alloc]
                                                     initWithUUID:handlerId
                                                     progress:progress
                                                     success:success
                                                     failed:failed];
        [existingMergedTask addResponseHandler:handler];
        
        // 5) Either start the request or enqueue it depending on the current active request count
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            [self startMergedTask:existingMergedTask];
        } else {
            [self enqueueMergedTask:existingMergedTask];
        }
    });
    
    return handlerId;
}

- (NSURLSessionTask *)handlerDownload:(NSURLRequest *)request identifier:(NSString *)identifier{
    __weak __typeof__(self) weakSelf = self;
    return [_sessionManager downloadTaskWithRequest:request
                                        destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                            return [NSURL fileURLWithPath:[_destinationPath stringByAppendingPathComponent:identifier]];
                                        }
                                  completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                      dispatch_async(weakSelf.responseQueue, ^{
                                          __strong __typeof__(weakSelf) strongSelf = weakSelf;
                                          MUImageDownloaderMergedTask *mergedTask = strongSelf.mergedTasks[identifier];
                                          if (error != nil) {
                                              
                                              NSArray *tempArray = [mergedTask.handlers mutableCopy];
                                              for (MUImageDownloaderResponseHandler *handler in tempArray) {
                                                  if (handler.failedBlock) {
                                                      handler.failedBlock(request, error);
                                                  }
                                              }
                                              
                                              // remove error file
                                              [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                                          }else{
                                              
                                              NSArray *tempArray = [mergedTask.handlers copy];
                                              for (MUImageDownloaderResponseHandler *handler in tempArray) {
                                                  if (handler.successBlock) {
                                                      handler.successBlock(request, filePath);
                                                  }
                                              }
                                          }
                                          
                                          // remove exist task
                                          [strongSelf.mergedTasks removeObjectForKey:identifier];
                                          
                                          [strongSelf safelyDecrementActiveTaskCount];
                                          [strongSelf safelyStartNextTaskIfNecessary];
                                      });
                                  }];
}

#pragma mark -渐进显示下载
- (NSURLSessionTask *)handlerDownload:(NSURLRequest *)request
                             progress:(MUImageDownloadProgressBlock)progress
                           identifier:(NSString *)identifier{
    __weak __typeof__(self) weakSelf = self;
    return [_sessionManager downloadDataTaskWithRequest:request
                                               progress:progress
                                            destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                return [NSURL fileURLWithPath:[_destinationPath stringByAppendingPathComponent:identifier]];
                                            }
                                      completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                          dispatch_async(weakSelf.responseQueue, ^{
                                              __strong __typeof__(weakSelf) strongSelf = weakSelf;
                                              MUImageDownloaderMergedTask *mergedTask = strongSelf.mergedTasks[identifier];
                                              if (error != nil) {
                                                  
                                                  NSArray *tempArray = [mergedTask.handlers copy];
                                                  for (MUImageDownloaderResponseHandler *handler in tempArray) {
                                                      if (handler.failedBlock) {
                                                          handler.failedBlock(request, error);
                                                      }
                                                  }
                                                  
                                                  // remove error file
                                                  [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                                              }else{
                                                  
                                                  NSArray *tempArray = [mergedTask.handlers copy];
                                                  for (MUImageDownloaderResponseHandler *handler in tempArray) {
                                                      if (handler.successBlock) {
                                                          handler.successBlock(request, filePath);
                                                      }
                                                  }
                                              }
                                              
                                              // remove exist task
                                              [strongSelf.mergedTasks removeObjectForKey:identifier];
                                              
                                              [strongSelf safelyDecrementActiveTaskCount];
                                              [strongSelf safelyStartNextTaskIfNecessary];
                                          });
                                      }];
    
}
- (void)cancelDownloadHandler:(MUImageDownloadHandlerId*)handlerId
{
    NSParameterAssert(handlerId != nil);
    
    dispatch_sync(_synchronizationQueue, ^{
        
        MUImageDownloaderMergedTask *matchedTask = nil;
        MUImageDownloaderResponseHandler *matchedHandler = nil;
        
        NSArray *tempMergedTask = [self.mergedTasks mutableCopy];
        for (NSString *URLIdentifier in tempMergedTask) {
            MUImageDownloaderMergedTask *mergedTask = self.mergedTasks[ URLIdentifier ];
            for (MUImageDownloaderResponseHandler *handler in mergedTask.handlers) {
                if ( [handler.uuid isEqual:handlerId] ) {
                    matchedHandler = handler;
                    matchedTask = mergedTask;
                    break;
                }
            }
        }
        
        if ( matchedTask == nil ) {
            NSArray * queuedMergedTask = [_queuedMergedTasks mutableCopy];
            for (MUImageDownloaderMergedTask *mergedTask in queuedMergedTask) {
                for (MUImageDownloaderResponseHandler *handler in mergedTask.handlers) {
                    if ( [handler.uuid isEqual:handlerId] ) {
                        matchedHandler = handler;
                        matchedTask = mergedTask;
                        break;
                    }
                }
            }
        }
        
        if ( matchedTask == nil || matchedHandler == nil ) {
            return;
        }
        [matchedTask removeResponseHandler:matchedHandler];
        
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:nil];
        dispatch_main_sync_safe(^{
            if ( matchedHandler.failedBlock != nil ){
                matchedHandler.failedBlock(nil, error);
            }
        });
        
        // remove this task from both merged and queued tasks
        if (matchedTask.handlers.count == 0) {
            
            if ( [_delegate respondsToSelector:@selector(MUImageDownloader:willCancelRequest:)] ) {
                dispatch_main_sync_safe(^{
                    [_delegate MUImageDownloader:self willCancelRequest:matchedTask.task.originalRequest];
                });
            }
            
            [matchedTask.task cancel];
            
            [self.mergedTasks removeObjectForKey:matchedTask.identifier];
            [_queuedMergedTasks removeObject:matchedTask];
        }
    });
}

- (BOOL)isActiveRequestCountBelowMaximumLimit
{
    return self.activeRequestCount < self.maxDownloadingCount;
}

- (void)startMergedTask:(MUImageDownloaderMergedTask*)mergedTask
{
    if ([_delegate respondsToSelector:@selector(MUImageDownloader:willSendRequest:)]) {
        dispatch_main_sync_safe(^{
            [_delegate MUImageDownloader:self willSendRequest:mergedTask.task.originalRequest];
        });
    }
    
    [mergedTask.task resume];
    ++self.activeRequestCount;
}

- (void)enqueueMergedTask:(MUImageDownloaderMergedTask*)mergedTask
{
    // default is AFImageDownloadPrioritizationLIFO
    [_queuedMergedTasks insertObject:mergedTask atIndex:0];
}

- (MUImageDownloaderMergedTask*)dequeueMergedTask
{
    MUImageDownloaderMergedTask* mergedTask = nil;
    mergedTask = [_queuedMergedTasks lastObject];
    [self.queuedMergedTasks removeObject:mergedTask];
    return mergedTask;
}

- (void)safelyDecrementActiveTaskCount
{
    dispatch_sync(_synchronizationQueue, ^{
        if (self.activeRequestCount > 0) {
            self.activeRequestCount -= 1;
        }
    });
}

- (void)safelyStartNextTaskIfNecessary
{
    dispatch_sync(_synchronizationQueue, ^{
        while ([self isActiveRequestCountBelowMaximumLimit] && [_queuedMergedTasks count] > 0 ) {
            MUImageDownloaderMergedTask *mergedTask = [self dequeueMergedTask];
            [self startMergedTask:mergedTask];
        }
    });
}

#pragma clang diagnostic pop
@end


