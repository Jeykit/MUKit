//
//  MUKitDemoTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableViewController.h"
#import <MUTableViewManager.h>
#import "MUKitSignalTableViewController.h"
#import "MUKitDemoMVVMTableViewController.h"

@interface MUKitDemoTableViewController ()

@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end


static NSString *const cellReusedIndentifier = @"cell";
@implementation MUKitDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self configuredDataSource];
    
}
#pragma -mark init
-(void)configuredDataSource{
     self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView subKeyPath:nil];
    self.tableViewManger.modelArray = [@[@"signal",@"MVVVTableView"] mutableCopy];
    
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusedIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusedIndentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
    };
    
    self.tableViewManger.headerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString * *title, id model, CGFloat *height) {
        
        *height = 88.;
        *title  = @"Demo";
        
        return nil;
    };
    
    __weak typeof(self) weakSelf = self;
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *mu_height_mu) {
        
        if (indexPath.row == 0) {
            
            MUKitSignalTableViewController  *controller = [MUKitSignalTableViewController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
            return ;
        }
        
        if (indexPath.row == 1) {
            
            MUKitDemoMVVMTableViewController  *controller = [MUKitDemoMVVMTableViewController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
            return ;
        }
    };


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
