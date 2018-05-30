//
//  MUKitTestHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/29.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitTestHeaderView.h"
#import "MUScrollManager.h"
#import "MUKitDemoDynamicRowHeightController.h"
#import "MUTableViewController.h"


@interface MUKitTestHeaderView()

@property (weak, nonatomic) IBOutlet MUKitTestHeaderView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property(nonatomic, strong)MUPaperView *ppageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) MUScrollManager *manager;
@property (nonatomic,strong) NSArray *controllAray;

@property (nonatomic,strong) MUKitDemoDynamicRowHeightController *controller1;
@property (nonatomic,strong) MUTableViewController *controller2;
@end

@implementation MUKitTestHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.heightConstraint.constant = [UIScreen mainScreen].bounds.size.height;
 self.controllAray = [self controllerArray];
    
    
    //
 
}
-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
   
    self.ppageView = [[MUPaperView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.heightConstraint.constant) WithTopArray:titleArray WithObjects:self.controllAray];
    self.ppageView.hightlightColor = [UIColor purpleColor];
    self.ppageView.pagerStyles = MUPagerStyleBottomLine;
    self.ppageView.underlineHeight = 2.;
    self.ppageView.titleScale = 1.15;
    self.ppageView.autoFitTitleLine = YES;
    
    
    self.ppageView.tipsColor = [UIColor purpleColor];
    //    self.ppageView.topTabHeight = 88.;
    self.ppageView.hightlightColor = [UIColor purpleColor];
    [self.contentView addSubview:self.ppageView];
    
    NSArray *array =self.controllAray;
    UITableViewController *tableViewController =array[0];
    UITableView *tableView = (UITableView *)self.superview;
    UITableView *nestTableView = tableViewController.tableView;
    self.manager = [[MUScrollManager alloc]initWithScrollView:tableView nestedScrollView:nestTableView offset:284.];
    self.manager.marginHeight = 30.;
    __weak typeof(self)weakSelf = self;
    self.ppageView.slidedPageBlock = ^(NSUInteger previous, NSUInteger selcted) {
         UITableViewController *tableViewController =weakSelf.controllAray[selcted];
        weakSelf.manager.nestScrollViewMU = tableViewController.tableView;
    };
}

-(NSArray *)controllerArray{
    MUKitDemoDynamicRowHeightController *con1 = [MUKitDemoDynamicRowHeightController new];
    con1.view.backgroundColor = [UIColor cyanColor];
    _controller1 = con1;
    MUTableViewController *con2 = [MUTableViewController new];
    con2.view.backgroundColor = [UIColor purpleColor];
    _controller2 = con2;
//    UIViewController *con3 = [MUKitDemoDynamicRowHeightController new];
//    con3.view.backgroundColor = [UIColor cyanColor];
//    UIViewController *con4 = [MUKitDemoDynamicRowHeightController new];
//    con4.view.backgroundColor = [UIColor orangeColor];
//    UIViewController *con5 = [MUKitDemoDynamicRowHeightController new];
//    con5.view.backgroundColor = [UIColor greenColor];
//    UIViewController *con6 = [MUKitDemoDynamicRowHeightController new];
//    con6.view.backgroundColor = [UIColor blackColor];
    NSArray *array =@[con1,con2];
    return array;
}


@end
