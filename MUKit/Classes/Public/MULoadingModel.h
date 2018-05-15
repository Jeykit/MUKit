//
//  MULoadingModel.h
//  Pods
//
//  Created by Jekity on 2017/8/25.
//
//

#import <Foundation/Foundation.h>

@interface MULoadingModel : NSObject


@property(nonatomic, copy)NSString *AppDelegateName;

/**
 申请支付宝支付的AppID
 */
@property(nonatomic, copy)NSString *alipayID;


/**
 应用配置的支付宝支付的Scheme
 */
@property(nonatomic, copy)NSString *alipayScheme;



/**
 申请微信支付的AppID
 */
@property(nonatomic, copy)NSString *weChatPayID;


/**
 申请微信分享的AppID
 */
@property(nonatomic, copy)NSString *weChatSharedID;


/**
 应用配置的微信支付的Scheme
 */
@property(nonatomic, copy)NSString *weChatPayScheme;



/**
 申请QQ分享的AppID
 */
@property(nonatomic, copy)NSString *QQID;


/**
 申请微博分享的AppID
 */
@property(nonatomic, copy)NSString *weiboID;
@end
