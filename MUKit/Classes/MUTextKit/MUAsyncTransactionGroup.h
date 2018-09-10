//
//  MUAsyncTransactionGroup.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 11/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUAsyncTransaction;
@interface MUAsyncTransactionGroup : NSObject
+ (MUAsyncTransactionGroup *)mainTransactionGroup;
+ (void)commit;

/// Add a transaction container to be committed.
/// @see ASAsyncTransactionContainer
- (void)addTransaction:(MUAsyncTransaction *)container;

@end
