//
//  MUKitDemoHeaderViewController.m
//  MUKit
//
//  Created by Jekity on 2017/9/30.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoHeaderViewController.h"
#import "MUKitDemoTestTableHeaderView.h"

@interface MUKitDemoHeaderViewController ()

@end

@implementation MUKitDemoHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"headerView";
   MUKitDemoTestTableHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"MUKitDemoTestTableHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
