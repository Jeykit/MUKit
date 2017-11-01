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
#import "MUTipsView.h"


@class MURefreshHeaderComponent;
@class MURefreshFooterComponent;
@class MUTipsView;

@interface MUTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithTableView:(UITableView *)tableView;
-(instancetype)initWithTableView:(UITableView *)tableView registerCellNib:(NSString *)nibName subKeyPath:(NSString *)keyPath;
-(instancetype)initWithTableView:(UITableView *)tableView registerCellClass:(NSString *)className subKeyPath:(NSString *)keyPath;
@property (nonatomic ,assign)CGFloat                     rowHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionHeaderHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionFooterHeight;//defalut is 0.001 point.
@property (nonatomic ,strong)NSArray                     *modelArray;//model's array
@property (nonatomic ,assign)BOOL                        clearData;//model's array
@property(nonatomic, copy ,readonly)NSString             *cellReuseIdentifier;
@property(nonatomic, strong)MUTipsView                   *tipsView;//提示视图
@property(nonatomic, strong)UIColor                      *backgroundViewColor;//tableView backgroundView color
@property(nonatomic, strong)UIImage                      *backgroundViewImage;//tableView backgroundView image
//tableview
@property(nonatomic, copy)UITableViewCell *(^renderBlock)(UITableViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat *  height);
@property(nonatomic, copy)UIView *(^headerViewBlock)(UITableView * tableView ,NSUInteger sections, NSString **  title,id  model, CGFloat *  height);
@property(nonatomic, copy)UIView *(^footerViewBlock)(UITableView *  tableView ,NSUInteger sections,NSString **  title ,id  model ,CGFloat *  height);
@property(nonatomic, copy)void (^selectedCellBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,id  model ,CGFloat *   height);

//scroll
@property(nonatomic, copy)void (^scrollViewDidScroll)(UIScrollView *  scrollView);
@property(nonatomic, copy)void (^scrollViewDidEndDragging)(UIScrollView *  scrollView , BOOL decelerate);
@property(nonatomic, copy)void (^scrollViewDidEndScrollingAnimation)(UIScrollView *  scrollView);

-(void)addHeaderRefreshing:(void(^)(MURefreshHeaderComponent *refresh))callback;
-(void)addHeaderAutoRefreshing:(void(^)(MURefreshHeaderComponent *refresh))callback;
-(void)addFooterRefreshing:(void(^)(MURefreshFooterComponent *refresh))callback;
@end

