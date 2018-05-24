//
//  MUKitDemoMVVMTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoMVVMTableViewController.h"
#import <MUTableViewManager.h>
#import "MUTableViewController.h"
#import "MUKitDemoDynamicRowHeightController.h"
#import "MUNavigation.h"
@interface MUKitDemoMVVMTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

@implementation MUKitDemoMVVMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTintColor = [UIColor whiteColor];
    self.title = @"MVVMTableView";
    [self configuredDataSource];
}
#pragma -mark init
-(void)configuredDataSource{
    
    //初始化一个MVVM TableView
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];
    //数据模型
    _tableViewManger.modelArray = [@[@"分组模型数据例子",@"动态计算行高例子"] mutableCopy];
    
    //给cell赋值
    weakify(self);
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        *height = 88.;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"TablveView"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
        
    };
    //点击cell后的处理
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height){
        normalize(self);
        if (indexPath.row == 0) {
            MUTableViewController  *controller = [MUTableViewController new];
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }
        if (indexPath.row == 1) {
            
            MUKitDemoDynamicRowHeightController  *controller = [MUKitDemoDynamicRowHeightController new];
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }
    };
}

@end
