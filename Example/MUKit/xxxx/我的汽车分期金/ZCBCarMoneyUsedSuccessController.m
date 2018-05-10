//
//  ZCBCarMoneyUsedSuccessController.m
//  ZhaoCaiHuiBaoRt
//
//  Created by wzs on 2018/1/6.
//  Copyright © 2018年 ttayaa. All rights reserved.
//

#import "ZCBCarMoneyUsedSuccessController.h"
#import "ZCBCarMoneyUsedSuccessHeaderView.h"

@interface ZCBCarMoneyUsedSuccessController ()
@property(nonatomic, strong)ZCBCarMoneyUsedSuccessHeaderView *headerView;
@end

@implementation ZCBCarMoneyUsedSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self TTTitle:@"装修金支付成功" textColor:[UIColor whiteColor] isShimmering:NO];
//    self.headerView = [ZCBCarMoneyUsedSuccessHeaderView ViewFromXib];
//    self.headerView.AutoWidth = hScreenWidth;
    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.backgroundColor = TTGrayColor(245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.headerView.moneyLabel.text = [NSString stringWithFormat:@"%@ 元",self.model.pay_money];
}
/*
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self TTLeftBarImage:@""];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self TTLeftBarImage:@"nav_back03"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

Click_signal(button){
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
}
*/
@end
