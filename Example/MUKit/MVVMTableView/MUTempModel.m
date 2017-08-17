//
//  MUTempModel.m
//  SigmaTableViewModel
//
//  Created by zeng ping on 2017/8/14.
//  Copyright © 2017年 yangke. All rights reserved.
//

#import "MUTempModel.h"

@implementation MUTempModel
-(instancetype)initWithString:(NSString *)string{
    if (self = [super init]) {
        _name = string;
    }
    return self;
}
@end
