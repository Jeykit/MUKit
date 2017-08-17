//
//  MUTableViewManager.h
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UITableViewCell *_Nullable(^MUTableViewRenderBlock)(UITableView * _Nullable tableView ,NSIndexPath * _Nonnull indexPath ,id _Nullable model ,CGFloat * _Nonnull  height);

typedef UIView *_Nullable(^MUTableHeaderViewRenderBlock)(UITableView * _Nullable tableView ,NSUInteger sections, NSString *_Nullable* _Nullable title,id _Nullable model, CGFloat * _Nonnull height);

typedef UIView *_Nullable(^MUTableFooterViewRenderBlock)(UITableView * _Nullable tableView ,NSUInteger sections,NSString *_Nullable* _Nullable title ,id _Nullable model ,CGFloat * _Nonnull height);

typedef void (^MUTableViewSelectedBlock)(UITableView * _Nonnull tableView ,NSIndexPath * _Nonnull indexPath ,id _Nullable model ,CGFloat * _Nonnull  height);

@interface MUTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>
-(instancetype _Nullable )initWithTableView:(UITableView *_Nullable)tableView subKeyPath:(NSString *_Nullable)keyPath;
//defalut is 44 point/
@property (nonatomic ,assign)CGFloat rowHeight;

//defalut is 44 point/
@property (nonatomic ,assign)CGFloat sectionHeaderHeight;

//defalut is 0.001 point/
@property (nonatomic ,assign)CGFloat sectionFooterHeight;

//model's array
@property (nonatomic ,strong)NSMutableArray * _Nonnull modelArray;

@property (nonatomic ,copy)MUTableViewRenderBlock _Nullable renderBlock;

@property (nonatomic ,copy)MUTableHeaderViewRenderBlock _Nullable headerViewBlock;

@property (nonatomic ,copy)MUTableFooterViewRenderBlock _Nullable footerViewBlock;

@property (nonatomic ,copy)MUTableViewSelectedBlock _Nullable selectedCellBlock;
@end
