//
//  MUImageCacheAsyncTransactionGroup.m
//  AFNetworking
//
//  Created by Jekity on 2018/8/23.
//

#import "MUImageCacheAsyncTransactionGroup.h"
#import "MUImageDownloader.h"
#import "MUImageCache.h"

static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);
@implementation MUImageCacheAsyncTransactionGroup
#pragma mark -register runloop observer
- (void)registerTransactionGroupAsMainRunloopObserver:(MUImageDownloader *)target
{
    static CFRunLoopObserverRef observer;
    NSAssert(observer == NULL, @"A observer should not be registered on the main runloop twice");
    // defer the commit of the transaction so we can add more during the current runloop iteration
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | // before the run loop starts sleeping
                                kCFRunLoopExit);          // before exiting a runloop run
    CFRunLoopObserverContext context = {
        0,           // version
        (__bridge void *)target,  // info
        &CFRetain,   // retain
        &CFRelease,  // release
        NULL         // copyDescription
    };
    
    observer = CFRunLoopObserverCreate(NULL,        // allocator
                                       activities,  // activities
                                       YES,         // repeats
                                       INT_MAX,     // order after CA transaction commits
                                       &_transactionGroupRunLoopObserverCallback,  // callback
                                       &context);   // context
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}
@end
#pragma mark - runloop callback
static void _transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    
    [[MUImageCache sharedInstance] commit];
    
    
}
