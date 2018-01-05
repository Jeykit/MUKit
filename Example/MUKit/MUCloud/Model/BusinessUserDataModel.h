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
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *store_name;//商家名称
@property(nonatomic, copy)NSString *password;//登录密码

@property(nonatomic, copy)NSString *domain;
@property(nonatomic, copy)NSString *operate_id;
@property(nonatomic, copy)NSString *operate_name;
@property(nonatomic, copy)NSString *operate_Name;
@property(nonatomic, copy)NSString *mobile;
@property(nonatomic, copy)NSString *companyname;//公司名称
@property(nonatomic, copy)NSString *store_logo;
@property(nonatomic, copy)NSString *cbo_id;

+ (void)save;//

@end
