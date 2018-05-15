//
//  MUTableViewController.m
//  SigmaTableViewModel
//
//  Created by zeng ping on 2017/8/3.
//  Copyright © 2017年 yangke. All rights reserved.
//

#import "MUTableViewController.h"
#import <MUTableViewManager.h>
#import "MUTableViewSectionModel.h"
#import "MUTempModel.h"
#import <MUNavigation.h>

@interface MUTableViewController ()
@property (nonatomic ,strong)MUTableViewManager *tableViewManager;
@property(nonatomic, strong)NSMutableArray *modelArray;
@end
static NSString *Identify_CellWithImage = @"CellWithImage";
static NSString *Identify_EntryCell = @"EntryCell";
static NSString *Identify_CellWithBigFont = @"CellWithBigFont";


@implementation MUTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"分组模型";
    [self configuredDoubleModelTableView];
}



-(void)configuredDoubleModelTableView{
    //初始化MUTableViewManager，‘cellModelArray’存储的是每一个cell对应的模型
    _tableViewManager = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:@"cellModelArray"];
    
    //模型
    _tableViewManager.modelArray = [self CustomerDoubleModelArray];
    
    //给cell赋值
    self.tableViewManager.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        if (indexPath.section == 0&& indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_store"];
            *height = 88.;
        }
        MUTempModel *tempModel = model;
        cell.textLabel.text  = tempModel.name;
        return cell;

    };

    //点击cell后的处理
    self.tableViewManager.headerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString **title, id model, CGFloat *height) {
        MUTableViewSectionModel *sectionModel = (MUTableViewSectionModel *)model;
        *title = sectionModel.title;
        return nil;
    };
 
}
//模拟模型数据
-(NSMutableArray *)CustomerDoubleModelArray{
    NSMutableArray *array = [NSMutableArray array];
    MUTableViewSectionModel *section1 = [[MUTableViewSectionModel alloc]init];
    section1.title       = @"Store Info";
    MUTempModel *model1        = [[MUTempModel alloc]initWithString: @"MacBook Online"];
    section1.cellModelArray       = [@[model1] mutableCopy];
    if (self.type == MemberTypeManager) {
        MUTempModel *model2        = [[MUTempModel alloc]initWithString: @"View all products"];
        section1.cellModelArray       = [@[model1,model2] mutableCopy];
    }
    [array addObject:section1];
    
    if (self.type == MemberTypeManager) {
        MUTableViewSectionModel *section2 = [[MUTableViewSectionModel alloc]init];
        section2.title = @"Advanced Settings";
        MUTempModel *model2        = [[MUTempModel alloc]initWithString:@"Store Decoration"];
        MUTempModel *model3        = [[MUTempModel alloc]initWithString:@"Store Location"];
        MUTempModel *model4        = [[MUTempModel alloc]initWithString:@"Open Time"];
        section2.cellModelArray       = [@[model2,model3,model4] mutableCopy];
        [array addObject:section2];

    }
    
    
    MUTableViewSectionModel *section3 = [[MUTableViewSectionModel alloc]init];
    section3.title         = @"Income Info";
    MUTempModel *model5        = [[MUTempModel alloc]initWithString:@"Withdraw"];
    MUTempModel *model6        = [[MUTempModel alloc]initWithString:@"Orders"];
    MUTempModel *model7        = [[MUTempModel alloc]initWithString:@"Income"];
    if (self.type == MemberTypeManager) {
          section3.cellModelArray       = [@[model5,model6,model7] mutableCopy];
    }
    section3.cellModelArray       = [@[model6,model7] mutableCopy];
    [array addObject:section3];
    
    MUTableViewSectionModel *section4 = [[MUTableViewSectionModel alloc]init];
    section4.title         = @"Orther";
    MUTempModel *model9        = [[MUTempModel alloc]initWithString:@"Orders"];
    section3.cellModelArray       = [@[model9] mutableCopy];
    [array addObject:section4];
    return  array;
}


@end

