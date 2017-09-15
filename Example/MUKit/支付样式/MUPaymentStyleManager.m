//
//  MUPaymentStyleManager.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUPaymentStyleManager.h"
#import "MUTranslucentController.h"
#import "MUSinglePaymentView.h"
#import "MUPasswordView.h"


@implementation MUPaymentStyleManager

+(void)paymentStyleOnlySupportPassword:(void (^)(NSString *, MUPasswordView *))textDidChaned forgotPassword:(void (^)(NSString *))forgotPasswordAction{
    MUPasswordView *passwordView         = [[MUPasswordView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 368.)];
    MUTranslucentController * controller = [MUTranslucentController sharedInstance:passwordView];
    passwordView.forgotPasswordAction    = forgotPasswordAction;
    passwordView.textDidChaned           = textDidChaned;
    controller.leftImage                 = [UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:^{
        controller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15];
    }];
}

 +(void)paymentStyleOnlySupportSingleView:(NSArray *)array render:(void (^)(UITableViewCell *, NSIndexPath *, id))renderBlock selected:(void (^)(UITableViewCell *, NSIndexPath *, id))selectedBlock{
     MUSinglePaymentView *singleView = [[MUSinglePaymentView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220.) data:array];
    MUTranslucentController * controller = [MUTranslucentController sharedInstance:singleView];
     singleView.renderBlock =  renderBlock;
     singleView.selectedBlock = selectedBlock;
     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:^{
         controller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.15];
     }];
 }



+(void)paymentPushViewController:(NSString *)controller parameters:(void (^)(NSMutableDictionary *))parameter{
    if (!controller) {
        
        return;
    }
    NSMutableDictionary * dict= [NSMutableDictionary dictionary];
   
    if (parameter) {
        parameter(dict);
    }
    UIViewController *viewController = [NSClassFromString(controller) new];
//    [controller yy_modelSetWithDictionary:dict];
//    [self pushViewController:controller animated:animated];
    
     MUTranslucentController * navigation = [MUTranslucentController sharedInstance:nil];
    [navigation pushViewController:viewController animated:YES];
}

+(void)paymentDismissController{
     MUTranslucentController * navigation = [MUTranslucentController sharedInstance:nil];
    navigation.willDismiss                = YES;
}
@end
