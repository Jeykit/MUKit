//
//  MUImageRetrieveOperation.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageRetrieveOperation.h"

@implementation MUImageRetrieveOperation {
    NSMutableArray* _blocks;
    RetrieveOperationBlock _retrieveBlock;
}

- (instancetype)initWithRetrieveBlock:(RetrieveOperationBlock)block
{
    if (self = [super init]) {
        _retrieveBlock = block;
    }
    return self;
}

- (void)addBlock:(MUImageCacheRetrieveBlock)block
{
    if (!_blocks) {
        _blocks = [NSMutableArray array];
    }
    if (block) {
        if (_blocks) {
            [_blocks addObject:block];
        }
    }
}

- (void)executeWithImage:(UIImage*)image
{
    for (MUImageCacheRetrieveBlock block in _blocks) {
        if (block) {
            block(self.name, image , self.filePath);
        }
    }
    [_blocks removeAllObjects];
}

- (void)main
{
    if (self.isCancelled) {
        return;
    }
    
    UIImage* image = _retrieveBlock();
    [self executeWithImage:image];
}

- (void)cancel
{
    if (self.isFinished)
        return;
    [super cancel];
    
    [self executeWithImage:nil];
}

@end
