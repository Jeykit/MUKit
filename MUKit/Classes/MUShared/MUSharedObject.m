//
//  MUSharedObject.m
//  AFNetworking
//
//  Created by Jekity on 2017/11/27.
//

#import "MUSharedObject.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "MULoadingModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, MUSharedType) {
    MUSharedTypeWeChatFriend = 0,
    MUSharedTypeWeChatCircle,
    MUSharedTypeQQFriend,
    MUSharedTypeQQZone,
    MUSharedTypeWeiBo
};
@implementation MUSharedModel

@end
static MULoadingModel const *model;
void initializationLoadingInSharedManager(){//initalization loading model
    
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
//static void(^resultBlock)(BOOL success);
@interface MUSharedObject()
@property (nonatomic, weak) TencentOAuth *tencentOAuth ;

@end
@implementation MUSharedObject
+(void)load{
    if (!NSClassFromString(@"MUEPaymentManager")) {//有支付类
        dispatch_async(dispatch_get_main_queue(), ^{
            initializationLoadingInSharedManager();
            if (model == nil) {
                NSLog(@"you can't use 'MUEPayment' because you haven't a subclass of 'MULoadingModel' or you don't init a subclass of 'MULoadingModel'");
                return ;
            }
            
            MUSharedObject *object = [MUSharedObject new];
            [object registerApiKeysWithWeChatKey:model.weChatSharedID QQKey:model.QQID weibokey:model.weiboID];
        });
    }
}
+(instancetype)sharedInstanced{
    
    static __weak MUSharedObject * instance;
    MUSharedObject * strongInstance = instance;
    @synchronized (self) {
        
        if (strongInstance == nil) {
            strongInstance = [[[self class]alloc]init];
            instance       = strongInstance;
        }
    }
    return strongInstance;
}
-(void)registerApiKeysWithWeChatKey:(NSString *)wechatkey QQKey:(NSString *)qqKey weibokey:(NSString *)weibokey{
    if (wechatkey.length > 0) {
        [WXApi registerApp:wechatkey];
    }
    if (qqKey.length > 0) {
        TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqKey andDelegate:nil];
        _tencentOAuth = tencentOAuth;
    }
    if (weibokey.length >0) {
        [WeiboSDK registerApp:weibokey];
    }
    
}
-(void)sharedContentToWeChatFriend:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    MUSharedModel *sharedModel = [MUSharedModel new];
    if (model) {
        model(sharedModel);
    }
    BOOL flag = [self shareLinkWithShareType:MUSharedTypeWeChatFriend shareModel:sharedModel faiure:faiure];
    if (result&&flag) {
        result(flag);
    }
}

-(void)sharedContentToWeChatCircle:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    MUSharedModel *sharedModel = [MUSharedModel new];
    if (model) {
        model(sharedModel);
    }
    BOOL flag = [self shareLinkWithShareType:MUSharedTypeWeChatCircle shareModel:sharedModel faiure:faiure];
    if (result&&flag) {
        result(flag);
    }
}

-(void)sharedContentToQQFriend:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    MUSharedModel *sharedModel = [MUSharedModel new];
    if (model) {
        model(sharedModel);
    }
    BOOL flag = [self shareLinkToQQWithScene:0 shareModel:sharedModel faiure:faiure];
    if (result&&flag) {
        result(flag);
    }
}

-(void)sharedContentToQQZone:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    MUSharedModel *sharedModel = [MUSharedModel new];
    if (model) {
        model(sharedModel);
    }
    BOOL flag = [self shareLinkToQQWithScene:1 shareModel:sharedModel faiure:faiure];
    if (result&&flag) {
        result(flag);
    }
}

-(void)sharedContentToWeiBo:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    MUSharedModel *sharedModel = [MUSharedModel new];
    if (model) {
        model(sharedModel);
    }
    BOOL flag = [self shareLinkToWeiboWithShareModel:sharedModel faiure:faiure];
    if (result&&flag) {
        result(flag);
    }
}
//
- (BOOL)shareLinkWithShareType:(MUSharedType)type shareModel:(MUSharedModel *)shareModel faiure:(void (^)(BOOL))faiure
{
    switch (type) {
        case MUSharedTypeWeChatFriend:
            return [self shareLinkToWeChatWithScene:WXSceneSession shareModel:shareModel faiure:faiure];
            break;
        case MUSharedTypeWeChatCircle:
            return [self shareLinkToWeChatWithScene:WXSceneTimeline shareModel:shareModel faiure:faiure];
            break;
        case MUSharedTypeQQZone:
            return [self shareLinkToQQWithScene:1 shareModel:shareModel faiure:faiure];
            break;
        case MUSharedTypeQQFriend:
            return [self shareLinkToQQWithScene:0 shareModel:shareModel faiure:faiure];
            break;
        case MUSharedTypeWeiBo:
            return [self shareLinkToWeiboWithShareModel:shareModel faiure:faiure];
            break;
            
        default:
            break;
    }
    
    return NO;
}
- (BOOL)shareLinkToQQWithScene:(NSInteger)scene shareModel:(MUSharedModel *)shareModel faiure:(void (^)(BOOL))faiure
{
    if ([TencentOAuth iphoneQQInstalled]) {
        QQApiNewsObject *newsObject = nil;
        NSString *title       = shareModel.sharedTitle.length > 0 ? shareModel.sharedTitle : @"标题";
        NSString *description = shareModel.sharedContent.length > 0 ? shareModel.sharedContent : @"";
        NSString * str_url = shareModel.sharedUrl.length > 0 ? shareModel.sharedUrl : @"";
        NSURL  *url = [NSURL URLWithString:str_url];
        NSData *imageData = shareModel.sharedThumbImageData;
        if (imageData) {
            newsObject = [QQApiNewsObject objectWithURL:url title:title description:description  previewImageData:imageData];
        }else{
            NSString *imageUrl = shareModel.sharedUrl.length > 0?shareModel.sharedUrl:@"";
            newsObject = [QQApiNewsObject objectWithURL:url title:title description:description previewImageURL:[NSURL URLWithString:imageUrl]];
        }
        
        SendMessageToQQReq* request  = [SendMessageToQQReq reqWithContent:newsObject];
        QQApiSendResultCode resultCode = 0;
        //1 为QQZOne 0 为QQ
        if (scene) {
            resultCode = [QQApiInterface SendReqToQZone:request];
        }else{
            resultCode = [QQApiInterface sendReq:request];
        }
        if (EQQAPISENDSUCESS == resultCode) {
            return YES;
        }
        return NO;
    }else{
        if (faiure) {
            faiure(YES);
        }else{
            [self handlerNotInstallAppWithTytpe:MUSharedTypeQQFriend];
        }
        return NO;
    }
    
}
- (BOOL)shareLinkToWeiboWithShareModel:(MUSharedModel *)shareModel faiure:(void (^)(BOOL))faiure{
    if ([WeiboSDK isWeiboAppInstalled]) {
        
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = shareModel.sharedUrl ;
        webpage.title = shareModel.sharedTitle.length > 0 ? shareModel.sharedTitle : @"标题";
        webpage.description =shareModel.sharedContent.length > 0 ? shareModel.sharedContent : @"";
        if (shareModel.sharedThumbImageData) {
            webpage.thumbnailData = shareModel.sharedThumbImageData;
        }else if (shareModel.sharedThumbImageUrl) {
            //此处有一个隐患，url获取data是一个同步请求
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareModel.sharedThumbImageUrl]];
            webpage.thumbnailData = data;
        }
        webpage.webpageUrl = shareModel.sharedUrl;
        WBMessageObject *message = [WBMessageObject message];
        message.mediaObject = webpage;
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        BOOL flag = [WeiboSDK sendRequest:request];
        if (flag) {
            return YES;
        }
        if (faiure) {
            faiure(NO);
        }
        return NO;
    }else {
        if (faiure) {
            faiure(YES);
        }else{
            [self handlerNotInstallAppWithTytpe:MUSharedTypeQQFriend];
        }
        return NO;
    }
    
    
}

- (BOOL)shareLinkToWeChatWithScene:(enum WXScene)scene shareModel:(MUSharedModel *)shareModel faiure:(void (^)(BOOL))faiure
{
    if ([WXApi isWXAppInstalled]) {
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.title = shareModel.sharedTitle.length > 0 ? shareModel.sharedTitle : @"标题";
        mediaMessage.description = shareModel.sharedContent.length > 0 ? shareModel.sharedContent : @"";
        WXWebpageObject *webPage = [WXWebpageObject object];
        webPage.webpageUrl = shareModel.sharedUrl.length > 0 ? shareModel.sharedUrl : @"";
        mediaMessage.mediaObject = webPage;
        
        if (shareModel.sharedThumbImageData) {
            [mediaMessage setThumbData:shareModel.sharedThumbImageData];
        }else if ( shareModel.sharedThumbImageUrl) {
            //此处有一个隐患，url获取data是一个同步请求
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareModel.sharedThumbImageUrl]]];
            [mediaMessage setThumbImage:image];
            
        }
        //随意设置，便于统计作用
        mediaMessage.mediaTagName   = @"WECHAT_TAG_SHARE";
        SendMessageToWXReq *request = [SendMessageToWXReq new];
        request.bText = NO;
        request.message = mediaMessage;
        request.scene = scene;
        
        BOOL flag = [WXApi sendReq:request];
        if (flag) {
            return YES;
        }
        if (faiure) {
            faiure(NO);
        }
        return NO;
        
    }else{
        if (faiure) {
            faiure(YES);
        }else{
            [self handlerNotInstallAppWithTytpe:MUSharedTypeQQFriend];
        }
        return NO;
    }
}
- (void)handlerNotInstallAppWithTytpe:(MUSharedType)type
{
    if (@available(iOS 8.0, *)) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"应用未安装" preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [controller dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
    } else {
        // Fallback on earlier versions
    }
    
    
}

@end
