//
//  MUKitSignalTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoDynamicRowHeightController.h"
#import "MUTableViewCell.h"
#import <MUTableViewManager.h>
#import "MUTempModel.h"
#import "MUKitDemoTableViewCell.h"
#import "MUNavigation.h"
#import "UIImage+MUColor.h"

@interface MUKitDemoDynamicRowHeightController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

static NSString * const cellIndentifier = @"cell";
static NSString * const cellTempIndentifier = @"tempCell";
@implementation MUKitDemoDynamicRowHeightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dynamic row height with MUTableViewManager";
    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor purpleColor]];
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NSStringFromClass([MUKitDemoTableViewCell class]) subKeyPath:nil];
    //    [_tableViewManger registerNib:NSStringFromClass([MUTableViewCell class]) cellReuseIdentifier:cellTempIndentifier];
//    _tableViewManger.modelArray = [self modelData];
    
    //    _tableViewManger.CellReuseIdentifier = cellIndentifier;
    //    _tableViewManger.tableViewCell = (MUKitDemoTableViewCell *)[[[NSBundle bundleForClass:[MUKitDemoTableViewCell class]] loadNibNamed:NSStringFromClass([MUKitDemoTableViewCell class]) owner:nil options:nil] firstObject];
    [self configuredTableView];
}

-(NSMutableArray *)modelData{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    MUTempModel *model1 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写"];
    MUTempModel *model2 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写"];
    MUTempModel *model3 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写"];
    MUTempModel *model4 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试"];
    MUTempModel *model5 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试"];
    
    MUTempModel *model6 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试"];
    MUTempModel *model7 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试"];
    MUTempModel *model8 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写"];
    MUTempModel *model9 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写"];
    MUTempModel *model0 = [[MUTempModel alloc]initWithString:@"动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写,动态高度测试，随便写写"];
    
    modelArray = [@[model1,model2,model3,model4,model5,model6,model7,model8,model9,model0] mutableCopy];
    
    return modelArray;
}
-(void)configuredTableView{
    
    __weak typeof(self)weakSelef = self;
   __block NSUInteger number = 0;
     weakSelef.tableViewManger.modelArray = [weakSelef modelData];
    [self.tableViewManger addHeaderAutoRefreshing:^(MURefreshHeaderComponent *refresh) {
        [refresh endRefreshing];
//
        weakSelef.tableViewManger.modelArray = [weakSelef modelData];
    }];
    [self.tableViewManger addFooterRefreshing:^(MURefreshFooterComponent *refresh) {
        
        number += 1;
        weakSelef.tableViewManger.modelArray = [weakSelef modelData];
        [refresh noMoreData];
//        [refresh endRefreshing];
    }];

    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
//        NSLog(@"indexPath.row=%ld",indexPath.row);
        if (indexPath.row == 2 + number *10) {
            
            MUTableViewCell*  tableViewCell = [weakSelef.tableView dequeueReusableCellWithIdentifier:cellTempIndentifier];
            if (!tableViewCell) {
            
                
                tableViewCell = [[[NSBundle bundleForClass:NSClassFromString(NSStringFromClass([MUTableViewCell class]))] loadNibNamed:NSStringFromClass(NSClassFromString(NSStringFromClass([MUTableViewCell class]))) owner:nil options:nil] lastObject];
            }
            tableViewCell.model = model;
            return tableViewCell;//返回与注册不同的cell
        }else{
            MUKitDemoTableViewCell *tempCell = (MUKitDemoTableViewCell *)cell;
            tempCell.model = model;
            //        *height = 96.;
            return tempCell;
        }
        return cell;
        
    };
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        //        *height = 44.;
        NSLog(@"点击了section=%ld,row=%ld,高度是=%f",indexPath.section,indexPath.row,*height);
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
