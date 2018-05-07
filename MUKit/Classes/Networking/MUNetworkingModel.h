//
//  MUNetworkingModel.h
//  MUKit_Example
//
//  Created by Jekity on 2018/5/7.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <YYModel.h>
#import "MUParameterModel.h"


#define MUNetworkingModelInitialization(modelName ,parameterModel)\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)GET:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)GET:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters images:(NSMutableArray *)images success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\

@interface MUNetworkingModel : NSObject<YYModel>
#pragma mark -POST
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

#pragma mark -GET
+ (void)GET:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
+ (void)GET:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


//#pragma mark -images
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
////参数配置第一个参数为域名，第二个为证书名称，第三个为数据格式@{@"Success":@"Success"}
+(void)GlobalStatus:(void(^)(NSUInteger status,NSString *message))statusBlock networkingStatus:(void(^)(NSUInteger status))networkingStatus;

//参数配置第一个参数为域名，第二个为证书名称，第三个为数据格式@{@"Success":@"Success"}
// NSString *sucessKey       = dataFormatMU[@"Success"];//请求数据成功的字段
//NSString *statusKey       = dataFormatMU[@"Status"];//请求数据的状态码字段
//NSString *dataKey         = dataFormatMU[@"Data"];//请求数据的内容体
//NSString *messageKey      = dataFormatMU[@"Message"];//请求数据的提示消息
//并且支持多层嵌套 如
//Success @"data/success"  //数据字段
//+(void)GlobalConfigurationWithDomain:(NSString *)domain Certificates:(NSString *)certificates requestHeader:(NSDictionary *)header publicParameters:(NSDictionary *)parameters dataFormat:(NSDictionary *)dataFormat;
+(void)GlobalConfigurationWithModelName:(NSString *)name parameterModel:(NSString *)parameter domain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat;

//公共参数
+(void)publicParameters:(NSDictionary *)parameters;
//qing
+(void)requestHeader:(NSDictionary *)parameters;
@end
