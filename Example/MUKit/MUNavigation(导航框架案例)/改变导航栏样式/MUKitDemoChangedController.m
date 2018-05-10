//
//  MUKitDemoChangedController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/10.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoChangedController.h"

@interface MUKitDemoChangedController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation MUKitDemoChangedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"改变导航栏样式";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor colorWithHexString:@"#767F90"]];//navigation bar背景图片。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    self.navigationBarTintColor = [UIColor colorWithHexString:@"#FA19E1"];//返回按钮颜色。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    self.barStyleMu =  UIBarStyleDefault;//状态栏。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    self.titleColorMu = [UIColor orangeColor];//标题颜色。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.85, 49.)];
    self.button.center = self.view.center;
    self.button.titleStringMu = @"点我返回,看看上一个样式有没有改变";
    self.button.titleColorMu = [UIColor colorWithHexString:@"#767F90"];
    [self.view addSubview:self.button];
    [self.button setMUCornerRadius:49.*.125 borderWidth:1. borderColor:[UIColor colorWithHexString:@"#767F90"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_MUSignal(button){
    [self.navigationController popViewControllerAnimated:YES];
}

@end
