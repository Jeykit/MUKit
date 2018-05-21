//
//  MUKitDemoAlphaController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/10.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoAlphaController.h"
#import <MUTableViewManager.h>
#import "MUTempModel.h"
#import "MUTableViewCell.h"
#import "MUKitDemoTableViewCell.h"

@interface MUKitDemoAlphaController ()

@property(nonatomic, strong)MUTableViewManager *tableViewManger;

@end


static NSString * const cellIndentifier = @"cell";
static NSString * const cellTempIndentifier = @"tempCell";
@implementation MUKitDemoAlphaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Alpha Navigation";
    self.navigationBarAlphaMu = 0;//透明导航栏。无需其它代码设置，这样不会影响到其它控制器navigation bar样式
    self.tableView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    
    
    
    [self configuredTableView];
}

//MVVM
-(void)configuredTableView{
    
     _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NameToString(MUKitDemoTableViewCell) subKeyPath:nil];
    __block NSUInteger number = 0;
     weakify(self)
    self.tableViewManger.modelArray = [self testModelData];
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
         normalize(self)
        if (indexPath.row == 2 + number *10) {
            
            MUTableViewCell*  tableViewCell = [self.tableView dequeueReusableCellWithIdentifier:cellTempIndentifier];
            if (!tableViewCell) {
                tableViewCell = [[[NSBundle bundleForClass:NSClassFromString(NSStringFromClass([MUTableViewCell class]))] loadNibNamed:NSStringFromClass(NSClassFromString(NSStringFromClass([MUTableViewCell class]))) owner:nil options:nil] lastObject];
            }
            tableViewCell.model = model;
            return tableViewCell;//返回与注册不同的cell
        }else{
            MUKitDemoTableViewCell *tempCell = (MUKitDemoTableViewCell *)cell;
            tempCell.model = model;
            return tempCell;
        }
        return cell;
        
    };
   
    self.tableViewManger.scrollViewDidScroll = ^(UIScrollView *scrollView) {
        normalize(self)
        if (scrollView.contentOffset.y <= self.navigationBarAndStatusBarHeight) {
            CGFloat alpha = scrollView.contentOffset.y/self.navigationBarAndStatusBarHeight;
            self.navigationBarAlphaMu = alpha;
        }
        
    };
}

//测试数据
-(NSMutableArray *)testModelData{
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
@end
