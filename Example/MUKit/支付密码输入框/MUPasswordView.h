//
//  MUPasswordView.h
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUPasswordView : UIView
@property(nonatomic, copy)void (^textDidChaned)(NSString *text ,MUPasswordView *passwordView);
@property(nonatomic, copy)void (^forgotPasswordAction)(NSString *text);
@property(nonatomic, assign ,getter=isPaying)BOOL paying;
@property(nonatomic, assign ,getter=isDonePayment)BOOL donePayment;
@end
