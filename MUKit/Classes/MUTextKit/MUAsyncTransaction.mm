//
//  MUAsyncTransaction.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 6/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUAsyncTransaction.h"
#import <UIKit/UIApplication.h>
#import <list>
#import <mutex>
#import <map>
#import <stdatomic.h>

#define MUAsyncTransactionAssertMainThread() NSAssert(0 != pthread_main_np(), @"This method must be called on the main thread");
NSInteger const MUDefaultTransactionPriority = 0;
@interface MUAsyncTransactionOperation : NSObject
- (instancetype)initWithOperationCompletionBlock:(asyncdisplay_async_transaction_operation_complection_block_t)operationCompletionBlock;
@property (nonatomic, copy) asyncdisplay_async_transaction_operation_complection_block_t operationCompletionBlock;
@property (nonatomic, strong) id<NSObject> value; // set on bg queue by the operation block
@end

@implementation MUAsyncTransactionOperation


-(instancetype)initWithOperationCompletionBlock:(asyncdisplay_async_transaction_operation_complection_block_t)operationCompletionBlock{
    if (self = [super init]) {
        _operationCompletionBlock = operationCompletionBlock;
    }
    return self;
}
- (void)dealloc
{
    NSAssert(_operationCompletionBlock == nil, @"Should have been called and released before -dealloc");
}
- (void)callAndReleaseCompletionBlock:(BOOL)canceled;
{
    if (_operationCompletionBlock) {
        _operationCompletionBlock(self.value, canceled);
        // Guarantee that _operationCompletionBlock is released on _callbackQueue:
        self.operationCompletionBlock = nil;
    }
}
@end
class MUAsyncTransactionQueue
{
public:
    class Group//Similar to dispath_group_t
    {
    public:
        virtual void enter() = 0;//used when manually executing blocks
        virtual void leave() = 0;
        virtual void wait()  = 0 ;//wait until all scheduled blocks finnished executing
        virtual void schedule(NSUInteger priority,dispatch_queue_t queue,dispatch_block_t block)=0;
        virtual void release() = 0;
        virtual void notify(dispatch_queue_t queue,dispatch_block_t block)  = 0;
    protected:
        virtual ~Group(){};//call release() instead
    };
    
    Group * createGroup();//create new group
    static MUAsyncTransactionQueue &instance();
    
private:
    struct GroupNotify
    {
        dispatch_block_t block;
        dispatch_queue_t queue;
    };
    class GroupImplement:public Group
    {
    public:
        GroupImplement(MUAsyncTransactionQueue &queue)
        :mu_pendingOperations(0)
        ,mu_releaseCalled(false)
        ,mu_queue(queue)
        {
            
        }
        virtual void enter();//used when manually executing blocks
        virtual void leave();
        virtual void wait() ;//wait until all scheduled blocks finnished executing
        virtual void schedule(NSUInteger priority,dispatch_queue_t queue,dispatch_block_t block);
        virtual void notify(dispatch_queue_t queue,dispatch_block_t block);//执行完block，就通知提交结果
        virtual void release();
        int mu_pendingOperations;
        std::list<GroupNotify>mu_notifyList;
        std::condition_variable mu_condition;
        BOOL mu_releaseCalled;
        MUAsyncTransactionQueue &mu_queue;
        
    };
    struct Operation
    {
        dispatch_block_t block;
        GroupImplement *mu_group;
        NSUInteger priority;
    };
    
    struct DispatchEntry//entry for each dispatch queue
    {
        typedef std::list<Operation> operationQueue;
        typedef std::list<operationQueue::iterator> operationIteratorList;
        
        operationQueue mu_operationQueue;
        operationIteratorList mu_operationIteratorList;
        typedef std::map<NSInteger, operationIteratorList> OperationPriorityMap; // sorted by priority
          OperationPriorityMap _operationPriorityMap;
        int mu_threadCount;
        
        Operation popNextOperation(BOOL respectPriority);//assumes locked mutex
        void pushOperation(Operation operation);//assumes locked mutex
        
    };
    
    std::map<dispatch_queue_t, DispatchEntry>mu_entries;
    std::mutex mu_mutex;
};
MUAsyncTransactionQueue::Group * MUAsyncTransactionQueue::createGroup(){
    
    Group *result = new GroupImplement(*this);
    return result;
}

MUAsyncTransactionQueue &MUAsyncTransactionQueue::instance(){
    
    static MUAsyncTransactionQueue *instance = new MUAsyncTransactionQueue();
    return *instance;
}
void MUAsyncTransactionQueue::GroupImplement::enter(){
    
    std::lock_guard<std::mutex> l(mu_queue.mu_mutex);
    ++mu_pendingOperations;
}
void MUAsyncTransactionQueue::GroupImplement::leave(){
    std::lock_guard<std::mutex> l(mu_queue.mu_mutex);
    --mu_pendingOperations;
    if (mu_pendingOperations == 0) {
        
        std::list<GroupNotify> notifyList;
        mu_notifyList.swap(notifyList);
        for (GroupNotify &notify : notifyList ) {
            dispatch_async(notify.queue, notify.block);
        }
        mu_condition.notify_one();//如果block全部提前执行完，就主动提交结果
        if (mu_releaseCalled) {
            delete this;
        }
    }
}
void MUAsyncTransactionQueue::GroupImplement::wait(){
    
    std::unique_lock<std::mutex>locker(mu_queue.mu_mutex);
    while (mu_pendingOperations > 0) {
        mu_condition.wait(locker);
    }
}
void MUAsyncTransactionQueue::GroupImplement::release(){
    std::lock_guard<std::mutex> l(mu_queue.mu_mutex);
    if (mu_pendingOperations == 0) {
        delete this;
    }else{
        mu_releaseCalled = YES;
    }
}
void MUAsyncTransactionQueue::GroupImplement::notify(dispatch_queue_t queue,dispatch_block_t block){
    
    std::lock_guard<std::mutex>l(mu_queue.mu_mutex);
    if (mu_pendingOperations == 0) {
        dispatch_async(queue, block);//displayBlock全部执行完之后，执行完成后的complectionBlock
    }else{
        GroupNotify notify;
        notify.block = block;
        notify.queue = queue;
        mu_notifyList.push_back(notify);
    }
}
void MUAsyncTransactionQueue::DispatchEntry::pushOperation(MUAsyncTransactionQueue::Operation operation){//把operation封装进list里
    
    mu_operationQueue.push_back(operation);
    operationIteratorList &list = _operationPriorityMap[operation.priority];
    list.push_back(--mu_operationQueue.end());
}
MUAsyncTransactionQueue::Operation MUAsyncTransactionQueue::DispatchEntry::popNextOperation(BOOL respectPriority){//把list里的operation出栈
    operationQueue::iterator queueIterator;
    OperationPriorityMap::iterator mapIterator;
    NSCAssert(!mu_operationQueue.empty() && !_operationPriorityMap.empty(), @"No scheduled operations available");
    if (respectPriority) {
        mapIterator = --_operationPriorityMap.end();  // highest priority "bucket"
        queueIterator = *mapIterator->second.begin();
    } else {
        queueIterator = mu_operationQueue.begin();
        mapIterator = _operationPriorityMap.find(queueIterator->priority);
    }
    
    // no matter what, first item in "bucket" must match item in queue
    NSCAssert(mapIterator->second.front() == queueIterator, @"Queue inconsistency");
    
    Operation res = *queueIterator;
    mu_operationQueue.erase(queueIterator);
    
    mapIterator->second.pop_front();
    if (mapIterator->second.empty()) {
        _operationPriorityMap.erase(mapIterator);
    }
    
    return res;
}
void MUAsyncTransactionQueue::GroupImplement::schedule(NSUInteger priority, dispatch_queue_t queue, dispatch_block_t block){//调度执行displayBlock
    MUAsyncTransactionQueue &q = mu_queue;
    std::lock_guard<std::mutex>l(q.mu_mutex);
    Operation operation;//把dispalyBlock 封装成Operation
    operation.block    = block;
    operation.mu_group = this;
    operation.priority = priority;
    
    DispatchEntry &entery = q.mu_entries[queue];//取map，queue对应dispatchEntry
    entery.pushOperation(operation);
//    operation.mu_group->enter();
    ++mu_pendingOperations;
    NSUInteger maxThreadCount = [NSProcessInfo processInfo].activeProcessorCount * 2;
    if ([[NSRunLoop mainRunLoop].currentMode isEqualToString:UITrackingRunLoopMode]) {
        //we can give main thread more cpu time during tracking
        --maxThreadCount;
    }
    if (entery.mu_threadCount < maxThreadCount) {//限制最大线程数
        
        BOOL respectPriority = entery.mu_threadCount > 0;
        ++entery.mu_threadCount;
//        NSLog(@"--------------%d",entery.mu_threadCount);
        dispatch_async(queue, ^{
            
            std::unique_lock<std::mutex>lock(mu_queue.mu_mutex);
            while (!entery.mu_operationQueue.empty()) {
                Operation operation = entery.popNextOperation(respectPriority);
                lock.unlock();
                if (operation.block) {
                    
                    operation.block();
                }
                operation.mu_group->leave();
                operation.block = nil;
                lock.lock();
            }
            --entery.mu_threadCount;
            if (entery.mu_threadCount == 0) {//operation已经被调度，没有线程执行
                
                q.mu_entries.erase(queue);
            }
        });
    }
    
    
}
@implementation MUAsyncTransaction
{
    MUAsyncTransactionQueue::Group *_group;
    NSMutableArray<MUAsyncTransactionOperation *>*_operations;
     _Atomic(MUAsyncTransactionState) _state;
}
-(instancetype)initWithCallbackQueue:(dispatch_queue_t)callbackQueue completionBlock:(asyncdisplay_async_transaction_completion_block_t)complectionBlock{
    if (self = [super init]) {
        
        if (callbackQueue == nil) {
            callbackQueue = dispatch_get_main_queue();
        }
        _callbackQueue = callbackQueue;
        _complectionBlock = complectionBlock;
        _state = ATOMIC_VAR_INIT(MUAsyncTransactionStateOpen);
//        [self waitUntilComplete];
    }
    return self;
}
-(void)setState:(MUAsyncTransactionState)state{
    atomic_store(&_state, state);
}
-(MUAsyncTransactionState)state{
  return  atomic_load(&_state);
}
-(void)addAsyncOperationWithBlock:(asyncdisplay_async_transaction_operation_block_t)block priority:(NSInteger)priority queue:(dispatch_queue_t)queue completion:(asyncdisplay_async_transaction_operation_complection_block_t)completion{

    MUAsyncTransactionAssertMainThread();//这个方法只能在主线程调用
    NSAssert(self.state == MUAsyncTransactionStateOpen, @"你只能在主线程添加这个方法");
    [self ensureTransactionData];//初始化对象
    MUAsyncTransactionOperation *operation = [[MUAsyncTransactionOperation alloc]initWithOperationCompletionBlock:completion];
    [_operations addObject:operation];
    _group->schedule(priority, queue, ^{
        
        @autoreleasepool {
            
            if (self.state != MUAsyncTransactionStateCanceled) {
                operation.value = block();
            }
        }
    });
    
//    NSLog(@"operation count----------------------%ld",_operations.count);

}
-(void)commit{
    MUAsyncTransactionAssertMainThread();
    NSAssert(self.state == MUAsyncTransactionStateOpen, @"你不能提交两次事务");
    self.state = MUAsyncTransactionStateCommited;
    if (_operations.count == 0) {
        
        if (_complectionBlock) {
            _complectionBlock(self,NO);
        }
    }else{
         NSAssert(_group != NULL, @"还有操作未提交，你应该创建group");
        _group->notify(_callbackQueue, ^{
            
            MUAsyncTransactionAssertMainThread();
            [self completeTransaction];
        });
    }
}
-(void)completeTransaction
{
    MUAsyncTransactionState state = self.state;
    if (state != MUAsyncTransactionStateComplete) {
    
        BOOL isCanceled = (state == MUAsyncTransactionStateCanceled);
        for (MUAsyncTransactionOperation *operation in _operations) {
            
            [operation callAndReleaseCompletionBlock:isCanceled];
        }
        self.state = MUAsyncTransactionStateComplete;
        if (_complectionBlock) {
            _complectionBlock(self,isCanceled);
        }
    }
}
-(void)waitUntilComplete{
    MUAsyncTransactionAssertMainThread();
    
    if (self.state != MUAsyncTransactionStateComplete) {
        
        if (_group) {
            NSAssert(_callbackQueue == dispatch_get_main_queue(), nil);
            _group->wait();
            NSAssert(self.state != MUAsyncTransactionStateOpen, @"你不应该打开后在提交一个事务");
        }
        [self completeTransaction];
    }
}
-(void)cancel{
    MUAsyncTransactionAssertMainThread();
    NSAssert(self.state != MUAsyncTransactionStateOpen, @"你只能取消一个已提交的事务");
    self.state = MUAsyncTransactionStateCanceled;
}
-(void)ensureTransactionData{//懒加载数据
    if (_group == nil) {
        
        _group = MUAsyncTransactionQueue::instance().createGroup();
    }
    if (_operations == nil) {
        _operations = [[NSMutableArray alloc]init];
    }
    
}
@end
