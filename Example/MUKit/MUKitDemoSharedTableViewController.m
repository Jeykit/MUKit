//
//  MUKitDemoSharedTableViewController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoSharedTableViewController.h"
#import <MUTableViewManager.h>
#import "MUSharedManager.h"

@interface MUKitDemoSharedTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

@implementation MUKitDemoSharedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"shared";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self configuredDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark init
-(void)configuredDataSource{
    
    self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];
    __block NSArray *mArray = [NSArray array];
    __weak typeof(self)weakSelef = self;
    
    self.tableViewManger.tipsView.tipsImage = [UIImage imageNamed:@"icon_store"];
    //    [self.tableViewManger addHeaderRefreshing:^(MURefreshHeaderComponent *refresh) {
    
    
    //          weakSelef.tableViewManger.modelArray = mArray;
    mArray = @[@"微信好友分享",@"微信朋友圈",@"QQ好友分享",@"QQ空间分享",@"微博分享"];
    weakSelef.tableViewManger.modelArray = mArray;
  
    
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
    };
    
    self.tableViewManger.headerViewBlock = ^UIView * (UITableView *  tableView, NSUInteger sections, NSString *__autoreleasing   *  title, id   model, CGFloat *  height) {
        *title  = @"Demo";
        
        return nil;
    };
    
    self.tableViewManger.footerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString *__autoreleasing *title, id model, CGFloat *height) {
        
        *title = @"我想写就写";
        return nil;
    };
    
    __weak typeof(self) weakSelf = self;
    
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
        
        if (indexPath.row == 0) {
            
            [MUSharedManager sharedContentToWeChatFriend:^(MUSharedModel *model) {
                model.sharedTitle = @"测试标题";
                model.sharedContent = @"测试内容";
                model.sharedUrl = @"https://www.baidu.com";
                UIImage* image = [UIImage imageNamed:@"icon_store"];
                model.sharedThumbImageData = UIImagePNGRepresentation(image) ;
            } result:^(BOOL success) {
            NSLog(@"分享成功");
            }];
            return ;
        }
        
        if (indexPath.row == 1) {
            
            [MUSharedManager sharedContentToWeChatCircle:^(MUSharedModel *model) {
                model.sharedTitle = @"测试标题";
                model.sharedContent = @"测试内容";
                model.sharedUrl = @"https://www.baidu.com";
                UIImage* image = [UIImage imageNamed:@"icon_store"];
                model.sharedThumbImageData = UIImagePNGRepresentation(image) ;
            } result:^(BOOL success) {
                NSLog(@"分享成功");
            }];
         
            return ;
        }
        if (indexPath.row == 2) {
            [MUSharedManager sharedContentToQQFriend:^(MUSharedModel *model) {
                model.sharedTitle = @"测试标题";
                model.sharedContent = @"测试内容";
                model.sharedUrl = @"https://www.baidu.com";
                UIImage* image = [UIImage imageNamed:@"icon_store"];
                model.sharedThumbImageData = UIImagePNGRepresentation(image) ;
            } result:^(BOOL success) {
                NSLog(@"分享成功");
            }];
          
            return ;
        }
        if (indexPath.row == 3) {
            [MUSharedManager sharedContentToQQZone:^(MUSharedModel *model) {
                model.sharedTitle = @"测试标题";
                model.sharedContent = @"测试内容";
                model.sharedUrl = @"https://www.baidu.com";
                UIImage* image = [UIImage imageNamed:@"icon_store"];
                model.sharedThumbImageData = UIImagePNGRepresentation(image) ;
            } result:^(BOOL success) {
                NSLog(@"分享成功");
            }];
           
        }
        
        if (indexPath.row == 4) {
            
            [MUSharedManager sharedContentToWeiBo:^(MUSharedModel *model) {
                model.sharedTitle = @"测试标题";
                model.sharedContent = @"测试内容";
                model.sharedUrl = @"https://www.baidu.com";
                UIImage* image = [UIImage imageNamed:@"icon_store"];
                model.sharedThumbImageData = UIImagePNGRepresentation(image) ;
            } result:^(BOOL success) {
                NSLog(@"分享成功");
            }];
        }
    };
    
    
}

@end
