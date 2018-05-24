//
//  MUKitDemoSignalController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/18.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalController.h"

@interface MUKitDemoSignalController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

@implementation MUKitDemoSignalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Signal案例讲解";
    self.tableView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    [self configuredDataSource ];
}
#pragma -mark init
-(void)configuredDataSource{
    
    self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];
    
    self.tableViewManger.tipsView.tipsImage = UIImageNamed(@"icon_store");
    
    NSArray *mArray = @[@"控件触发信号的条件",@"View(控件属于的view)",@"Cell(控件属于的UITableViewCell)",@"Controller(控件属于的控制器)"];
    self.tableViewManger.modelArray = mArray;
    
    weakify(self)
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        *height = 88.;
        cell.textLabel.text = NSStringFormat(@"%@",model);
        cell.textLabel.font = [UIFont systemFontOfSize:22.];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor     = [UIColor grayColor];
        cell.imageView.image = [UIImage imageNamed:@"Signal"];
        return cell;
    };
    
    
    
    //    weakify(self)
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
        normalize(self)
        if(indexPath.row == 0){
            [self.navigationController pushViewController:ClassName(MUKitDemoSignalConditionController) animated:YES];
        }
        if(indexPath.row == 1){
            [self.navigationController pushViewController:ClassName(MUKitDemoSignalsViewController) animated:YES];
        }
        if(indexPath.row == 2){
            [self.navigationController pushViewController:ClassName(MUKitSignalTableViewController) animated:YES];
        }
        if(indexPath.row == 3){
            [self.navigationController pushViewController:ClassName(MUKitDemoSignalsController) animated:YES];
        }
    };
    
    
    
}
@end
