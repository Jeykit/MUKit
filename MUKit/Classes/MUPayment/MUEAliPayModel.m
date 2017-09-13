//
//  MUEAliPayModel.m
//  Pods
//
//  Created by Jekity on 2017/8/25.
//
//

#import "MUEAliPayModel.h"
#import <AlipaySDK/AlipaySDK.h>

@interface MUEAliPayModel()
@property(nonatomic, strong)MUEAliPayModel *tempModel;
@end
static void(^resultBlock)(NSDictionary * resultDictionary);
@implementation MUEAliPayModel
+(instancetype)sharedInstance{
    
    static __weak MUEAliPayModel * instance;
    MUEAliPayModel * strongInstance = instance;
    @synchronized (self) {
        
        if (strongInstance == nil) {
            strongInstance = [[[self class]alloc]init];
            instance       = strongInstance;
        }
    }
    strongInstance.tempModel = strongInstance;
    return strongInstance;
}
-(void)performAliPayment:(NSString *)privateKey appScheme:(NSString *)scheme result:(void(^)(NSDictionary *))result{
    if (!privateKey) {
        NSLog(@"the privateKey can not be empty.By defaluts,it is come from your server");
        return;
    }
    if (!scheme) {
        NSLog(@"the scheme can not be empty!By defaluts,it defined in URL types by yourself");
    }
     NSLog(@"scheme scheme-------%@",scheme);
    resultBlock = result;
    [[AlipaySDK defaultService] payOrder:privateKey fromScheme:scheme callback:^(NSDictionary *resultDic) {
        if (resultBlock) {
            resultBlock(resultDic);
            self.tempModel = nil;
        }
        
    }];
}
-(instancetype)init{
    if (self = [super init]) {
        
        self.tempModel = self;
    }
    return self;
}
//-(BOOL)muHookedApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)dictionary
//{
//     
//     NSLog(@"mualipay didFinishLaunchingWithOptions-------");
//     [self muHookedApplication:application didFinishLaunchingWithOptions:dictionary];
//     return YES;
//}
- (BOOL)defaultApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)dictionary{
     
     return YES;
}
/**
 当用户通过其它应用启动本应用时，
 会回调这个方法，
 url参数是其它应用调用openURL:方法时传过来的。
 */
- (BOOL)muEAlipayApplication:(UIApplication *)application openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     if ([url.host isEqualToString:@"safepay"]) {
          //跳转支付宝钱包进行支付，处理支付结果
          [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
               if (resultBlock) {
                   resultBlock(resultDic);
                   self.tempModel = nil;
               }
          }];
     }
     return [self muEAlipayApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
/** 9.0以后使用新API接口
 
 当用户通过其它应用启动本应用时，
 会回调这个方法，
 url参数是其它应用调用openURL:方法时传过来的。
 */

- (BOOL)muEAlipayApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
     
     if ([url.host isEqualToString:@"safepay"]) {
          //跳转支付宝钱包进行支付，处理支付结果
          [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           
               if (resultBlock) {
                    resultBlock(resultDic);
                   self.tempModel = nil;
               }
          }];
     }
     return [self muEAlipayApplication:app openURL:url options:options];
}
- (BOOL)muDefalutEAlipayApplication:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
     return YES;
}
- (BOOL)muDefalutEAlipayApplication:(UIApplication *)application openURL:(NSURL *)url
                  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
     return YES;
}
//-(void)dealloc{
//    NSLog(@"MUEAliPayModel被释放了");
//}
@end
