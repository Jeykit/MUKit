//
//  MUHTTPSessionManager.h
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "MUNetworkingModel.h"
#import "MUParameterModel.h"

@class MUNetworkingModel;
@interface MUHTTPSessionManager : NSObject
+(instancetype)sharedInstance;
@property (nonatomic,weak,readonly) AFHTTPSessionManager *httpsManager;


- (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<NSObject *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
    
- (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters success:(void (^)(MUNetworkingModel *model ,NSArray<NSObject *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

#pragma mark -GET
- (void)GET:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<NSObject *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
- (void)GET:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters success:(void (^)(MUNetworkingModel *model ,NSArray<NSObject *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


//#pragma mark -images
- (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<NSObject *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

- (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(MUNetworkingModel *model ,NSArray<NSObject *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


-(void)GlobalStatus:(void(^)(NSUInteger status,NSString *message))statusBlock networkingStatus:(void(^)(NSUInteger status))networkingStatus;

+(void)GlobalConfigurationWithModelName:(NSString *)name parameterModel:(NSString *)parameter domain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat timeout:(NSUInteger)timeout;
//参数配置第一个参数为域名，第二个为证书名称，第三个为数据格式@{@"Success":@"Success"}
//+(void)GlobalConfigurationWithModelName:(NSString *)name parameterModel:(NSString *)parameter domain:(NSString *)domain Certificates:(NSString *)certificates requestHeader:(NSDictionary *)header publicParameters:(NSDictionary *)parameters dataFormat:(NSDictionary *)dataFormat;
+(void)GlobalConfigurationWithModelName:(NSString *)name parameterModel:(NSString *)parameter domain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat;
//公共参数
+(void)publicParameters:(NSDictionary *)parameters;
//qing
+(void)requestHeader:(NSDictionary *)parameters;
@end
