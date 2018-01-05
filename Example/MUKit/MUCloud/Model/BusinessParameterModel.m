//
//  BusinessParameterModel.m
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "BusinessParameterModel.h"

@implementation BusinessParameterModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"NEW2_password":@"new2_password",@"NEW1_password":@"new1_password"};
}
@end
