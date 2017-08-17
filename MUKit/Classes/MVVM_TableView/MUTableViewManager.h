//
//  MUTableViewManager.h
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define mu_height *mu_height
#define mu_title  *mu_title
typedef UITableViewCell *(^MUTableViewRenderBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,id _Nullable model ,CGFloat mu_height);

typedef UIView *(^MUTableHeaderViewRenderBlock)(UITableView *  tableView ,NSUInteger sections, NSString *mu_title,id  model, CGFloat mu_height);

typedef UIView *(^MUTableFooterViewRenderBlock)(UITableView *  tableView ,NSUInteger sections,NSString *mu_title ,id  model ,CGFloat mu_height);

typedef void (^MUTableViewSelectedBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,id  model ,CGFloat mu_height);

@interface MUTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>
-(instancetype _Nullable )initWithTableView:(UITableView *)tableView subKeyPath:(NSString *)keyPath;
//defalut is 44 point/
@property (nonatomic ,assign)CGFloat rowHeight;

//defalut is 44 point/
@property (nonatomic ,assign)CGFloat sectionHeaderHeight;

//defalut is 0.001 point/
@property (nonatomic ,assign)CGFloat sectionFooterHeight;

//model's array
@property (nonatomic ,strong)NSMutableArray *  modelArray;

@property (nonatomic ,copy)MUTableViewRenderBlock  renderBlock;

@property (nonatomic ,copy)MUTableHeaderViewRenderBlock  headerViewBlock;

@property (nonatomic ,copy)MUTableFooterViewRenderBlock  footerViewBlock;

@property (nonatomic ,copy)MUTableViewSelectedBlock  selectedCellBlock;
@end
