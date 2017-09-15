//
//  MUPaymentSuccessHUD.h
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUPaymentSuccessHUD : UIView<CAAnimationDelegate>
-(void)startAnimation;
-(void)stopAnimation;
+(MUPaymentSuccessHUD*)showIn:(UIView*)view;
+(MUPaymentSuccessHUD*)hideIn:(UIView*)view;
@end
