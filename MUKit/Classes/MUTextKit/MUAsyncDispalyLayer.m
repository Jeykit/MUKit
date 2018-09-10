//
//  MUAsyncDispalyLayer.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 6/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUAsyncDispalyLayer.h"
#import "MUAsyncTransaction.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "MUAsyncTransactionGroup.h"
#import "MUTextKitNode.h"

@interface MUAsyncDispalyLayer()

@end
@implementation MUAsyncDispalyLayer{
    NSLock *_lock;
    BOOL _displaySuspended;
    id<MUAsyncDispalyLayerDelegate> __weak _asyncDelegate;
}
+(id)defaultValueForKey:(NSString *)key{
    
    if ([key isEqualToString:@"displaysAsynchronously"]) {
        return @(YES);
    }else{
        return [super defaultValueForKey:key];
    }
}
+(dispatch_queue_t)displayQueue{
    static dispatch_queue_t displayQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayQueue = dispatch_queue_create("org.Jekity.AsyncDisplayLayer.dispalyqueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_set_target_queue(displayQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    });
    return displayQueue;
}
- (instancetype)init
{
    if ((self = [super init])) {
        
        self.opaque = YES;
        _lock = [[NSLock alloc]init];
    }
    return self;
}
-(id<MUAsyncDispalyLayerDelegate>)asyncDelegate{
    
    [_lock lock];
    id<MUAsyncDispalyLayerDelegate> delegate = _asyncDelegate;
    [_lock unlock];
    return delegate;
}
-(void)setDelegate:(id<CALayerDelegate>)delegate{
    [super setDelegate:delegate];
}
-(void)setAsyncDelegate:(id<MUAsyncDispalyLayerDelegate>)asyncDelegate{
    NSAssert(!asyncDelegate || [asyncDelegate isKindOfClass:[MUTextKitNode class]], @"MUDisplayLayer is inherently coupled to MUDisplayNode and cannot be used with another asyncDelegate.  Please rethink what you are trying to do.");
    [_lock lock];
    _asyncDelegate = asyncDelegate;
    [_lock unlock];
}
- (BOOL)isDisplaySuspended{
    return _displaySuspended;
}

- (void)setDisplaySuspended:(BOOL)displaySuspended
{
    if (_displaySuspended != displaySuspended) {
        _displaySuspended = displaySuspended;
        if (!displaySuspended) {
            // If resuming display, trigger a display now.
            [self setNeedsDisplay];
        } else {
            // If suspending display, cancel any current async display so that we don't have contents set on us when it's finished.
            [self cancelAsyncDisplay];
        }
    }
}

-(void)setContents:(id)contents{
    [super setContents:contents];
}
-(void)setNeedsLayout{
    [super setNeedsLayout];
}
-(void)layoutSublayers{
    [super layoutSublayers];
}

-(void)setNeedsDisplay{
    
    [self cancelAsyncDisplay];
    [super setNeedsDisplay];
}

-(void)display{
    
    if (self.isDisplaySuspended) {
        return;
    }
    super.contents = super.contents;
    id<MUAsyncDispalyLayerDelegate>NS_VALID_UNTIL_END_OF_SCOPE strongAsyncDelegate;
    {
        
        [_lock lock];
        strongAsyncDelegate = _asyncDelegate;
        [_lock unlock];
    }
     [strongAsyncDelegate willDisplayAsyncLayer:self asynchously:YES];

}

-(void)cancelAsyncDisplay{
   
    id<MUAsyncDispalyLayerDelegate>NS_VALID_UNTIL_END_OF_SCOPE strongDelegate;
    {
        [_lock lock];
        strongDelegate = _asyncDelegate;
        [_lock unlock];
    }
    [strongDelegate cancelDisplayAsyncLayer:self];
}
@end
