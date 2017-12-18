//
//  Order.h
//  AliSDKDemo
//
//  Created by 方彬 on 07/25/16.
//
//

#import <Foundation/Foundation.h>

@interface BizContent : NSObject

// NOTE: (非必填项)商品描述
@property (nonatomic, copy) NSString *body;

// NOTE: 商品的标题/交易标题/订单标题/订单关键字等。
@property (nonatomic, copy) NSString *subject;

// NOTE: 商户网站唯一订单号
@property (nonatomic, copy) NSString *out_trade_no;

// NOTE: 该笔订单允许的最晚付款时间，逾期将关闭交易。
//       取值范围：1m～15d m-分钟，h-小时，d-天，1c-当天(1c-当天的情况下，无论交易何时创建，都在0点关闭)
//       该参数数值不接受小数点， 如1.5h，可转换为90m。
@property (nonatomic, copy) NSString *timeout_express;

// NOTE: 订单总金额，单位为元，精确到小数点后两位，取值范围[0.01,100000000]
@property (nonatomic, copy) NSString *total_amount;

// NOTE: 收款支付宝用户ID。 如果该值为空，则默认为商户签约账号对应的支付宝用户ID (如 2088102147948060)
@property (nonatomic, copy) NSString *seller_id;

// NOTE: 销售产品码，商家和支付宝签约的产品码 (如 QUICK_MSECURITY_PAY)
@property (nonatomic, copy) NSString *product_code;

@end


@interface Order : NSObject

// NOTE: 支付宝分配给开发者的应用ID(如2014072300007148)
@property (nonatomic, copy) NSString *app_id;

// NOTE: 支付接口名称
@property (nonatomic, copy) NSString *method;

// NOTE: (非必填项)仅支持JSON
@property (nonatomic, copy) NSString *format;

// NOTE: (非必填项)HTTP/HTTPS开头字符串
@property (nonatomic, copy) NSString *return_url;

// NOTE: 参数编码格式，如utf-8,gbk,gb2312等
@property (nonatomic, copy) NSString *charset;

// NOTE: 请求发送的时间，格式"yyyy-MM-dd HH:mm:ss"
@property (nonatomic, copy) NSString *timestamp;

// NOTE: 请求调用的接口版本，固定为：1.0
@property (nonatomic, copy) NSString *version;

// NOTE: (非必填项)支付宝服务器主动通知商户服务器里指定的页面http路径
@property (nonatomic, copy) NSString *notify_url;

// NOTE: (非必填项)商户授权令牌，通过该令牌来帮助商户发起请求，完成业务(如201510BBaabdb44d8fd04607abf8d5931ec75D84)
@property (nonatomic, copy) NSString *app_auth_token;

// NOTE: 具体业务请求数据
@property (nonatomic, strong) BizContent *biz_content;

// NOTE: 签名类型
@property (nonatomic, copy) NSString *sign_type;


/**
 *  获取订单信息串
 *
 *  @param bEncoded       订单信息串中的各个value是否encode
 *                        非encode订单信息串，用于生成签名
 *                        encode订单信息串 + 签名，用于最终的支付请求订单信息串
 */
- (NSString *)orderInfoEncoded:(BOOL)bEncoded;

@end
