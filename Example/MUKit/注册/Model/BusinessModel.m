//
//  BusinessModel.m
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "BusinessModel.h"
#import "BusinessHTTPSessionManager.h"


@implementation BusinessModel


#pragma mark -model
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{};
}
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
  return  @{@"result":[BusinessModel class]};
}
















#pragma mark- network
+(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters progress:(void (^)(NSProgress *))progress success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [[BusinessHTTPSessionManager sharedInstance] POST:URLString parameters:parameters progress:progress success:success failure:failure];;
}
+(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [[BusinessHTTPSessionManager sharedInstance] POST:URLString parameters:parameters success:success failure:failure];
}

+(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData>))block  progress:(void (^)(NSProgress *))progress success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [[BusinessHTTPSessionManager sharedInstance]POST:URLString parameters:parameters images:images formData:block success:success failure:failure];
}
+(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData>))block  success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [[BusinessHTTPSessionManager sharedInstance]POST:URLString parameters:parameters images:images formData:block success:success failure:failure];
}
+(void)GET:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters progress:(void (^)(NSProgress *))progress success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [[BusinessHTTPSessionManager sharedInstance]GET:URLString parameters:parameters progress:progress success:success failure:failure];
}
+(void)GET:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [[BusinessHTTPSessionManager sharedInstance]GET:URLString parameters:parameters success:success failure:failure];
}
@end
