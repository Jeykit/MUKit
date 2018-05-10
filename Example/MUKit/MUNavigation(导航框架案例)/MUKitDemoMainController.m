//
//  MUKitDemoMainController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoMainController.h"
#import "MUKitDemoMainHeaderView.h"
#import <UIView+MUNormal.h>

@interface MUKitDemoMainController ()
@property (nonatomic,strong) MUKitDemoMainHeaderView *headerView;
@end

@implementation MUKitDemoMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航框架案例";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [MUKitDemoMainHeaderView viewForXibNOMargaimMu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//透明导航栏
Click_MUSignal(button1){
    [self.navigationController pushViewController:ClassName(MUKitDemoTranslucentController) animated:YES];
}
//隐藏导航栏
Click_MUSignal(button2){
    [self.navigationController pushViewController:ClassName(MUKitDemoHiddenController) animated:YES];
}
//导航栏透明度变化
Click_MUSignal(button3){
    [self.navigationController pushViewController:ClassName(MUKitDemoAlphaController) animated:YES];
}

//导航栏偏移
Click_MUSignal(button4){
    [self.navigationController pushViewController:ClassName(MUKitDemoTranslationYController) animated:YES];
}
//改变导航栏样式
Click_MUSignal(button5){
    [self.navigationController pushViewController:ClassName(MUKitDemoChangedController) animated:YES];
}
@end
