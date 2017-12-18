//
//  MUKitDemoPaperTableViewController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/18.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoPaperTableViewController.h"
#import "MUKitTestController.h"

@interface MUKitDemoPaperTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

@implementation MUKitDemoPaperTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PaperView";
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];;
    _tableViewManger.modelArray = [@[@"Underline",@"Block",@"Customer"] mutableCopy];
    weakify(self)
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
    };
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height)
    
    {
        normalize(self);
        if (indexPath.row == 0) {
            
            MUKitTestController *controller = [MUKitTestController new];
            controller.flag = 0;
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }else if (indexPath.row == 1){
            MUKitTestController *controller = [MUKitTestController new];
            controller.flag = 1;
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }else{
            MUKitTestController *controller = [MUKitTestController new];
            controller.flag = 2;
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }
        
        
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
