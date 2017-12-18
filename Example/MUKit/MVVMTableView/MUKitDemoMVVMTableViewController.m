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
    self.title = @"MVVMTableView";
    [self configuredDataSource];
    [self configuredCell];
}
#pragma -mark init
-(void)configuredDataSource{
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];;
    _tableViewManger.modelArray = [@[@"Customer",@"Manager",@"Dynamic row height"] mutableCopy];
    
}

-(void)configuredCell{
    
    weakify(self);
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
        
    };
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height)
        
        {
            normalize(self);
            if (indexPath.row == 0) {
                
                MUTableViewController  *controller = [MUTableViewController new];
                controller.type = MemberTypeEmployee;
                [self.navigationController pushViewController:controller animated:YES];
                return ;
            }
            
            if (indexPath.row == 1) {
                
                MUTableViewController  *controller = [MUTableViewController new];
                controller.type = MemberTypeManager;
                [self.navigationController pushViewController:controller animated:YES];
                return ;
            }
            
            if (indexPath.row == 2) {
                
                MUKitDemoDynamicRowHeightController  *controller = [MUKitDemoDynamicRowHeightController new];
                [self.navigationController pushViewController:controller animated:YES];
                return ;
            }
        };
    
}

@end
