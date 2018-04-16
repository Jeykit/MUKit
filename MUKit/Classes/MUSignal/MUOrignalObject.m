//
//  MUOrignalObject.m
//  AFNetworking
//
//  Created by Jekity on 2018/4/16.
//

#import "MUOrignalObject.h"

@implementation MUOrignalObject
- (instancetype)initWithBlock:(DeallocBlock)block
{
    if (self = [super init]){
        self.block = block;
    }
    return self;
}
- (void)dealloc {
    self.block ? self.block() : nil;
}
@end
