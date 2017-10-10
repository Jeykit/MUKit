//
//  ZCHBBusinessmenLoginHeaderView.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCHBBusinessmenLoginHeaderView.h"

@interface ZCHBBusinessmenLoginHeaderView()
    
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
    @property (weak, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
    @property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
@implementation ZCHBBusinessmenLoginHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.loginButton.layer.cornerRadius  = CGRectGetHeight(self.loginButton.frame)/2.;
    self.loginButton.layer.masksToBounds = YES;
    self.switchButton.controlEvents(UIControlEventValueChanged);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
Click_MUSignal(switchButton){
    
    NSString *passwordString = self.passwordTextField.text;
    if (self.switchButton.on) {
        self.passwordTextField.text            = @"";
        self.passwordTextField.secureTextEntry = NO;
        self.passwordTextField.text            = passwordString;
    }else{
        self.passwordTextField.text            = @"";
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.text            = passwordString;
    }
   
}
@end
