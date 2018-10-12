//
//  MUEPaymentManager.m
//  Pods
//
//  Created by Jekity on 2017/8/25.
//
//

#import "MUEPaymentManager.h"
#import "MULoadingModel.h"
#import "MUHookMethodHelper.h"
#import "MUEAliPayModel.h"
#import "MUEWeChatPayModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

static MULoadingModel const *model;
void initializationLoading(){//initalization loading model
    
    if (model == nil) {
        unsigned int outCount;
        Class *classes = objc_copyClassList(&outCount);
        for (int i = 0; i < outCount; i++) {
            if (class_getSuperclass(classes[i]) == [MULoadingModel class]){
                Class object = classes[i];
                model = (MULoadingModel *)[[object alloc]init];
                break;
            }
        }
        free(classes);
    }
}

@implementation MUEPaymentManager
+(void)load{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        initializationLoading();
        if (model == nil) {
            NSLog(@"you can't use 'MUEPayment' because you haven't a subclass of 'MULoadingModel' or you don't init a subclass of 'MULoadingModel'");
            return ;
        }
        model.AppDelegateName = model.AppDelegateName?:@"AppDelegate";
        //Alipay
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if (NSClassFromString(@"MUSharedObject")&&model.weChatSharedID.length>0) {
            
            Class sharedObject = NSClassFromString(@"MUSharedObject");
            NSObject *object = [sharedObject new];
            void(*action)(id,SEL,id,id,id) = (void(*)(id,SEL,id,id,id))objc_msgSend;
            action(object,@selector(registerApiKeysWithWeChatKey:QQKey:weibokey:),model.weChatSharedID,model.QQID,model.weiboID);
        }else{
            [WXApi registerApp:model.weChatPayID];//注册微信
        }
        [MUHookMethodHelper muHookMethod:model.AppDelegateName orignalSEL:@selector(application:openURL:sourceApplication:annotation:) defalutSEL:@selector(muDefalutEAlipayApplication:openURL:sourceApplication:annotation:) newClassName:NSStringFromClass([MUEAliPayModel class]) newSEL:@selector(muEAlipayApplication:openURL:sourceApplication:annotation:)];
        
        
        [MUHookMethodHelper muHookMethod:model.AppDelegateName orignalSEL:@selector(application:openURL:options:) defalutSEL:@selector(muDefalutEAlipayApplication:openURL:options:) newClassName:NSStringFromClass([MUEAliPayModel class]) newSEL:@selector(muEAlipayApplication:openURL:options:)];
        
        //weChat
        
        
        [MUHookMethodHelper muHookMethod:model.AppDelegateName orignalSEL:@selector(application:openURL:sourceApplication:annotation:) defalutSEL:@selector(muDefalutEWeChatPayApplication:openURL:sourceApplication:annotation:) newClassName:NSStringFromClass([MUEWeChatPayModel class]) newSEL:@selector(muEWeChatPayApplication:openURL:sourceApplication:annotation:)];
        
        
        [MUHookMethodHelper muHookMethod:model.AppDelegateName orignalSEL:@selector(application:openURL:options:) defalutSEL:@selector(muDefalutEWeChatPayApplication:openURL:options:) newClassName:NSStringFromClass([MUEWeChatPayModel class]) newSEL:@selector(muEWeChatPayApplication:openURL:options:)];
        
        
        [MUHookMethodHelper muHookMethod:model.AppDelegateName orignalSEL:@selector(application:handleOpenURL:) defalutSEL:@selector(muDefalutEWeChatPayapplication: handleOpenURL:) newClassName:NSStringFromClass([MUEWeChatPayModel class]) newSEL:@selector(muEWeChatPayapplication:handleOpenURL:)];
#pragma clang diagnostic pop
        
        
    });
    
}
#pragma mark -AliPay
+(void)muEPaymentManagerWithAliPay:(NSString *)privateKey result:(void(^)(NSDictionary *))result{
     [[MUEAliPayModel sharedInstance] performAliPayment:privateKey appScheme:model.alipayScheme result:result];
}

#pragma mark -WeChat
+(void)muEPaymentManagerWithWeChatPay:(void (^)(PayReq *))req result:(void (^)(PayResp *))result{
    [[MUEWeChatPayModel sharedInstance] performWeChatPayment:req result:result];
}

+ (void)muEPaymentManagerWithWeChatLogin:(void (^)(SendAuthReq *))req controller:(UIViewController *)controller result:(void (^)(SendAuthResp *))result{
    
    [[MUEWeChatPayModel sharedInstance] performWeChatLogin:req controller:controller result:result];
}

@end
