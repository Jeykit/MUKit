//
//  MUEWeChatPayModel.h
//  Pods
//
//  Created by Jekity on 2017/8/29.
//
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

@interface MUEWeChatPayModel : NSObject<WXApiDelegate>
+(instancetype)sharedInstance;
-(void)performWeChatPayment:(void(^)(PayReq * req))req result:(void(^)(PayResp * resq))result;
@end
