//
//  MUKitDemoSignalsViewController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/19.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalsViewController.h"
#import "MUView.h"

@interface MUKitDemoSignalsViewController ()

@end

@implementation MUKitDemoSignalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"控件属于的view";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    MUView * view = [[[NSBundle bundleForClass:[MUView class]] loadNibNamed:NSStringFromClass([MUView class]) owner:nil options:nil] firstObject];
    view.frame = kScreenBounds;
    [self.view addSubview:view];//因为view加载在这个控制器上，所以view上的所有子控件包括view本身都属于这个控制器
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//把MUView里的方法注释掉，我就会响应了
Click_MUSignal(infoView){//控件所在的View(优先级最高)没有实现信号方法，而控制器实现了信号方法，所有控制器的信号方法会响应
    UIView *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
    [self.navigationController pushViewController:[MUKitDemoSignalsViewController new] animated:YES];
    NSLog(@"我是%@\n在%@内被调用\n我属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class ]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}
Click_MUSignal(button){
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    UIButton *button = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSLog(@"我是%@\n在%@内被调用\n我属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class ]),NSStringFromClass([self class ]),NSStringFromClass([button.viewController class]));
}


@end
