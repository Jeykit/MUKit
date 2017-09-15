//
//  MUPaymentLoadingHUD.h
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUPaymentLoadingHUD : UIView
-(void)startAnimation;
-(void)stopAnimation;
+(MUPaymentLoadingHUD*)showIn:(UIView*)view;
+(MUPaymentLoadingHUD*)hideIn:(UIView*)view;
@end
