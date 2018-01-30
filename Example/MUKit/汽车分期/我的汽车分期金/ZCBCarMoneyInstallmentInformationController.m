//
//  ZCBCarMoneyInstallmentInformationController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarMoneyInstallmentInformationController.h"
#import "ZCBCarMoneyInstallmentInformationHeaderView.h"

@interface ZCBCarMoneyInstallmentInformationController ()

@property(nonatomic, strong)ZCBCarMoneyInstallmentInformationHeaderView *headerView;
@end

@implementation ZCBCarMoneyInstallmentInformationController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self TTTitle:@"分期信息" textColor:[UIColor whiteColor] isShimmering:NO];
//    self.headerView = [ZCBCarMoneyInstallmentInformationHeaderView ViewFromXib];
//    self.headerView.AutoWidth = hScreenWidth;
    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.backgroundColor = TTGrayColor(245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.headerView.model = self.model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
