//
//  MUSentinel.m
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 14/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUSentinel.h"
#import <libkern/OSAtomic.h>
@implementation MUSentinel{
    int32_t _value;
}
-(int32_t)value{
    return _value;
}
-(int32_t)increase{
    return OSAtomicIncrement32(&_value);
}
@end
