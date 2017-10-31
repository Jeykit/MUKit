//
//  MUKitSignalTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitSignalTableViewController.h"
#import <MUTableViewManager.h>
#import "MUKitDemoSignalCell.h"
#import "MUView.h"
#import <UIViewController+MUPopup.h>
//#import <MUPopupController.h>
#import "MUNavigation.h"
#import <UIImage+MUColor.h>
//#import "UIScrollView+MUNormal.h"
@interface MUKitSignalTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end

static NSString * const cellIndentifier = @"cell";
static NSString * const cellTempIndentifier = @"tempCell";

@implementation MUKitSignalTableViewController
-(instancetype)init{
    if (self = [super init]) {
       self.titleMu = @"Orange";
//        self.contentSizeInPopup = CGSizeMake(300, 200);
//        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"hello" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
    }
    return self;
}

- (void)nextBtnDidTap
{
//     [self.popupController popViewControllerAnimated:YES];
//    [self.popupController popToRootViewControllerAnimated:YES];
//    [self.popupController pushViewController:[NSClassFromString(@"MUViewController") new] animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
   
    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor orangeColor]];
//    self.navigationBarAlphaMu = 0;
//    self.navigationBarBackgroundColorMu = [UIColor orangeColor];
//    self.navigationBarBackgroundImageMu = [UIImage imageFromColor:[UIColor purpleColor]];
//    self.view.frame = [UIScreen mainScreen].bounds;
//    self.navigationBarHiddenMu = YES;
//    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
//        if (@available(iOS 11.0, *)) {
//            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
//    }
//    self.tableView.adjustedContentInset
//    self.showBackButtonText = NO;
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//    }
    self.navigationBarTintColor = [UIColor blackColor];
    _tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NSStringFromClass([MUKitDemoSignalCell class]) subKeyPath:nil];
    
//    [_tableViewManger registerNib:NSStringFromClass([MUTableViewCell class]) cellReuseIdentifier:cellTempIndentifier];
    _tableViewManger.modelArray = [self modelData];
    
//    _tableViewManger.CellReuseIdentifier = cellIndentifier;
//    _tableViewManger.tableViewCell = (MUKitDemoTableViewCell *)[[[NSBundle bundleForClass:[MUKitDemoTableViewCell class]] loadNibNamed:NSStringFromClass([MUKitDemoTableViewCell class]) owner:nil options:nil] firstObject];
    [self configuredTableView];
}

-(NSMutableArray *)modelData{
    NSMutableArray *modelArray = [NSMutableArray array];
    
    modelArray = [@[@"model1",@"model2",@"model3",@"model4",@"model5",@"model6",@"model7",@"model8",@"model9",@"model0"] mutableCopy];
                           
    return modelArray;
}
-(void)configuredTableView{
    
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
//        *height = 250.;
        return cell;

    };
    self.tableViewManger.selectedCellBlock = ^(UITableView *tableView, NSIndexPath *indexPath, id model, CGFloat *height) {
        
//        *height = 44.;
        NSLog(@"点击了section=%ld,row=%ld,高度是=%f",indexPath.section,indexPath.row,*height);
    };
    __weak typeof(self)weakself = self;
    self.tableViewManger.scrollViewDidScroll = ^(UIScrollView *scollView) {
        
        CGFloat alpha = scollView.contentOffset.y/self.navigationBarAndStatusBarHeight;
        weakself.navigationBarAlphaMu = alpha;
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

Click_MUSignal(label){
    
    UILabel *view = (UILabel *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号------%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(button){
    UIButton *view = (UIButton *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号-----%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(segmentedController){
    UISegmentedControl *view = (UISegmentedControl *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号------%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(textFile){
    UITextField *view = (UITextField *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号%@---------%@-------%@",NSStringFromClass([object class]),indexPath,view.text);
}

Click_MUSignal(slider){
    UISlider *view = (UISlider *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号%@---------%@-------%@",NSStringFromClass([object class]),indexPath,NSStringFromClass([view.viewController class]));
}

Click_MUSignal(muswitch){
    UISwitch *view = (UISwitch *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号-----%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(greenView){
    MUView *view = (MUView *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号------%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(blueView){
    UIView *view = (UIView *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(mmimageView){
    UIImageView *view = (UIImageView *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号%@---------%@------",NSStringFromClass([object class]),indexPath);
}

Click_MUSignal(stepper){
    UIStepper *view = (UIStepper *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号%@---------%@------",NSStringFromClass([object class]),indexPath);
}
@end
