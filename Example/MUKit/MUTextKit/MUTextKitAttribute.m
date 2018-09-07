//
//  MUTextKitAttribute.m
//  MUKit_Example
//
//  Created by Jekity on 2018/9/6.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUTextKitAttribute.h"

@implementation MUTextKitAttribute
- (instancetype)init{
    if (self = [super init]) {
        
        _lineBreakMode = NSLineBreakByTruncatingTail;
        _maximumNumberOfLines = 1;
    }
    return self;
}
@end
