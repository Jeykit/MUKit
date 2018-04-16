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
/**支付宝支付*/
+(void)muEPaymentManagerWithAliPay:(NSString *)privateKey result:(void(^)(NSDictionary * resultDictionary))result;
/**微信支付*/
+(void)muEPaymentManagerWithWeChatPay:(void(^)(PayReq * req))req result:(void(^)(PayResp * rseq))result;
@end
