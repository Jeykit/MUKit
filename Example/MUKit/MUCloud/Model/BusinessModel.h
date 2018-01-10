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

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *sex;
@property(nonatomic, copy)NSString *age;

@property(nonatomic, copy)NSString *cccc;

@end
