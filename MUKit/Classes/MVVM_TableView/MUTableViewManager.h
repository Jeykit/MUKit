//
//  MUTableViewManager.h
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MURefreshHeaderComponent.h"
#import "MURefreshFooterComponent.h"

@class MURefreshHeaderComponent;
@class MURefreshFooterComponent;
@interface MUTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>
-(instancetype )initWithTableView:(UITableView *)tableView subKeyPath:(NSString *)keyPath;
-(void)registerNib:(NSString *)nibName cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
-(void)registerCellClass:(NSString *)className cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
@property (nonatomic ,assign)CGFloat                     rowHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionHeaderHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionFooterHeight;//defalut is 0.001 point.
@property (nonatomic ,strong)NSArray                     *modelArray;//model's array

@property(nonatomic, copy)UITableViewCell *(^renderBlock)(UITableViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat *  height);
@property(nonatomic, copy)UIView *(^headerViewBlock)(UITableView * tableView ,NSUInteger sections, NSString **  title,id  model, CGFloat *  height);
@property(nonatomic, copy)UIView *(^footerViewBlock)(UITableView *  tableView ,NSUInteger sections,NSString **  title ,id  model ,CGFloat *  height);
@property(nonatomic, copy)void (^selectedCellBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,id  model ,CGFloat *   height);

-(void)addHeaderRefreshing:(void(^)(MURefreshHeaderComponent *refresh))callback;
-(void)addFooterRefreshing:(void(^)(MURefreshFooterComponent *refresh))callback;
@end
