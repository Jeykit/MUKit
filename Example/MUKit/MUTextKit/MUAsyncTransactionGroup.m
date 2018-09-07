//
//  MUAsyncTransactionGroup.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 11/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUAsyncTransactionGroup.h"
#import "MUAsyncTransaction.h"
#import <pthread.h>

#define MUAsyncTransactionAssertMainThread() NSAssert(0 != pthread_main_np(), @"This method must be called on the main thread");
static void transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info);
@interface MUAsyncTransactionGroup()
+(void)registerTransactionGropMainRunloopObserver:(MUAsyncTransactionGroup *)transactionGroup;
-(void)commit;
@end
@implementation MUAsyncTransactionGroup{
    NSHashTable *_containers;
}
+(MUAsyncTransactionGroup *)mainTransactionGroup
{
    static MUAsyncTransactionGroup *mainTransactionGroup;
    if (mainTransactionGroup == nil) {
        
        mainTransactionGroup = [[MUAsyncTransactionGroup alloc]init];
        [self registerTransactionGropMainRunloopObserver:mainTransactionGroup];
    }
    return mainTransactionGroup;
}

+(void)registerTransactionGropMainRunloopObserver:(MUAsyncTransactionGroup *)transactionGroup{
    MUAsyncTransactionAssertMainThread();
    static CFRunLoopObserverRef observer;
    NSAssert(observer == NULL,@"you can not registered observer on the main runloop twice");
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | kCFRunLoopExit);
    CFRunLoopObserverContext context = {
        0,
        (__bridge void*)transactionGroup,
        &CFRetain,
        &CFRelease,
        NULL
    };
    observer = CFRunLoopObserverCreate(NULL, activities, YES, INT_MAX, &transactionGroupRunLoopObserverCallback, &context);
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
}
-(instancetype)init{
    if (self = [super init]) {
        
        _containers = [NSHashTable hashTableWithOptions:NSHashTableObjectPointerPersonality];
    }
    return self;
}
-(void)addTransaction:(MUAsyncTransaction *)transaction{
    MUAsyncTransactionAssertMainThread();
    NSAssert(transaction != nil, @"No transaction");
    [_containers addObject:transaction];
}
-(void)commit{
    MUAsyncTransactionAssertMainThread();
    if ([_containers count]) {
        
        NSHashTable *containtnersToCommit = _containers;
        _containers = [NSHashTable hashTableWithOptions:NSHashTableObjectPointerPersonality];
        for (MUAsyncTransaction *transaction in containtnersToCommit) {
            [transaction commit];
        }
        
    }

}
+(void)commit{
    [[MUAsyncTransactionGroup mainTransactionGroup] commit];
}
@end

static void transactionGroupRunLoopObserverCallback(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info){
//    MUAsyncTransactionAssertMainThread();
    MUAsyncTransactionGroup *group = (__bridge MUAsyncTransactionGroup *)info;
    [group commit];
    
}
