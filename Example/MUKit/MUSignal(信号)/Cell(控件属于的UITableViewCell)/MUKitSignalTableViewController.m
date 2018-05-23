//
//  MUKitSignalTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitSignalTableViewController.h"
#import "MUKitDemoSignalView.h"
#import "MUKitDemoSignalCell.h"
#import "MUView.h"

//#import "UIScrollView+MUNormal.h"
@interface MUKitSignalTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

@implementation MUKitSignalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cell(控件属于的UITableViewCell)";
    self.view.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NSStringFromClass([MUKitDemoSignalCell class]) subKeyPath:nil];
    _tableViewManger.modelArray = [self modelData];
    [self configuredTableView];
}

-(NSMutableArray *)modelData{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    modelArray = [@[@"model1",@"model2",@"model3",@"model4",@"model5",@"model6",@"model7",@"model8",@"model9",@"model0"] mutableCopy];
                           
    return modelArray;
}
-(void)configuredTableView{
    
    weakify(self)
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
//        *height = 250.;
        return cell;

    };
//    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
//        normalize(self)
//        NSLog(@"点击了section=%ld,row=%ld,高度是=%f",indexPath.section,indexPath.row,*height);
//    };
//    
//    self.tableViewManger.titleForDeleteConfirmationButtonBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSString *__autoreleasing *title) {
//        
//        *title = @"删除";
//    };
//    
//    self.tableViewManger.deleteConfirmationButtonBlock = ^(UITableView *tableView, NSIndexPath *indexPath) {
//        normalize(self)
//        NSLog(@"点击了删除");
//    };
//    self.tableViewManger.editActionsForRowAtIndexPathBlock = ^NSArray<__kindof UITableViewRowAction *> *(UITableView *tableView, NSIndexPath *indexPath) {
//        
//        normalize(self)
//        UITableViewRowAction *tableaction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"可爱" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//             NSLog(@"点击了可爱");
//        }];
//        return @[tableaction];
//    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//UILabel
Click_MUSignal(label){
    
    UILabel *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UIButton
Click_MUSignal(_button){
    UIButton *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UISegmentedControl
Click_MUSignal(segmentedController){
    UISegmentedControl *view = object;
    NSIndexPath *indexPath = view.indexPath;
     NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UITextField
Click_MUSignal(textFile){
    UITextField *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UISlider
Click_MUSignal(slider){
    UISlider *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UISwitch
Click_MUSignal(muswitch){
    UISwitch *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}

//UIView
Click_MUSignal(blueView_view){
    UIView *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UIImageView
Click_MUSignal(mmimageView){
    UIImageView *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UIStepper
Click_MUSignal(stepper){
    UIStepper *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}

#warning 注意这里-----
//MUKitDemoSignalView
Click_MUSignal(infoView){//如果我没有被调用，你就去看看MUKitDemoSignalCell和MUKitDemoSignalView是不是把我拦截了

    MUKitDemoSignalView *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的的自定义view是MUKitDemoSignalView属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}

@end
