//
//  MUSharedObject.h
//  AFNetworking
//
//  Created by Jekity on 2017/11/27.
//

#import <Foundation/Foundation.h>


@interface MUSharedModel : NSObject

///分享的标题，非空
@property(nonatomic,copy)NSString *sharedTitle;
///分享的内容，可为空
@property(nonatomic,copy)NSString *sharedContent;
///分享的占位图片的url
@property(nonatomic,copy)NSString *sharedThumbImageUrl;
///分享的占位图片data数据
@property(nonatomic,copy)NSData *sharedThumbImageData;
///分享的点击跳转的链接
@property(nonatomic,copy)NSString *sharedUrl;

@end

@interface MUSharedObject : NSObject
+(instancetype)sharedInstanced;
- (void)registerApiKeysWithWeChatKey:(NSString*)wechatkey QQKey:(NSString*)qqKey weibokey:(NSString*)weibokey;
//分享给微信好友
-(void)sharedContentToWeChatFriend:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL installed))faiure;
//分享到微信朋友圈
-(void)sharedContentToWeChatCircle:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL installed))faiure;
//分享到QQ好友
-(void)sharedContentToQQFriend:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL installed))faiure;
//分享到QQ空间
-(void)sharedContentToQQZone:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL installed))faiure;
//分享到微博
-(void)sharedContentToWeiBo:(void(^)(MUSharedModel * model))model result:(void(^)(BOOL success))result faiure:(void(^)(BOOL installed))faiure;
@end
