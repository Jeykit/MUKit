//
//  MUKitSignalTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitSignalTableViewController.h"
#import "MUTableViewCell.h"
#import <MUTableViewManager.h>
@interface MUKitSignalTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

static NSString * const cellIndentifier = @"cell";
@implementation MUKitSignalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView subKeyPath:nil];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MUTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellIndentifier];
    
}
-(void)configuredTableView{
    
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        MUTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
        
        *height = 96.;
        return cell;
        
    };
    
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        NSLog(@"点击了section=%ld,row=%ld,高度是=%f",indexPath.section,indexPath.row,*height);
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

Click_signal(redView){
    
    UIView *view = (UIView *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_signal(label){
    UILabel *view = (UILabel *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_signal(segmented){
    UISegmentedControl *view = (UISegmentedControl *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_signal(button){
    UIButton *view = (UIButton *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---------%@-------",indexPath);
}
Click_signal(infoView){
    NSLog(@"子视图------333333----%@",NSStringFromClass([object class]));
    UIButton *view = (UIButton *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------%@",NSStringFromClass([object class]),indexPath,NSStringFromClass([view.viewController class]));
}

@end
