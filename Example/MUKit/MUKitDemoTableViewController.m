//
//  MUKitDemoTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableViewController.h"
#import <MUTableViewManager.h>

@interface MUKitDemoTableViewController ()

@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end


static NSString *const cellReusedIndentifier = @"cell";
@implementation MUKitDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuredDataSource];
    [self configuredCell];
}
#pragma -mark init
-(void)configuredDataSource{
     _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView subKeyPath:nil];
    _tableViewManger.modelArray = [@[@"signal",@"MVVVTableView"] mutableCopy];

}

-(void)configuredCell{
    
    self.tableViewManger.renderBlock = ^UITableViewCell * _Nullable(UITableView * _Nullable tableView, NSIndexPath * _Nonnull indexPath, id  _Nullable model, CGFloat * _Nonnull height) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusedIndentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
    };
    
    self.tableViewManger.headerViewBlock = ^UIView * _Nullable(UITableView * _Nullable tableView, NSUInteger sections, NSString *__autoreleasing  _Nullable * _Nullable title, id  _Nullable model, CGFloat * _Nonnull height) {
        
       *title = @"Demo";
        *height = 44.;
        return nil;
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
