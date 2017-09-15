//
//  MUPasswordView.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUPasswordView.h"
#import "MUPaymentLoadingHUD.h"
#import "MUPaymentSuccessHUD.h"

@interface MUPasswordView()<UITextFieldDelegate>
@property(nonatomic, strong)UITextField *textField;
@property(nonatomic, strong)NSMutableArray *dotArray;
@property(nonatomic, assign)NSUInteger preLength;
@property(nonatomic, strong)UILabel *forgotPasswordLabel;
@end

#define kDotSize     CGSizeMake(10., 10.)
#define kDotCount    6
#define kFieldHeight 44.
@implementation MUPasswordView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _preLength = 0;
        [self addSubview:self.textField];
        [self addSubview:self.forgotPasswordLabel];
        [self configuredPasswordTextField];
    }
    return self;
}

-(void)configuredPasswordTextField{
    
    //每个密码输入框的宽度
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 48.) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), 1, kFieldHeight)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (kFieldHeight - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor lightGrayColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
    
   
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(24., 24, [UIScreen mainScreen].bounds.size.width - 48., kFieldHeight)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(UILabel *)forgotPasswordLabel{
    if (!_forgotPasswordLabel) {
        
        _forgotPasswordLabel           = [[UILabel alloc]init];
        _forgotPasswordLabel.text      = @"忘记密码？";
        _forgotPasswordLabel.textColor = [UIColor blueColor];
        //忘记密码
        _forgotPasswordLabel.font      = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [_forgotPasswordLabel sizeToFit];
        
        CGRect rect = _forgotPasswordLabel.frame;
        rect.origin = CGPointMake([UIScreen mainScreen].bounds.size.width - 24. - rect.size.width, 80.);
        _forgotPasswordLabel.frame     = rect;
        
        _forgotPasswordLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgotPasswordAction:)];
        [_forgotPasswordLabel addGestureRecognizer:tapGesture];
    }
    return _forgotPasswordLabel;
}

#pragma -mark Action

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    if (self.preLength > textField.text.length) {//删除密码
        _preLength -= 1;
        ((UIView *)[self.dotArray objectAtIndex:_preLength]).hidden = YES;
    }else{//输入密码
        ((UIView *)[self.dotArray objectAtIndex:_preLength]).hidden = NO;
        _preLength += 1;
    }
    if (self.textDidChaned) {
        self.textDidChaned(textField.text,self);
    }
//     NSLog(@"密码=%@",textField.text);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
//        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

//点击忘记密码
-(void)forgotPasswordAction:(UILabel *)label{
    
    if (self.forgotPasswordAction) {
        self.forgotPasswordAction(self.textField.text);
    }
}

#pragma mark -action 正在支付
-(void)setPaying:(BOOL)paying{
    if (paying) {
        [self.textField resignFirstResponder];
        [MUPaymentLoadingHUD showIn:self];
        [MUPaymentSuccessHUD hideIn:self];
    }else{
        [MUPaymentLoadingHUD showIn:self];
    }
}

-(void)setDonePayment:(BOOL)donePayment{
    if (donePayment) {
        [self.textField resignFirstResponder];
         [MUPaymentLoadingHUD showIn:self];
        [MUPaymentSuccessHUD showIn:self];
        [MUPaymentLoadingHUD hideIn:self];
    }else{
        [MUPaymentSuccessHUD hideIn:self];
    }
}

@end
