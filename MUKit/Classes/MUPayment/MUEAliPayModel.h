//
//  MUEAliPayModel.h
//  Pods
//
//  Created by Jekity on 2017/8/25.
//
//

#import <Foundation/Foundation.h>

@interface MUEAliPayModel : NSObject
+(instancetype)sharedInstance;
-(void)performAliPayment:(NSString *)privateKey appScheme:(NSString *)scheme result:(void(^)(NSDictionary * resultDict))result;
@end
