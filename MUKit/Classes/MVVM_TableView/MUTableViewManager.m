//
//  MUTableViewManager.m
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUTableViewManager.h"
#import "MUAddedPropertyModel.h"
#import "MUHookMethodHelper.h"
#import "MUTipsView.h"
#import "UIView+MUSignal.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface MUTableViewManager()
@property (nonatomic ,weak)UITableView *tableView;
@property (nonatomic ,copy)NSString *keyPath;
@property (nonatomic ,assign,getter=isSection)BOOL section;
@property (nonatomic ,strong)MUAddedPropertyModel *dynamicProperty;
@property (nonatomic ,copy)NSString *cellModelName;
@property (nonatomic ,copy)NSString *sectionModelName;
@property(nonatomic, copy)NSString *cellReuseIdentifier;
@property(nonatomic, strong)UITableViewCell *tableViewCell;

@property(nonatomic, strong)NSMutableArray *innerModelArray;
@property(nonatomic, strong)NSMutableArray *indexPathArray;
@property(nonatomic, strong)MURefreshFooterComponent *refreshFooter;
@property(nonatomic, assign ,getter=isUpToRefresh)BOOL upToRefresh;
@property(nonatomic, assign)CGPoint contentOffset;

@property(nonatomic, strong)MUTipsView *tipView;
@property(nonatomic, strong)UIView *backgroundView;
@end


static NSString * const sectionFooterHeight = @"sectionFooterHeight";
static NSString * const sectionHeaderHeight = @"sectionHeaderHeight";
static NSString * const sectionFooterTitle  = @"sectionFooterTitle";
static NSString * const sectionHeaderTitle  = @"sectionHeaderTitle";

static NSString * const selectedState = @"selectedState";
static NSString * const rowHeight = @"rowHeight";
@implementation MUTableViewManager

-(void)setBackgroundViewColor:(UIColor *)backgroundViewColor{
    _backgroundViewColor = backgroundViewColor;
    if (_backgroundViewColor) {
        self.backgroundView.backgroundColor = backgroundViewColor;
    }
}
-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64., CGRectGetWidth(self.tableView.frame),0)];
        UIView *view = [UIView new];
        [view addSubview:_backgroundView];
        self.tableView.backgroundView = view;
    }
    return _backgroundView;
}
-(instancetype)initWithTableView:(UITableView *)tableView{//只需要刷新
    if (self = [super init]) {
         _tableView           = tableView;
         _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
-(instancetype)initWithTableView:(UITableView *)tableView registerCellNib:(NSString *)nibName subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        _tableView           = tableView;
        UIViewController *tempController = _tableView.viewController;
        if (tempController.navigationController) {
             _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(tableView.bounds) - 64.)];
        }else{
              _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(tableView.bounds))];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView addSubview:_tipView];
        _tipsView            = _tipView;
        _tableView.estimatedRowHeight = 88.;
        _keyPath             = keyPath;
        _rowHeight           = 44.;
        _sectionHeaderHeight = 0.001;
        _sectionFooterHeight = 0.001;
        _dynamicProperty = [[MUAddedPropertyModel alloc]init];
        _contentOffset      = CGPointZero;
        _cellReuseIdentifier = @"MUCellReuseIdentifier";
         _tableViewCell       = [[[NSBundle bundleForClass:NSClassFromString(nibName)] loadNibNamed:NSStringFromClass(NSClassFromString(nibName)) owner:nil options:nil] lastObject];
         [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:_cellReuseIdentifier];
    }
    return self;
}

-(instancetype)initWithTableView:(UITableView *)tableView registerCellClass:(NSString *)className subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        _tableView           = tableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIViewController *tempController = _tableView.viewController;
        if (tempController.navigationController) {
            _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(tableView.bounds) - 64.)];
        }else{
            _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(tableView.bounds))];
        }
        [_tableView addSubview:_tipView];
        _tipsView            = _tipView;
        _tableView.estimatedRowHeight = 88.;
        _keyPath             = keyPath;
        _rowHeight           = 44.;
        _sectionHeaderHeight = 0.001;
        _sectionFooterHeight = 0.001;
        _dynamicProperty = [[MUAddedPropertyModel alloc]init];
        _contentOffset      = CGPointZero;
        _cellReuseIdentifier = @"MUCellReuseIdentifier";
        _tableViewCell       = [[NSClassFromString(className) alloc]init];
        [_tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:_cellReuseIdentifier];
    }
    return self;
}
-(void)configuredWithArray:(NSArray *)array name:(NSString *)name{
    
    id object = array[0];
    if (!name || [_cellModelName isEqualToString:NSStringFromClass([object class])]) {
         _cellModelName = NSStringFromClass([object class]);
        [self configureSigleSection:_dynamicProperty object:object];
        return;
    }
    NSArray *subArray = [object valueForKey:name];
    if (subArray) {
        _section = YES;
        NSString *sectionName = NSStringFromClass([object class]);
        id model = subArray[0];
        NSString *cellName = NSStringFromClass([model class]);
        if (![sectionName isEqualToString:_sectionModelName]) {
            
            [self configuredSectionWithDynamicModel:_dynamicProperty object:object];
        }
        if (![cellName isEqualToString:_cellModelName]) {
            [self configuredRowWithDynamicModel:_dynamicProperty object:model];
        }
        
    }
}

#pragma mark -configured  
-(void)configureSigleSection:(MUAddedPropertyModel *)model object:(id)object{
    [self configuredSectionWithDynamicModel:model object:object];//configured section
    [self configuredRowWithDynamicModel:model object:object];//configured row
}
-(void)configuredSectionWithDynamicModel:(MUAddedPropertyModel *)model object:(id)object{
    [model addProperty:object propertyName:sectionHeaderHeight type:MUAddedPropertyTypeAssign];
    [model addProperty:object propertyName:sectionFooterHeight type:MUAddedPropertyTypeAssign];
    [model addProperty:object propertyName:sectionHeaderTitle type:MUAddedPropertyTypeRetain];
    [model addProperty:object propertyName:sectionFooterTitle type:MUAddedPropertyTypeRetain];
}
-(void)configuredRowWithDynamicModel:(MUAddedPropertyModel *)model object:(id)object{
    [model addProperty:object propertyName:rowHeight type:MUAddedPropertyTypeAssign];
//    [model addProperty:object propertyName:selectedState type:MUAddedPropertyTypeAssign];
}

-(void)setClearData:(BOOL)clearData{
    _clearData = clearData;
    if (clearData) {
        [self.tableView addSubview:self.tipsView];
        self.innerModelArray = [NSMutableArray array];
        [self.tableView reloadData];
    }
}
#pragma mark - dataSource
-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    [self insertModelArray:modelArray];
}
-(void)setInnerModelArray:(NSMutableArray *)innerModelArray{
    _innerModelArray = innerModelArray;
    if (innerModelArray.count == 0) {
        return;
    }
    
    [self configuredWithArray:innerModelArray name:_keyPath];
    
}
-(void)insertModelArray:(NSArray *)array{//数据源处理
    
  
    if (!self.refreshFooter.isRefresh) {//下拉刷新
        self.tableView.delegate   = self;
        self.tableView.dataSource = self;
        self.innerModelArray     = [array mutableCopy];
       
    }
    else{//上拉刷新
        [self.innerModelArray addObjectsFromArray:array];
       
    }
    if (self.tipView.superview) {//有数据时隐藏
        [self.tipView removeFromSuperview];
    }
    [self.tableView reloadData];
    self.refreshFooter.refresh  = NO;
}

#pragma mark - dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSection) {
       return self.innerModelArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isSection) {
        
        id model = self.innerModelArray[section];
        NSArray *subArray = [model valueForKey:_keyPath];
        return subArray.count;
    }
    return self.innerModelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    id object = nil;
    if (self.isSection) {
        object  = self.innerModelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.innerModelArray[indexPath.row];
    }
     CGFloat height  = self.rowHeight;
    UITableViewCell *resultCell = nil;
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
    if (self.renderBlock) {
        resultCell = self.renderBlock(resultCell,indexPath,object,&height);//检测是否有自定义cell
        
        if (!resultCell) {//没有则注册一个
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
             resultCell = self.renderBlock(cell,indexPath,object,&height);
        }
    }
    
    return resultCell;
}

#pragma -mark dynamic row height
// See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
// See: FDTemplateLayoutCell
-(CGFloat)dynamicRowHeight:(UITableViewCell *)cell tableView:(UITableView *)tableView{
  
    
    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);
    cell.bounds = CGRectMake(0.0f, 0.0f, contentViewWidth, CGRectGetHeight(cell.bounds));
    CGFloat accessroyTypeWidth = 0;
    if (cell.accessoryView) {//if a cell has accessorynview or system accessory type ,its content view's width smaller than origin.we can do this fix this problem.
        accessroyTypeWidth = 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        static const CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        accessroyTypeWidth = systemAccessoryWidths[cell.accessoryType];
    }
    contentViewWidth -= accessroyTypeWidth;
    
    
    // If not using auto layout, you have to override "-sizeThatFits:" to provide a fitting size by yourself.
    // This is the same height calculation passes used in iOS8 self-sizing cell's implementation.
    //
    // 1. Try "- systemLayoutSizeFittingSize:" first. (skip this step if 'fd_enforceFrameLayout' set to YES.)
    // 2. Warning once if step 1 still returns 0 when using AutoLayout
    // 3. Try "- sizeThatFits:" if step 1 returns 0
    // 4. Use a valid height or default row height (44) if not exist one
    CGFloat fittingHeight = 0;
    
    
    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    
    // [bug fix] after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
    static BOOL isSystemVersionEqualOrGreaterThen10_2 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
    });
    
    NSArray<NSLayoutConstraint *> *edgeConstraints;
    if (isSystemVersionEqualOrGreaterThen10_2) {
        // To avoid confilicts, make width constraint softer than required (1000)
        widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
        
        // Build edge constraints
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:accessroyTypeWidth];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        edgeConstraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
        [cell addConstraints:edgeConstraints];
        
        
        [cell.contentView addConstraint:widthFenceConstraint];
        
        //            fittingHeight = 44.;
        // Auto layout engine does its math
        fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        // Clean-ups
        [cell.contentView removeConstraint:widthFenceConstraint];
        if (isSystemVersionEqualOrGreaterThen10_2) {
            [cell removeConstraints:edgeConstraints];
        }
    }
    
    if (fittingHeight == 0) {
#if DEBUG
        // Warn if using AutoLayout but get zero height.
        if (cell.contentView.constraints.count > 0) {
            if (!objc_getAssociatedObject(self, _cmd)) {
                NSLog(@"[MUTableViewManager] Warning once only: Cannot get a proper cell height (now 0) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
                objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
#endif
        // Try '- sizeThatFits:' for frame layout.
        // Note: fitting height should not include separator view.
        fittingHeight = [cell sizeThatFits:CGSizeMake(contentViewWidth, 0)].height;
    }
    
    // Still zero height after all above.
    if (fittingHeight == 0) {
        // Use default row height.
        fittingHeight = 44;
    }
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / [UIScreen mainScreen].scale;
    }
    return fittingHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = nil;
    if (self.isSection) {
        object  = self.innerModelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.innerModelArray[indexPath.row];
    }
    CGFloat height  = [self.dynamicProperty getValueFromObject:object name:rowHeight];
    if (height > 0) {
//        NSLog(@"%@--------rowHeight=%f",indexPath,height);
        return height;
    }
    
    height = self.rowHeight;
    CGFloat tempHeight = height;
    UITableViewCell *cell = nil;
    if (self.renderBlock) {
      cell = self.renderBlock(_tableViewCell,indexPath,object,&height);//取回真实的cell，实现cell的动态行高
    }
    if (tempHeight == height) {
        if (self.cellReuseIdentifier) {
            height = [self dynamicRowHeight:cell tableView:tableView];//计算cell的动态行高
//             NSLog(@"%@--------rowHeight=%f",indexPath,height);
        }
    }
   
    [self.dynamicProperty setValueToObject:object name:rowHeight value:height];
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headerView      = nil;
    if (!self.headerViewBlock) {
        return headerView;
    }
     NSString * title = @"";
    id model = self.innerModelArray[section];
    CGFloat height = self.sectionHeaderHeight;
    if (self.headerViewBlock) {
        
        headerView = self.headerViewBlock(tableView,section,&title,model,&height);
    }
    tableView.sectionHeaderHeight = 0;
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{//刷新数据时调用

    
  
    CGFloat height = self.sectionHeaderHeight;
    if (!self.headerViewBlock) {
        return height;
    }
//    if (!self.isSection) {
//        
//        return 44.;
//    }
    id model = self.innerModelArray[section];
     NSString * title = @"";
    height  = [self.dynamicProperty getValueFromObject:model name:sectionHeaderHeight];
    if (height >0) {
        return height;
    }
    height = self.sectionHeaderHeight;
    if (self.headerViewBlock) {
        
        self.headerViewBlock(nil, section,&title, nil, &height);
//        NSLog(@"section ======== %ld",section);
    }
    if (title) {
        height = 44.;
        [self.dynamicProperty setObjectToObject:model name:sectionHeaderTitle value:title];
    }
    [self.dynamicProperty setValueToObject:model name:sectionHeaderHeight value:height];

    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *footerView      = nil;
    if (!self.footerViewBlock) {
        return footerView;
    }
    id model = self.innerModelArray[section];
    NSString * title = @"";
    CGFloat height = self.sectionFooterHeight;
    if (self.footerViewBlock) {
        
        footerView = self.footerViewBlock(tableView, section,&title, model, &height);
    }
    return footerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{//刷新数据时调用
   
    CGFloat height = self.sectionFooterHeight;
    if (!self.footerViewBlock) {
        return height;
    }
     id model = self.innerModelArray[section];
    height  = [self.dynamicProperty getValueFromObject:model name:sectionFooterHeight];
    if (height >0) {
        return height;
    }
    NSString * title = @"";
    height = self.sectionFooterHeight;
    if (self.footerViewBlock) {
        
        self.footerViewBlock(nil, section, &title,nil, &height);
    }
    if (title) {
        height = 44.;
        [self.dynamicProperty setObjectToObject:model name:sectionFooterTitle value:title];
    }
    [self.dynamicProperty setValueToObject:model name:sectionFooterHeight value:height];
    
    return height;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * title = @"";
    if (!self.headerViewBlock) {
        return nil;
    }
    id model = self.innerModelArray[section];
    title = (NSString *)[self.dynamicProperty getObjectFromObject:model name:sectionHeaderTitle];
    if (title.length > 0) {
//        self.sectionHeaderHeight = 44.;
        return title;
    }
    CGFloat height = self.sectionHeaderHeight;
    if (self.headerViewBlock) {
        self.headerViewBlock(nil, section, &title,model, &height);
    }
    [self.dynamicProperty setValueToObject:model name:sectionHeaderHeight value:height];
    [self.dynamicProperty setObjectToObject:model name:sectionHeaderTitle value:title];
    return title;

}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString * title = @"";
    if (!self.footerViewBlock) {
        return nil;
    }
    id model = self.innerModelArray[section];
    title = (NSString *)[self.dynamicProperty getObjectFromObject:model name:sectionFooterTitle];
    if (title.length > 0) {
        return title;
    }
    CGFloat height = self.sectionFooterHeight;
    if (self.footerViewBlock) {
        self.footerViewBlock(nil, section, &title,model, &height);
    }
    [self.dynamicProperty setValueToObject:model name:sectionFooterHeight value:height];
    [self.dynamicProperty setObjectToObject:model name:sectionFooterTitle value:title];
    return title;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedCellBlock) {
        id object = nil;
        if (self.isSection) {
            object  = self.innerModelArray[indexPath.section];
            NSArray *subArray = [object valueForKey:_keyPath];
            object  = subArray[indexPath.row];
        }else{
            object  = self.innerModelArray[indexPath.row];
        }
        
        CGFloat height  = [self.dynamicProperty getValueFromObject:object name:rowHeight];
        CGFloat tempHeight = height;
        self.selectedCellBlock(tableView, indexPath, object, &height);
        if (height != tempHeight) {
             [self.dynamicProperty setValueToObject:object name:rowHeight value:height];
//            [self.dynamicProperty setValueToObject:object name:selectedState value:height];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
       
    }
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (self.isSection) {
//        if (self.innerModelArray.count == indexPath.section + 1) {
//            id object  = self.innerModelArray[indexPath.section];
//            NSArray *subArray = [object valueForKey:_keyPath];
//            if (subArray.count == indexPath.row + 2) {
//                [self.refreshFooter startRefresh];
//            }
//        }
//    }else{
//        if (self.innerModelArray.count == indexPath.row + 1) {
//            [self.refreshFooter startRefresh];
//        }
//    }
//}
#pragma mark -make sure to call cellForRowAtIndexPath: and call heightForRowAtIndexPath: then;

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//      self.contentOffset = scrollView.contentOffset;
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{//make sure to call
//    
//    return self.rowHeight;
//}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    
//    return 0.001;
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return 0.001;
//}

#pragma mark - scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.backgroundViewColor) {
        self.backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), -self.tableView.contentOffset.y);
    }
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(scrollView);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.scrollViewDidEndDragging) {
        self.scrollViewDidEndDragging(scrollView, decelerate);
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.scrollViewDidEndScrollingAnimation) {
        self.scrollViewDidEndScrollingAnimation(scrollView);
    }
}
#pragma mark -refreshing
-(void)addFooterRefreshing:(void (^)(MURefreshFooterComponent *))callback{
    self.refreshFooter = [[MURefreshFooterComponent alloc]initWithFrame:CGRectZero callback:callback];
    _refreshFooter.frame = CGRectMake(self.tableView.contentOffset.x, self.tableView.contentSize.height + self.tableView.contentOffset.y - self.tableView.contentInset.top, self.tableView.bounds.size.width, 44.);
    _refreshFooter.hidden = NO;
    [self.tableView insertSubview:_refreshFooter atIndex:0];
}
-(void)addHeaderRefreshing:(void (^)(MURefreshHeaderComponent *))callback{
    MURefreshHeaderComponent *refreshHeader = [[MURefreshHeaderComponent alloc]initWithFrame:CGRectZero callback:callback];
    refreshHeader.frame = CGRectMake(self.tableView.contentOffset.x, -64.+self.tableView.contentOffset.y, self.tableView.bounds.size.width, 64.);
    
    [self.tableView insertSubview:refreshHeader atIndex:0];
}
-(void)addHeaderAutoRefreshing:(void (^)(MURefreshHeaderComponent *))callback{
    MURefreshHeaderComponent *refreshHeader = [[MURefreshHeaderComponent alloc]initWithFrame:CGRectZero callback:callback];
    refreshHeader.frame = CGRectMake(self.tableView.contentOffset.x, -64.+self.tableView.contentOffset.y, self.tableView.bounds.size.width, 64.);
    
    [self.tableView insertSubview:refreshHeader atIndex:0];
    [refreshHeader startRefresh];
}
@end
