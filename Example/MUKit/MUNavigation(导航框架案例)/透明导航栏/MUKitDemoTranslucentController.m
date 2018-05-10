//
//  MUKitDemoTranslucentController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoTranslucentController.h"
#import "MUKitDemoTranslucentHeaderView.h"

@interface MUKitDemoTranslucentController ()
@property (nonatomic,strong) MUKitDemoTranslucentHeaderView *headerView;
@property (nonatomic,strong) MUTableViewManager *tableViewManager;
@end

@implementation MUKitDemoTranslucentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"透明导航栏";
    self.navigationBarTranslucentMu = YES;//透明导航栏。pop或push，都不会影响到上一个或下一个控制器navigation bar样式
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [MUKitDemoTranslucentHeaderView viewForXibMuWithRetainObject:self];
    self.tableViewManager = [[MUTableViewManager alloc]initWithTableView:self.tableView];
    self.tableViewManager.scaleView = self.headerView.scaleImageView;
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
