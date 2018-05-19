//
//  MUKitDemoSignalsController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/18.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalsController.h"

@interface MUKitDemoSignalsController ()

@property (nonatomic,strong) UIView *testView;
@property (nonatomic,strong) UIButton *button;
@end

@implementation MUKitDemoSignalsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控件属于的控制器";
    self.view.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    
    self.testView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
    self.testView.center = CGPointMake(self.view.centerX_Mu, self.view.centerY_Mu - 120.);
    
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    _button.titleStringMu = @"button";
    _button.titleColorMu = [UIColor whiteColor];
    self.button.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.button];
    self.button.center = CGPointMake(self.view.centerX_Mu, self.view.centerY_Mu );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

Click_MUSignal(testView){
    UIView *view = object;
    NSLog(@"我是%@\n在%@内被调用\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([view.viewController class]));
    
}
Click_MUSignal(button){
    UIButton *view = object;
    NSLog(@"我是%@\n在%@内被调用\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([view.viewController class]));
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
