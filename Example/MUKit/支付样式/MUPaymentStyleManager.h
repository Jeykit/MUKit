//
//  MUPaymentStyleManager.h
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MUPasswordView;
@interface MUPaymentStyleManager : NSObject
+(void)paymentStyleOnlySupportPassword:(void(^)(NSString * text ,MUPasswordView *passwordwordView))textDidChaned forgotPassword:(void(^)(NSString * text))forgotPasswordAction;

+(void)paymentStyleOnlySupportSingleView:(NSArray *)array render:(void(^)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model))renderBlock selected:(void(^)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model))selectedBlock;

+(void)paymentPushViewController:(NSString *)controller parameters:(void (^)(NSMutableDictionary *))parameter;
+(void)paymentDismissController;
@end
