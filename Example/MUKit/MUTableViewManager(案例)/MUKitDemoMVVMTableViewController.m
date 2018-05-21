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
    self.tableView.backgroundColor = [UIColor lightGrayColor];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        if (indexPath.row == 0) {
            //第一个cell的背景色
            cell.textLabel.backgroundColor= [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            *height = 64.;//第一个cell的行高
        }else{
            //第二个cell的背景色
            cell.textLabel.backgroundColor= [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor colorWithRed:210./255. green:210./255. blue:210./255. alpha:1.0];
            *height = 88.;//第二个cell的行高
        }
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
