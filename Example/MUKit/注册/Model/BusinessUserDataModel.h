//
//  BusinessUserDataModel.h
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessUserDataModel : NSObject
+(instancetype)sharedInstance;
@property(nonatomic, copy)NSString *seller_id;//商家id
@property(nonatomic, copy)NSString *seller_name;//商家名称
@property(nonatomic, copy)NSString *store_id;
@property(nonatomic, copy)NSString *seller_mobile;
@property(nonatomic, copy)NSString *group_id;
@property(nonatomic, copy)NSString *act_limits;
@property(nonatomic, copy)NSString *smt_limits;
@property(nonatomic, copy)NSString *token;
@end
