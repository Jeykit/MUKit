//
//  MUModel.m
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUModel.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation MUModel


#pragma mark -model
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id",@"iddCard":@"idCard"};
}
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
  return  @{@"Content":[MUModel class],
            @"BuildingList":[MUModel class],
            };
}
@end
#pragma clang diagnostic pop
