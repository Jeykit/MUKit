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


/**
 Unavailable.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Unavailable.
 */
- (instancetype) new NS_UNAVAILABLE;

/**支付宝支付
 resultDictionary对应的key和可能的value
 resultStatus，状态码，SDK里没对应信息，第一个文档里有提到：
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 memo， 提示信息，比如状态码为6001时，memo就是“用户中途取消”。但千万别完全依赖这个信息，如果未安装支付宝app，采用网页支付时，取消时状态码是6001，但这个memo是空的。。（当我发现这个问题的时候，我就决定，对于这么不靠谱的SDK，还是尽量靠自己吧。。）
 result，订单信息，以及签名验证信息。如果你不想做签名验证，那这个字段可以忽略了。
 */

/**
 @param privateKey privateKey后台加密后返回的私钥
 @param result 支付结果回调(成功、失败等)resultDictionary是支付宝返回的数据
 */
+ (void)muEPaymentManagerWithAliPay:(NSString *)privateKey result:(void(^)(NSDictionary * resultDictionary))result;

/**微信支付返回结果
 WXSuccess           = 0,    成功
 WXErrCodeCommon     = -1,   普通错误类型
 WXErrCodeUserCancel = -2,   用户点击取消并返回
 WXErrCodeSentFail   = -3,   发送失败
 WXErrCodeAuthDeny   = -4,   授权失败
 WXErrCodeUnsupport  = -5,   微信不支持
 */

/**微信支付需要的参数，这些参数一般是后台生成，也可在APP端调微信接口生成，参考https://www.jianshu.com/p/b34a03e4d506
 req.partnerId           = @"1900000109";商家向财付通申请的商家id
 req.prepayId            = @"WX1217752501201407033233368018";预支付订单
 req.nonceStr            = @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";随机串，防重发
 req.timeStamp           = 1412000000;时间戳，防重发
 req.package             = @"Sign=WXPay";商家根据财付通文档填写的数据和签名
 req.sign                = @"9A0A8659F005D6984697E2CA0A9CF3B7";商家根据微信开放平台文档对数据做的签名
 */

/**
 @param req 支付参数
 @param result 支付结果回调
 */
+ (void)muEPaymentManagerWithWeChatPay:(void(^)(PayReq * req))req result:(void(^)(PayResp * rseq))result;


/**
 微信登录
 @param req 授权参数
 @param controller 微信登录发起的所在控制器
 @param result 授权结果回调
 */
+ (void)muEPaymentManagerWithWeChatLogin:(void(^)(SendAuthReq * req))req controller:(UIViewController *)controller result:(void(^)(SendAuthResp * rseq))result;
@end
