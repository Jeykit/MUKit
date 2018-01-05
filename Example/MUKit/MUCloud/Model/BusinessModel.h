//
//  BusinessModel.h
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <YYModel.h>

@class BusinessParameterModel;
@interface BusinessModel : NSObject<YYModel>
#pragma mark -POST
+ (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

#pragma mark -GET
+ (void)GET:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
+ (void)GET:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


//#pragma mark -images
+ (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
+ (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters images:(NSMutableArray *)images success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

//添加参数
@property(nonatomic, copy)NSString *seller_id;
@property(nonatomic, copy)NSString *seller_name;
@property(nonatomic, copy)NSString *store_id;
@property(nonatomic, copy)NSString *seller_mobile;
@property(nonatomic, copy)NSString *act_limits;
@property(nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic,copy)NSString *reward;
@property (nonatomic,copy)NSString *crew;

@property (nonatomic,copy)NSString *operateNum;
@property (nonatomic,copy)NSString *recommendedNum;
@property (nonatomic,copy)NSString *sellerNum;
@property (nonatomic,copy)NSString *ifcbo;

@property (nonatomic, copy)NSString *allTurnover;
@property (nonatomic, copy)NSString *monthTurnover;
@property (nonatomic, copy)NSString *upperOperateId;
@property (nonatomic, copy)NSString *upperOperateMobile;
@property (nonatomic, copy)NSString *upperOperateName;
@property (nonatomic, copy)NSString *upperOperatename;
@property (nonatomic, copy)NSString *yesterdayRich;
@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *cbo_id;
@property (nonatomic, copy)NSString *operate_name;
@property (nonatomic, copy)NSString *operate_id;
@property (nonatomic, copy)NSString *operateShareH5;



@property(nonatomic, copy)NSString *coin;//财宝
@property(nonatomic, copy)NSString *rich;//财币
@property(nonatomic, copy)NSString *money;//余额
@property(nonatomic, copy)NSString *id;
@property(nonatomic, copy)NSString *uid;
@property(nonatomic, copy)NSString *coinchange;
@property(nonatomic, copy)NSString *coinold;
@property(nonatomic, copy)NSString *coinnew;
@property(nonatomic, copy)NSString *createtime;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *sellerred;
@property(nonatomic, copy)NSString *cost;
@property(nonatomic, copy)NSString *sellerredchange;
@property(nonatomic, copy)NSString *ratelevel;
@property(nonatomic, copy)NSString *store_name;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *msg;
@property(nonatomic, copy)NSString *typecost;
@property(nonatomic, copy)NSString *year;
@property(nonatomic, copy)NSString *month;
@property(nonatomic, copy)NSString *turnover;
@property(nonatomic, copy)NSString *mmoney;
@property(nonatomic, copy)NSString *day;
@property(nonatomic, strong)NSMutableArray *result;

@property(nonatomic, copy)NSString *typeid;
@property(nonatomic, copy)NSString *typename;
@property(nonatomic, copy)NSString *yestoday;
@property(nonatomic, copy)NSString *total;
@property(nonatomic, copy)NSString *rebate;
@property(nonatomic, copy)NSString *seller_subsidy;
@property(nonatomic, copy)NSString *order_sn;
@property(nonatomic, copy)NSString *rate;
@property (nonatomic, copy)NSString *yesterdaycoin;
@property (nonatomic, strong)NSMutableArray <BusinessModel *> *richFive;


@property(nonatomic, copy)NSString *now;
@property (nonatomic, copy)NSString *richs;


@property(nonatomic, copy)NSString *profile;
@property(nonatomic, copy)NSString *icon;
@property(nonatomic, strong)NSMutableArray *bill;

@property(nonatomic, copy)NSString *richchange;
@property(nonatomic, copy)NSString *account;
@property(nonatomic, copy)NSString *account_tname;
@property(nonatomic, copy)NSString *account_tsub;
@property(nonatomic, copy)NSString *realname;
@property(nonatomic, copy)NSString *create;

@property(nonatomic, copy)NSString *bank;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *max;
@property(nonatomic, copy)NSString *ctime;
@property(nonatomic, copy)NSString *pay_name;
@property(nonatomic, copy)NSString *urlpath;

@property(nonatomic, strong)NSMutableArray *list;
@property(nonatomic, copy)NSString *note;
@property(nonatomic, copy)NSString *richnew;
@property(nonatomic, copy)NSString *parentid;
@property(nonatomic, copy)NSString *parentsid;
@property(nonatomic, copy)NSString *grade;
//@property(nonatomic, copy)NSString *count;

@property(nonatomic, copy)NSString *store_logo;
@property(nonatomic, copy)NSString *store_state;
@property(nonatomic, copy)NSString *sc_name;
@property(nonatomic, strong)NSMutableArray *store_offline;
@property(nonatomic, strong)BusinessModel *store;
@property(nonatomic, strong)BusinessModel *store_info;

@property(nonatomic, strong)NSMutableArray *store_attr;
@property(nonatomic, copy)NSString *code;
@property(nonatomic, copy)NSString *isshow;
@property(nonatomic, copy)NSString *check;

@property(nonatomic, strong)NSMutableArray *store_album;
@property(nonatomic, copy)NSString *content_id;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *store_time;
@property(nonatomic, copy)NSString *store_end_time;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *service_phone;
@property(nonatomic, copy)NSString *store_rebate;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *product_number;
@property(nonatomic, copy)NSString *store_audit;


@property(nonatomic, copy)NSString *order;//今日订单
@property(nonatomic, copy)NSString *sum;//今日营业额
@property(nonatomic, copy)NSString *last;// 昨日补贴
@property(nonatomic, copy)NSString *countsu;//累计补贴
@property(nonatomic, copy)NSString *nickname;//用户昵称
@property(nonatomic, copy)NSString *head_pic;//
@property(nonatomic, copy)NSString *mobile;//
@property (nonatomic, copy)NSString *master_order_sn;
@property (nonatomic, copy)NSString *order_id;
@property (nonatomic, copy)NSString *sumoney;
@property (nonatomic, copy)NSString *bank_logo;
@property (nonatomic, copy)NSString *money_after;
@property (nonatomic, copy)NSString *after_rich;
@property (nonatomic, copy)NSString *img_mub;
@property (nonatomic, copy)NSString *sml_note;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *company_name;
@property (nonatomic, copy)NSString *sc_id;

@property (nonatomic, copy)NSString *rpname;
@property (nonatomic, copy)NSString *rcname;
@property (nonatomic, copy)NSString *rdname;
@property (nonatomic, copy)NSString *add_time;
@property (nonatomic, copy)NSString *companyname;

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *ladder;
@property (nonatomic, copy)NSString *rich_after;
@property (nonatomic, copy)NSString *lixi;

@property (nonatomic, copy)NSString *company_province;
@property (nonatomic, copy)NSString *company_city;
@property (nonatomic, copy)NSString *company_district;
@property (nonatomic, copy)NSString *company_address;

@property (nonatomic, copy)NSString *business_licence_number;
@property (nonatomic, copy)NSString *business_licence_cert;
@property (nonatomic, copy)NSString *legal_person;
@property (nonatomic, copy)NSString *review_msg;

@property (nonatomic, copy)NSString *lng;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *desc;
//@property (nonatomic, copy)NSString *business_licence_cert;

//@property(nonatomic, copy)NSString *name;//
@property(nonatomic, strong)NSArray <BusinessModel *>*city;//
@property(nonatomic, copy)NSString *pid;//
@property(nonatomic, strong)NSArray <BusinessModel *> *area;//
@property(nonatomic, copy)NSString *cid;//

@property(nonatomic, strong)BusinessModel *res;
@property(nonatomic, strong)BusinessModel *img;



@end
