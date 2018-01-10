//
//  BusinessHTTPSessionManager.m
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "BusinessHTTPSessionManager.h"
#import "BusinessUserDataModel.h"
#import <YYModel.h>
#import "MUBaseClass.h"



NSString *BusinessDomainName = @"http://www.baishisc.com";
//#define BusinessDomainName @"http://www.baishisc.com"
@interface BusinessHTTPSessionManager()
@property(nonatomic, strong)AFHTTPSessionManager *sessionManager;
@end
@implementation BusinessHTTPSessionManager
    
#pragma mark - init
+(instancetype)sharedInstance{
    static __weak BusinessHTTPSessionManager * instance;
    BusinessHTTPSessionManager * strongInstance = instance;
    @synchronized (self) {
        if (strongInstance == nil) {
            strongInstance                = [[[self class]alloc]init];
            instance                      = strongInstance;
#ifdef DEBUG
            BusinessDomainName = @"http://test.baishisc.com";
#endif
        }
    }
    return strongInstance;

}
#pragma mark -images
-(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData>))block progress:(void (^)(NSProgress *))progress success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObject))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    
    if (!URLString) {
        return;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BusinessDomainName,URLString];
    //内置参数
    NSMutableDictionary *mDict = [self dictionaryWithModle:parameters];
    #ifdef DEBUG
    NSLog(@"URL=%@",requestURL);
    NSLog(@"parameters======%@",mDict);
    #endif
     // 在parameters里存放照片以外的对象
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.sessionManager POST:requestURL parameters:mDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        if (block) {
            block(formData);
        }
        if (images) {
            for (int i = 0; i < images.count; i++) {
               
                UIImage *image = images[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 1.);
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *name = [NSString stringWithFormat:@"image%d", i + 1];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg", dateString, i + 1];
                
                /*
                 *该方法的参数
                 1. appendPartWithFileData：要上传的照片[二进制流]
                 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                 3. fileName：要保存在服务器上的文件名
                 4. mimeType：上传的文件的类型
                 */
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
            }
        }
        
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self modelWithDictionary:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(task,error,error.localizedDescription);
    }];

}
-(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters images:(NSMutableArray *)images formData:(void (^)(id<AFMultipartFormData>))block success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    
    [self POST:URLString parameters:parameters images:images formData:block progress:nil success:success failure:failure];
}

#pragma mark -GET
-(void)GET:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters progress:(void (^)(NSProgress *))progress success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    if (!URLString) {
        return;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BusinessDomainName,URLString];
    //内置参数
    NSMutableDictionary *mDict = [self dictionaryWithModle:parameters];
    #ifdef DEBUG
    NSLog(@"URL=%@",requestURL);
    NSLog(@"parameters======%@",mDict);
    #endif
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.sessionManager GET:requestURL parameters:mDict progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [self modelWithDictionary:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         failure(task,error,error.localizedDescription);
    }];
}
-(void)GET:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}
#pragma mark-POST
-(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters progress:(void (^)(NSProgress *))progress success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{

    if (!URLString) {
        return;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BusinessDomainName,URLString];
    //内置参数
    NSMutableDictionary *mDict = [self dictionaryWithModle:parameters];
    #ifdef DEBUG
    NSLog(@"URL=%@",requestURL);
    NSLog(@"parameters======%@",mDict);
    #endif
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.sessionManager POST:requestURL parameters:mDict progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self modelWithDictionary:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failure(task,error,@"网络差，请稍后重试");
    }];
    
}

-(void)POST:(NSString *)URLString parameters:(void (^)(BusinessParameterModel *))parameters success:(void (^)(BusinessModel *, NSArray<BusinessModel *> *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    [self POST:URLString parameters:parameters progress:nil success:success failure:failure];
}

#pragma -mark 初始化
-(NSMutableDictionary *)dictionaryWithModle:(void (^)(BusinessParameterModel *))parameters{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"unique_id"]) {
        NSString * string  = [[NSUserDefaults standardUserDefaults]objectForKey:@"unique_id"];
         [mDict setObject:string forKey:@"unique_id"];
    }else{
         [mDict setObject:[self getUUID] forKey:@"unique_id"];
    }
    [mDict setObject:@"ios" forKey:@"client"];
    if ([BusinessUserDataModel sharedInstance].token) {
        [mDict setObject:[BusinessUserDataModel sharedInstance].token forKey:@"token"];
    }
    if ([BusinessUserDataModel sharedInstance].seller_id) {
        [mDict setObject:[BusinessUserDataModel sharedInstance].seller_id forKey:@"seller_id"];
    }
    if ([BusinessUserDataModel sharedInstance].store_id) {
        [mDict setObject:[BusinessUserDataModel sharedInstance].store_id forKey:@"store_id"];
    }
    //外部参数
    BusinessParameterModel *parameter = [BusinessParameterModel new];
    if (parameters) {
        parameters(parameter);
        NSError *error = nil;
        NSString *jsonString = [parameter yy_modelToJSONString];
        NSData *data         = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        [mDict addEntriesFromDictionary:dict];
    }
    return mDict;
}
-(void)modelWithDictionary:(id )responseObject success:(void (^)(BusinessModel *model ,NSArray<BusinessModel *> *modelArray ,id responseObjects))success failure:(void (^)(NSURLSessionDataTask *, NSError *, NSString *))failure{
    NSDictionary *resultDict = responseObject;
    NSUInteger status = [resultDict[@"status"] integerValue];
    NSLog(@"%@",[self dictionaryToJson:responseObject]);
    if (status == 1) {//请求成功
        
        BusinessModel *model = nil;
        NSMutableArray <BusinessModel *>*resultmodelArray = [NSMutableArray array];
        if ([responseObject[@"result"] isKindOfClass:[NSArray class]]) {
            NSArray <BusinessModel *> *arr = responseObject[@"result"];
            
            [arr enumerateObjectsUsingBlock:^(BusinessModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BusinessModel * resultmodel = [BusinessModel yy_modelWithDictionary:responseObject[@"result"][idx]];
                
                [resultmodelArray addObject:resultmodel];
            }];
            
        }else{
            model = [BusinessModel yy_modelWithDictionary:responseObject[@"result"]];
        }
        
        if (success) {
            success(model,resultmodelArray,resultDict);
        }
    }else {//token
        [self nendTologin:status message:resultDict[@"msg"]];
        failure(nil,nil,resultDict[@"msg"]);
    }

}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma -mark Login
-(void)nendTologin:(NSUInteger)status message:(NSString *)message{
    switch (status) {
        case -100:
        [self login];
        break;
        case -101:
        [self login];
        break;
        case -102:
        [self login];
        break;
        case 0:
//        [self login];
        break;
        default:
//            [SVProgressHUD showInfoWithStatus:message];
//         [self alertView:message];
        break;
    }
}
-(void)login{
    UIViewController *controller = [NSClassFromString(@"ZCHBSellerLoginController") new];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
    NSString *objet = [[NSUserDefaults standardUserDefaults]valueForKey:@"userGroupID"];
    if ([objet integerValue] != 0) {
        navigationController.navigationBarBackgroundImageMu = [UIImage imageFromGradientColorMu:@[[UIColor colorWithHexString:@"#3f7beb"],[UIColor colorWithHexString:@"#6d99fc"]] gradientType:  MUGradientTypeUpleftToLowright imageSize:CGSizeMake(kScreenWidth, controller.navigationBarAndStatusBarHeight)];
    }else{
         navigationController.navigationBarBackgroundImageMu = [UIImage imageFromGradientColorMu:@[[UIColor colorWithHexString:@"#FEA38A"],[UIColor colorWithHexString:@"#F64D31"]] gradientType:MUGradientTypeLeftToRight imageSize:CGSizeMake(kScreenWidth, controller.navigationBarAndStatusBarHeight)];
    }
    navigationController.titleColorMu                   = [UIColor whiteColor];
    navigationController.navigationBarTintColor         = [UIColor whiteColor];
    navigationController.barStyleMu                     = UIBarStyleBlack;
    navigationController.statusBarStyleMu               = UIStatusBarStyleLightContent;
    navigationController.backIndicatorImageMu           = [UIImage imageNamed:@"(--"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
}
//-(void)alertView:(NSString *)message{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
//}

- (NSString *)getUUID
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
    {
        NSString *string =  [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"unique_id"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return  string;
    }
    else
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        NSString *string =  (__bridge_transfer NSString *)uuid;
        [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"unique_id"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return string;
    }
}
//懒加载
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
//        self.sessionManager.requestSerializer.timeoutInterval = 20;
//        self.sessionManager.responseSerializer.acceptableContentTypes =
//        [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg",
//         @"image/png", @"application/octet-stream", @"text/json", @"image/jpeg",nil];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/octet-stream", @"image/jpeg",@"multipart/form-data",nil];
        _sessionManager.requestSerializer.timeoutInterval = 8;
#ifdef DEBUG
        BusinessDomainName = @"http://test.baishisc.com";
#endif
        //如果需要可以在这里添加请求头
//        [_sessionManager setSecurityPolicy:[self customSecurityPolicy]];
//        
//        [_sessionManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"X-Requested-With"];
//        [_sessionManager.requestSerializer setValue:@"2" forHTTPHeaderField:@"from"];
//        [_sessionManager.requestSerializer setValue:[self getCurrentVersion] forHTTPHeaderField:@"appv"];
//        _sessionManager.securityPolicy     = [self customSecurityPolicy];
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"header"] valueForKey:@"t"]) {
//            
//            [_sessionManager.requestSerializer
//             setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"header"] valueForKey:@"t"]
//             forHTTPHeaderField:@"t"];
//        }
//        
        
    }
    return _sessionManager;
}
    
//添加证书,Https必需需要
- (AFSecurityPolicy *)customSecurityPolicy {
    //先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"213983660940391.cer" ofType:nil]; //证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:certData, nil];
    return securityPolicy;
}

    
@end
