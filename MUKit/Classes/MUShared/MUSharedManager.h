//
//  MUSharedManager.h
//  AFNetworking
//
//  Created by Jekity on 2017/11/27.
//

#import <Foundation/Foundation.h>
#import "MUSharedObject.h"

@interface MUSharedManager : NSObject
/**
 Unavailable.
 */
-(instancetype)init NS_UNAVAILABLE;

/**
 Unavailable.
 */
-(instancetype) new NS_UNAVAILABLE;

//分享给微信好友
+(void)sharedContentToWeChatFriend:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL uninstalled))faiure;
//分享到微信朋友圈
+(void)sharedContentToWeChatCircle:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL uninstalled))faiure;
//分享到QQ好友
+(void)sharedContentToQQFriend:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL uninstalled))faiure;
//分享到QQ空间
+(void)sharedContentToQQZone:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL uninstalled))faiure;
//分享到微博
+(void)sharedContentToWeiBo:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL uninstalled))faiure;
@end
