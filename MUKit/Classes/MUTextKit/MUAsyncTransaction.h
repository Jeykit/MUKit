//
//  MUAsyncTransaction.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 6/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MUAsyncTransaction;
typedef void(^asyncdisplay_async_transaction_completion_block_t)(MUAsyncTransaction *completedTransaction,BOOL canceled);//事务完成block
typedef id<NSObject>_Nullable(^asyncdisplay_async_transaction_operation_block_t)(void);

typedef void(^asyncdisplay_async_transaction_operation_complection_block_t)(id<NSObject>_Nullable value,BOOL canceled);
typedef void(^asyncdisplay_async_transaction_complete_async_operation_block_t)(id<NSObject> _Nullable value);
typedef void(^asyncdisplay_async_transaction_async_operation_block_t)(asyncdisplay_async_transaction_complete_async_operation_block_t completeOperationBlock);

typedef NS_ENUM(NSUInteger,MUAsyncTransactionState) {
    MUAsyncTransactionStateOpen = 0,
    MUAsyncTransactionStateCommited,
    MUAsyncTransactionStateCanceled,
    MUAsyncTransactionStateComplete
};
extern NSInteger const MUDefaultTransactionPriority;
@interface MUAsyncTransaction : NSObject
-(instancetype)initWithCallbackQueue:(nullable dispatch_queue_t)callbackQueue
                     completionBlock:(nullable asyncdisplay_async_transaction_completion_block_t)complectionBlock;
-(void)waitUntilComplete;
@property (nonatomic,strong,readonly)dispatch_queue_t callbackQueue;
@property (nonatomic,copy,readonly,nullable)asyncdisplay_async_transaction_completion_block_t complectionBlock;
@property (readonly,assign)MUAsyncTransactionState state;
//- (void)addCompletionBlock:(asyncdisplay_async_transaction_completion_block_t)completion;
- (void)addAsyncOperationWithBlock:(asyncdisplay_async_transaction_operation_block_t)block
                          priority:(NSInteger)priority
                             queue:(dispatch_queue_t)queue
                        completion:(nullable asyncdisplay_async_transaction_operation_complection_block_t)completion;
- (void)commit;
- (void)cancel;
@end
NS_ASSUME_NONNULL_END
