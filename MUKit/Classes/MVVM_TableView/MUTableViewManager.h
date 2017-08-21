//
//  MUTableViewManager.h
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UITableViewCell *(^MUTableViewRenderBlock)(UITableViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat *   height);//return your cell that you register in MUTableViewManager or your custom's cell
typedef UIView *(^MUTableHeaderViewRenderBlock)(UITableView * tableView ,NSUInteger sections, NSString **  title,id  model, CGFloat *  height);
typedef UIView *(^MUTableFooterViewRenderBlock)(UITableView *  tableView ,NSUInteger sections,NSString **  title ,id  model ,CGFloat *  height);
typedef void (^MUTableViewSelectedBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,id  model ,CGFloat *   height);











@interface MUTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>
-(instancetype )initWithTableView:(UITableView *)tableView subKeyPath:(NSString *)keyPath;
-(void)registerNib:(NSString *)nibName cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
-(void)registerCellClass:(NSString *)className cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
@property (nonatomic ,assign)CGFloat                     rowHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionHeaderHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionFooterHeight;//defalut is 0.001 point.
@property (nonatomic ,strong)NSMutableArray              *modelArray;//model's array
@property (nonatomic ,copy)MUTableViewRenderBlock        renderBlock;
@property (nonatomic ,copy)MUTableHeaderViewRenderBlock  headerViewBlock;
@property (nonatomic ,copy)MUTableFooterViewRenderBlock  footerViewBlock;
@property (nonatomic ,copy)MUTableViewSelectedBlock      selectedCellBlock;
@end
