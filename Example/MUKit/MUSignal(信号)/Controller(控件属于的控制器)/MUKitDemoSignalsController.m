//
//  MUKitDemoSignalsController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/18.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalsController.h"
#import "MUCheckbox.h"

@interface MUKitDemoSignalsController ()

@property (nonatomic,strong) UIView *testView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UITextView *textView;
@end

@implementation MUKitDemoSignalsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控件属于的控制器";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Signal"]];
    imageView.center = CGPointMake(self.view.center.x, 88.);
    [self.view addSubview:imageView];
    
//    self.view.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    self.view.frame = kScreenBounds;
    
    CGFloat width = (kScreenWidth - 48.)/2-12.;
    CGFloat y  =  self.view.centerY_Mu - 240.;
    self.testView = [[UIView alloc]initWithFrame:CGRectMake(24., y, width, 49.)];
    self.testView.backgroundColor = [UIColor redColor];
   
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0., 0, width, 49.)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"UIView(点我)";
    [self.testView addSubview:label];
    [self.view addSubview:self.testView];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(24.+width+12., y, width, 49.)];
    _button.titleStringMu = @"UIButton(点我)";
    _button.titleColorMu = [UIColor whiteColor];
    self.button.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.button];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(24., CGRectGetMaxY(self.button.frame)+24., kScreenWidth - 48., 240.)];
    [self.view addSubview:_textView];
    _textView.text = @"显示结果的地方";
    _textView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    _textView.font = [UIFont systemFontOfSize:22.];
    _textView.textColor = [UIColor blackColor];
    
    MUCheckbox *box = [[MUCheckbox alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(_textView.frame)+50., 22., 22.)];
    box.borderStyle = MUBorderStyleCircle;
    box.checkmarkStyle = MUCheckmarkStyleTick;
    box.borderWidth = 1.;
    box.uncheckedBorderColor = [UIColor lightGrayColor];
    box.checkedBorderColor = [UIColor blueColor];
    box.checkmarkSize = 0.6;
    box.valueChanged = ^(BOOL isChecked) {
        
    };
    [self.view addSubview:box];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

Click_MUSignal(testView){
    UIView *view = object;
    self.textView.text = [NSString stringWithFormat:@"我是%@\n在%@内被调用\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([view.viewController class])];
    
}
Click_MUSignal(button){
    UIButton *view = object;
     self.textView.text = [NSString stringWithFormat:@"我是%@\n在%@内被调用\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([view.viewController class])];
}


@end
