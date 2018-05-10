//
//  MUKitDemoHiddenController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoHiddenController.h"

@interface MUKitDemoHiddenController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation MUKitDemoHiddenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHiddenMu = YES;//隐藏导航栏。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    self.statusBarStyleMu = UIStatusBarStyleDefault;//电池电量条样式。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    
    
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.85, 49.)];
    self.button.center = self.view.center;
    self.button.titleStringMu = @"我被隐藏了，点我返回";
    self.button.titleColorMu = [UIColor colorWithHexString:@"#FA19E1"];
    [self.view addSubview:self.button];
    [self.button setMUCornerRadius:49.*.125 borderWidth:1. borderColor:[UIColor colorWithHexString:@"#FA19E1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_MUSignal(button){
    [self.navigationController popViewControllerAnimated:YES];
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
