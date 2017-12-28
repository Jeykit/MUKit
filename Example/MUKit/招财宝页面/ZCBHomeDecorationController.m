//
//  ZCBHomeDecorationController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBHomeDecorationController.h"
#import "ZCBHomeDecorationHeaderView.h"

@interface ZCBHomeDecorationController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property(nonatomic, strong)ZCBHomeDecorationHeaderView *headerView;
@end

@implementation ZCBHomeDecorationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"装修金贷款";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
