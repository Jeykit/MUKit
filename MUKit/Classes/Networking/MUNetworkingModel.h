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

typedef NS_ENUM(NSUInteger,MUNetworkingStatus){
    MUNetworkingStatusUnknown          = -1,
    MUNetworkingStatusNotReachable     = 0,
    MUNetworkingStatusReachableViaWWAN = 1,
    MUNetworkingStatusReachableViaWiFi = 2,
} ;

#define MUNetworkingModelInitialization(modelName ,parameterModel)\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)GET:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)GET:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\
+ (void)POST:(NSString *)URLString parameters:(void(^)(parameterModel * parameter))parameters images:(NSMutableArray *)images success:(void (^)(modelName *model ,NSArray<modelName *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;\

@interface MUNetworkingModel : NSObject<YYModel>

/**
 Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 */
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;



/**
 Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 */
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;




/**
 Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param progress A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 */
+ (void)GET:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;



/**
 Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 */
+ (void)GET:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;





/**
 Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param progress A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 当你需要上传大量图片时，直接把UIImage放在images数组里直接请求，然后等待请求结果
 */
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *progress))progress success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;



/**
 Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 当你需要上传大量图片时，直接把UIImage放在images数组里直接请求，然后等待请求结果
 */
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;



/**
 Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 这个方法是AFHTTPSessionManager的方法映射，区别在于参数的传递方式，以及响应数据的处理方式.
 当响应数据成功返回时，success block会根据你之前的设置通过YYModel将响应数据转换为响应的模型(默认)，模型数组、原始数据。
 当你需要上传大量图片时，直接把UIImage放在images数组里直接请求，然后等待请求结果
 */
+ (void)POST:(NSString *)URLString parameters:(void(^)(MUParameterModel * parameter))parameters images:(NSMutableArray *)images success:(void (^)(MUNetworkingModel *model ,NSArray<MUNetworkingModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg))failure;

/**
 @param statusBlock a block object to be excuted when the requesting responsed.如果你设置了‘Status’，响应数据有这个字段时，就会返回响应的数据
 @param networkingStatus a block object to be excuted when the requesting failure.当请求失败时(404、400、500....),就会执行这个block
 这个方法只需设置一次，可作为全局状态监控。处理相应业务
 */
+ (void)GlobalStatus:(void(^)(NSUInteger status,NSString *message))statusBlock networkingStatus:(void(^)(NSUInteger status))networkingStatus;



/**
 @param name MUNetworkingModel subclass name MUNetworkingModel的子类名称。这个类作为全局模型，请求回来数据会装换为当前类的模型
 @param parameter MUParameterModel subclass name MUParameterModel的子类名称.这个类为全局请求参数模型.
 @param domain  The URL used to construct requests from relative paths. 请求URL的域名
 @param certificates Https networking certificate's name. 如果当前使用的Https网络，则可设置证书名称配置相关Https证书
 @param dataFormat Return data format of 'responsedObject' when the request responsed.后台返回的响应数据的格式，需要设置的参数如下所示;
 Success:数据请求是否成功字段
 Status:响应数据的返回的相应状态
 Data:响应数据内容(需要转模型的数据)
 Message:响应数据提示消息
 Success:@"data/success"表示请求数据成功的状态‘success’，存在于data字段下,以此类推.
 */
+ (void)GlobalConfigurationWithModelName:(NSString *)name parameterModel:(NSString *)parameter domain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat;

/**
 @param name MUNetworkingModel subclass name MUNetworkingModel的子类名称。这个类作为全局模型，请求回来数据会装换为当前类的模型
 @param parameter MUParameterModel subclass name MUParameterModel的子类名称.这个类为全局请求参数模型.
 @param domain  The URL used to construct requests from relative paths. 请求URL的域名
 @param certificates Https networking certificate's name. 如果当前使用的Https网络，则可设置证书名称配置相关Https证书
 @param dataFormat Return data format of 'responsedObject' when the request responsed.后台返回的响应数据的格式，需要设置的参数如下所示;
 @param timeout request timeout.请求过期时间
 Success:数据请求是否成功字段
 Status:响应数据的返回的相应状态
 Data:响应数据内容(需要转模型的数据)
 Message:响应数据提示消息
 Success:@"data/success"表示请求数据成功的状态‘success’，存在于data字段下,以此类推.
 */
+ (void)GlobalConfigurationWithModelName:(NSString *)name parameterModel:(NSString *)parameter domain:(NSString *)domain Certificates:(NSString *)certificates dataFormat:(NSDictionary *)dataFormat timeout:(NSUInteger)timeout;

//parameters public parameters that you can cunstomiz
//parameters 用这个方法设置公用的请求参数。当重复设置时，会自动拼接之前设置过的参数。如果key已存在，会自动更新value的值。
+ (void)publicParameters:(NSDictionary *)parameters;



//parameters Request header that you can customize
//parameters 用这个方法设置请求头参数。当重复设置时，会自动拼接之前设置过的参数。如果key已存在，会自动更新value的值。
+ (void)requestHeader:(NSDictionary *)parameters;


/**
 Sets a callback to be executed when the network availability of the `baseURL` host changes.
 
 @param block A block object to be executed when the network availability of the `baseURL` host changes.. This block has no return value and takes a single argument which represents the various reachability states from the device to the `baseURL`. 当网络状态改变时会执行的block
  @param start Wheather or not start or stops monitoring for changes in network reachability status 开启或者监听网络状态改变
 */
+ (void)networkingReachabilityStartMonitoring:(BOOL)start Status:(void (^)(MUNetworkingStatus status))block;
@end
