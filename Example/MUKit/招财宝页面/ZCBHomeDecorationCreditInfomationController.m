//
//  ZCBHomeDecorationCreditInfomationController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBHomeDecorationCreditInfomationController.h"

@interface ZCBHomeDecorationCreditInfomationController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation ZCBHomeDecorationCreditInfomationController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"申请装修金贷款";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
