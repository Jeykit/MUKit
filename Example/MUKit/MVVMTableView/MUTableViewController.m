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
    
    self.title = @"Customer";
    if (self.type == MemberTypeManager) {
        self.title = @"Manager";
    }
    _tableViewManager = [[MUTableViewManager alloc]initWithTableView:self.tableView subKeyPath:@"cellModelArray"];
    [_tableViewManager registerCellClass:NSStringFromClass([UITableViewCell class]) cellReuseIdentifier:Identify_CellWithImage];
    _tableViewManager.sectionHeaderHeight = 44.;
    _tableViewManager.modelArray = [self CustomerSigleModelArray];
//    _tableViewManager.modelArray = [self CustomerDoubleModelArray];
    
    [self configuredSigleModelTableView];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addData)];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)addData{
//    [_tableViewManager.modelArray addObjectsFromArray:[self CustomerSigleModelArray]];
//    [_tableViewManager.modelArray addObjectsFromArray:[self CustomerDoubleModelArray]];
}

-(void)configuredSigleModelTableView{
    
    self.tableViewManager.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        if (indexPath.section == 0&& indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_store"];
            *height = 88.;
        }
        if (indexPath.row % 2) {
            cell.contentView.backgroundColor = [UIColor blueColor];
        }else{
            cell.contentView.backgroundColor = [UIColor redColor];
        }
        cell.textLabel.text  = [NSString stringWithFormat:@"%@",model];
        return cell;

    };

    self.tableViewManager.headerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString **title, id model, CGFloat *height) {
        MUTableViewSectionModel *sectionModel = (MUTableViewSectionModel *)model;
        *title = sectionModel.title;
        return nil;
    };
    
    self.tableViewManager.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        *height = 88.;
    };
}

-(void)configuredDoubleModelTableView{
    
    self.tableViewManager.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        if (indexPath.section == 0&& indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_store"];
            *height = 88.;
        }
        MUTempModel *tempModel = (MUTempModel *)model;
        //        cell.textLabel.text  = [NSString stringWithFormat:@"%@",tempModel.name];
        cell.textLabel.text  = tempModel.name;
        return cell;

    };
//    self.tableViewManager.renderBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identify_CellWithImage];
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identify_CellWithImage];
//        }
//        if (indexPath.section == 0&& indexPath.row == 0) {
//            cell.imageView.image = [UIImage imageNamed:@"icon_store"];
//            *height = 88.;
//        }
//        MUTempModel *tempModel = (MUTempModel *)model;
////        cell.textLabel.text  = [NSString stringWithFormat:@"%@",tempModel.name];
//        cell.textLabel.text  = tempModel.name;
//        return cell;
//    };
    self.tableViewManager.headerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString **title, id model, CGFloat *height) {
        MUTableViewSectionModel *sectionModel = (MUTableViewSectionModel *)model;
        *title = sectionModel.title;
        return nil;
    };
    
    self.tableViewManager.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        *height = 88.;
    };
}
//两层模型
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


//单层模型
-(NSMutableArray *)CustomerSigleModelArray{
    NSMutableArray *array = [NSMutableArray array];
    MUTableViewSectionModel *section1 = [[MUTableViewSectionModel alloc]init];
    section1.title       = @"Store Info";
    section1.cellModelArray       = [@[@"MacBook Online"] mutableCopy];
    if (self.type == MemberTypeManager) {
        section1.cellModelArray       = [@[@"MacBook Online",@"View all products"] mutableCopy];
    }
    [array addObject:section1];
    
    if (self.type == MemberTypeManager) {
        MUTableViewSectionModel *section2 = [[MUTableViewSectionModel alloc]init];
        section2.title = @"Advanced Settings";
        section2.cellModelArray       = [@[@"Store Decoration",@"Store Location",@"Open Time"] mutableCopy];
        [array addObject:section2];
        
    }
   
    
    
    MUTableViewSectionModel *section3 = [[MUTableViewSectionModel alloc]init];
    section3.title         = @"Income Info";
    if (self.type == MemberTypeManager) {
          section3.cellModelArray       = [@[@"Withdraw",@"Orders",@"Income"] mutableCopy];
    }
    section3.cellModelArray       = [@[@"Orders",@"Income"] mutableCopy];
    [array addObject:section3];
    
    MUTableViewSectionModel *section4 = [[MUTableViewSectionModel alloc]init];
    section4.title         = @"Orther";
    section4.cellModelArray       = [@[@"About"] mutableCopy];
    [array addObject:section4];
    return  array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

