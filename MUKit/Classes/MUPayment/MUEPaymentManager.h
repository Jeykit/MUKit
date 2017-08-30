//
//  MUEPaymentManager.h
//  Pods
//
//  Created by Jekity on 2017/8/25.
//
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

@interface MUEPaymentManager : NSObject
+(void)muEPaymentManagerWithAliPay:(NSString *)privateKey result:(void(^)(NSDictionary * resultDictionary))result;
+(void)muEPaymentManagerWithWeChatPay:(void(^)(PayReq * req))req result:(void(^)(PayResp * rseq))result;
@end
