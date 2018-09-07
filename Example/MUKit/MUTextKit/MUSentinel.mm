//
//  MUSentinel.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 14/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUSentinel.h"
#import <atomic>
@implementation MUSentinel{
    int32_t value;
    std::atomic_uint _displaySentinel;
}
-(int32_t)value{
    return value;
}
-(int32_t)increase{
    return _displaySentinel.fetch_add(1);//原子操作
}
@end
