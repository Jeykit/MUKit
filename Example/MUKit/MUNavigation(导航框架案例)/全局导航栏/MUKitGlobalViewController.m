//
//  MUKitGlobalViewController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/10.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitGlobalViewController.h"

@interface MUKitGlobalViewController ()
@property (nonatomic,strong) UIButton *button;
@end

@implementation MUKitGlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.85, 49.)];
    self.button.center = self.view.center;
    self.button.titleStringMu = @"无论你点不点，我的navigation bar样式丝毫不会改变";
    self.button.titleColorMu = [UIColor colorWithHexString:@"#FA19E1"];
    [self.view addSubview:self.button];
    [self.button setMUCornerRadius:49.*.125 borderWidth:1. borderColor:[UIColor colorWithHexString:@"#FA19E1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_MUSignal(button){
    [self.navigationController pushViewController:ClassName(MUKitGlobalViewController) animated:YES];
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
