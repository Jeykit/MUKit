//
//  BusinessHTTPSessionManager.h
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>
#import "BusinessParameterModel.h"
#import "BusinessModel.h"

@class BusinessModel;
@class BusinessParameterModel;
@interface BusinessHTTPSessionManager : NSObject
+(instancetype)sharedInstance;
#pragma mark -POST
- (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
    
- (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

#pragma mark -GET
- (void)GET:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
- (void)GET:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;


//#pragma mark -images
- (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
- (void)POST:(NSString *)URLString parameters:(void(^)(BusinessParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;
@end
