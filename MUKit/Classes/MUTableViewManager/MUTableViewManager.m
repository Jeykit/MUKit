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
#import <objc/runtime.h>
#import <objc/message.h>


@interface MUTableViewManager()


@property (nonatomic ,strong)MUAddedPropertyModel *dynamicProperty;
@property(nonatomic, strong)UITableViewCell *tableViewCell;
@property(nonatomic, strong)NSMutableArray *innerModelArray;

@property(nonatomic, strong)MURefreshFooterStyleComponent *refreshFooter;
@property(nonatomic, strong)MURefreshHeaderStyleComponent *refreshHeader;

@property(nonatomic, assign)CGPoint contentOffset;
@property(nonatomic, strong)MUTipsView *tipView;
@property(nonatomic, strong)UIImageView *backgroundView;
@property(nonatomic, assign)CGRect originalRect;
@property(nonatomic, assign)CGFloat scaleCenterX;

@property (nonatomic,weak) UIViewController *weakViewController;

@end


static NSString * const sectionFooterHeight = @"sectionFooterHeight";
static NSString * const sectionHeaderHeight = @"sectionHeaderHeight";
static NSString * const sectionFooterTitle  = @"sectionFooterTitle";
static NSString * const sectionHeaderTitle  = @"sectionHeaderTitle";

static NSString * const selectedState = @"selectedState";
static NSString * const rowHeight = @"rowHeight";
@implementation MUTableViewManager{
    
    NSString *_cellModelName;
    NSString *_sectionModelName;
    NSString *_cellReuseIdentifier;
    __weak UITableView *_tableView;
    NSString *_keyPath;
    
    CGFloat  _rowHeight;//defalut is 44 point.
    CGFloat  _sectionHeaderHeight;//defalut is 44 point.
    CGFloat  _sectionFooterHeight;//defalut is 0.001 point.
    
    BOOL _section;
    BOOL _allModel;
    BOOL _upToRefresh;
    BOOL _isRefreshingWithFooter;
}

-(void)setBackgroundViewImage:(UIImage *)backgroundViewImage{
    _backgroundViewImage = backgroundViewImage;
    if (backgroundViewImage) {
        self.backgroundView.image = backgroundViewImage;
        CGRect rect = self.backgroundView.frame;
        rect.size.height = CGRectGetHeight(_tableView.frame);
        self.backgroundView.frame = rect;
    }
}

- (CGFloat)navigationBarAndStatusBarHeight:(UIViewController *)controller {
    return CGRectGetHeight(controller.navigationController.navigationBar.bounds) +
    CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}
-(UIViewController*)getViewControllerFromCurrentView:(UIView *)view{
    
    UIResponder *nextResponder = view.nextResponder;
    while (nextResponder != nil) {
        
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            self.weakViewController = nil;
            break;
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            //            self.weakViewController = (UIViewController*)nextResponder;
            return (UIViewController *)nextResponder;
            break;
            
        }
        nextResponder = nextResponder.nextResponder;
    }
    return nil;
}
-(UIImageView *)backgroundView{
    if (!_backgroundView) {
        UIViewController *tempController = nil;
        if (!self.weakViewController) {
            self.weakViewController = [self getViewControllerFromCurrentView:_tableView];
        }
        if (tempController.navigationController) {
            _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -[self navigationBarAndStatusBarHeight:tempController], CGRectGetWidth(_tableView.frame),0)];
        }else{
            _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(_tableView.frame),0)];
        }
        UIView *view = [UIView new];
        [view addSubview:_backgroundView];
        _tableView.backgroundView =  view;
    }
    return _backgroundView;
}
-(void)setScaleView:(UIView *)scaleView{
    _scaleView = scaleView;
    _originalRect = scaleView.frame;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _originalRect.size.width = screenWidth;
    scaleView.frame = _originalRect;
    _scaleCenterX = screenWidth/2.;
    
}
- (MUTipsView *)tipsView{
    if (!_tipView) {
        UIViewController *tempController = nil;
        if (!self.weakViewController) {
            self.weakViewController = [self getViewControllerFromCurrentView:_tableView];
        }
        if (tempController.navigationController) {
            
            if (self.retainTableView.tableHeaderView) {
                _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.retainTableView.tableHeaderView.frame), CGRectGetWidth(self.retainTableView.frame), CGRectGetHeight(self.retainTableView.bounds) - 64. - CGRectGetHeight(self.retainTableView.tableHeaderView.frame))];
            }else{
                
                _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.retainTableView.frame), CGRectGetHeight(self.retainTableView.bounds) - 64.)];
            }
        }else{
            if (self.retainTableView.tableHeaderView) {
                _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.retainTableView.tableHeaderView.frame), CGRectGetWidth(self.retainTableView.frame), CGRectGetHeight(self.retainTableView.bounds) - CGRectGetHeight(self.retainTableView.tableHeaderView.frame))];
            }else{
                _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), CGRectGetHeight(_tableView.bounds))];
            }
            
        }
        _tipView.userInteractionEnabled = NO;
        [_tableView addSubview:_tipView];
    }
    return _tipView;
}
-(instancetype)initWithTableView:(UITableView *)tableView{//只需要刷新
    if (self = [super init]) {
        _tableView           = tableView;
        _retainTableView     = _tableView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate   = self;
    }
    return self;
}
-(instancetype)initWithTableView:(UITableView *)tableView registerCellNib:(NSString *)nibName subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        [self initalization:tableView keyPath:keyPath];
        _tableViewCell       = [[[NSBundle bundleForClass:NSClassFromString(nibName)] loadNibNamed:NSStringFromClass(NSClassFromString(nibName)) owner:nil options:nil] lastObject];
        [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:_cellReuseIdentifier];
    }
    return self;
}

-(instancetype)initWithTableView:(UITableView *)tableView registerCellClass:(NSString *)className subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        [self initalization:tableView keyPath:keyPath];
        _tableViewCell       = [[NSClassFromString(className) alloc]init];
        [_tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:_cellReuseIdentifier];
    }
    return self;
}
-(void)initalization:(UITableView *)tableView keyPath:(NSString *)keyPath{
    _tableView           = tableView;
    _retainTableView     = _tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.estimatedRowHeight = 88.;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    
    _tableView.delegate  = self;
    _keyPath             = keyPath;
    _rowHeight           = 44.;
    _sectionHeaderHeight = 0.0001;
    _sectionFooterHeight = 0.0001;
    _dynamicProperty = [[MUAddedPropertyModel alloc]init];
    _contentOffset      = CGPointZero;
    _cellReuseIdentifier = @"MUCellReuseIdentifier";
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"
-(void)configuredWithArray:(NSArray *)array name:(NSString *)name{
    
    id object = array[0];
    if (!name || [_cellModelName isEqualToString:NSStringFromClass([object class])]) {
        _cellModelName = NSStringFromClass([object class]);
        [self configureSigleSection:_dynamicProperty object:object];
        return;
    }
    
    if (name && _sectionModelName) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *subArray = [obj valueForKey:name];
        if (subArray) {
            _section = YES;
        }
        if (subArray.count > 0) {
            
            id model = subArray[0];
            NSString *cellName = NSStringFromClass([model class]);
            if (![cellName isEqualToString:_cellModelName]) {
                [weakSelf configuredRowWithDynamicModel:weakSelf.dynamicProperty object:model];
            }
            *stop = YES;
        }
        if (_section) {
            NSString *sectionName = NSStringFromClass([object class]);
            if (![sectionName isEqualToString:_sectionModelName]) {
                [weakSelf configuredSectionWithDynamicModel:weakSelf.dynamicProperty object:object];
            }
        }
        
    }];
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
}

- (NSArray *)dataArray{
    return [self.innerModelArray copy];
}
- (void)clearData{
    [_tableView addSubview:self.tipsView];
    [_tableView sendSubviewToBack:self.tipsView];
    self.innerModelArray = [NSMutableArray array];
    _modelArray = nil;
    [_tableView reloadData];
}
-(void)setModelAllArray:(NSArray *)modelAllArray{
    _modelAllArray = modelAllArray;
    if (modelAllArray.count > 0) {
        _allModel = YES;
    }else{
        _allModel = NO;
    }
    [self insertModelArray:modelAllArray];
    
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
    
    
    if (!_allModel) {
        if (!_isRefreshingWithFooter) {//下拉刷新
            _tableView.delegate   = self;
            _tableView.dataSource = self;
            self.innerModelArray     = [array mutableCopy];
            
        }
        else{//上拉刷新
            [self.innerModelArray addObjectsFromArray:array];
            _isRefreshingWithFooter = NO;
            
        }
        
    }else{
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        self.innerModelArray     = [array mutableCopy];
    }
    
    if (!array || array.count == 0) {
        self.innerModelArray = [NSMutableArray array];
        if (!self.tipView.superview) {//无数据时显示
            [_tableView addSubview:self.tipsView];
            [_tableView sendSubviewToBack:self.tipsView];
        }
    }else{
        if (self.tipView.superview) {//有数据时隐藏
            [self.tipView removeFromSuperview];
        }
    }
    [_tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        if (self.reloadDataFinished) {
            [_tableView layoutIfNeeded];//解决reloadData之后，contentSize获取不正确bug
            self.reloadDataFinished(YES);
        }
    });
}

#pragma mark - dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_section) {
        return self.innerModelArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_section) {
        
        id model = self.innerModelArray[section];
        NSArray *subArray = [model valueForKey:_keyPath];
        return subArray.count;
    }
    return self.innerModelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id object = nil;
    if (_section) {//拆解模型
        if (self.innerModelArray.count > indexPath.section) {
            object  = self.innerModelArray[indexPath.section];
        }
        NSArray *subArray = [object valueForKey:_keyPath];
        if (subArray.count > indexPath.row) {
            object  = subArray[indexPath.row];
        }
    }else{
        if (self.innerModelArray.count>indexPath.row) {
            object  = self.innerModelArray[indexPath.row];
        }
    }
    CGFloat height  = _rowHeight;
    UITableViewCell *resultCell = nil;
    if (self.renderBlock) {
        resultCell = self.renderBlock(resultCell,indexPath,object,&height);
        
        if (!resultCell) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
            resultCell = self.renderBlock(cell,indexPath,object,&height);
        }
    }
    resultCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return resultCell;
}

#pragma -mark dynamic row height
// See: https://github.com/caoimghgin/TableViewCellWithAutoLayout/issues/6
// See: FDTemplateLayoutCell
-(CGFloat)dynamicRowHeight:(UITableViewCell *)cell tableView:(UITableView *)tableView{
    
    
    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);
    CGRect cellBounds = cell.bounds;
    cellBounds.size.width = contentViewWidth;
    cell.bounds = cellBounds;
    
    CGFloat accessroyTypeWidth = 0.0;
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
            accessroyTypeWidth = CGRectGetWidth(view.frame);
            break;
        }
    }
    
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
    //    static BOOL isSystemVersionEqualOrGreaterThen10_2 = NO;
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
    //    });
    
    NSArray<NSLayoutConstraint *> *edgeConstraints;
    //    if (isSystemVersionEqualOrGreaterThen10_2) {
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
    //        if (isSystemVersionEqualOrGreaterThen10_2) {
    [cell removeConstraints:edgeConstraints];
    //        }
    //    }
    
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
    if (_section) {//拆解模型
        if (self.innerModelArray.count > indexPath.section) {
            object  = self.innerModelArray[indexPath.section];
        }
        NSArray *subArray = [object valueForKey:_keyPath];
        if (subArray.count > indexPath.row) {
            object  = subArray[indexPath.row];
        }
    }else{
        if (self.innerModelArray.count>indexPath.row) {
            object  = self.innerModelArray[indexPath.row];
        }
    }
    BOOL isEqual = NO;
    if (self.indexPathArray.count > 0) {
        for (NSIndexPath *ignoreIndexPath in self.indexPathArray) {
           isEqual = ([ignoreIndexPath compare:indexPath] == NSOrderedSame) ? YES : NO;
            if (isEqual) {
                break ;
            }
        }
    }
    CGFloat height  = [self.dynamicProperty getValueFromObject:object name:rowHeight];
    if (height > 0 && !isEqual) {
        return height;
    }
    height = _rowHeight;
    CGFloat tempHeight = height;
    UITableViewCell *cell = nil;
    if (self.renderBlock) {
        cell = self.renderBlock(_tableViewCell,indexPath,object,&height);//取回真实的cell，实现cell的动态行高
    }
    if (tempHeight == height) {
        if (self.cellReuseIdentifier) {
            height = [self dynamicRowHeight:cell tableView:tableView];//计算cell的动态行高
        }
    }
    if (isEqual) {
        [self.dynamicProperty setValueToObject:object name:rowHeight value:0];
        
    }else{
         [self.dynamicProperty setValueToObject:object name:rowHeight value:height];
    }
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headerView      = [UIView new];
    if (!self.headerViewBlock) {
        return headerView;
    }
    NSString * title = @"";
    id model = nil;
    if (self.innerModelArray.count > section) {
        model = self.innerModelArray[section];
    }
    CGFloat height = _sectionHeaderHeight;
    if (self.headerViewBlock) {
        
        headerView = self.headerViewBlock(tableView,section,&title,model,&height);
    }
    tableView.sectionHeaderHeight = 0;
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{//刷新数据时调用
    
    
    
    CGFloat height = _sectionHeaderHeight;
    if (!self.headerViewBlock) {
        return height;
    }
    id model = nil;
    if (self.innerModelArray.count > section) {
        model = self.innerModelArray[section];
    }
    NSString * title = @"";
    height  = [self.dynamicProperty getValueFromObject:model name:sectionHeaderHeight];
    if (height >0) {
        return height;
    }
    height = _sectionHeaderHeight;
    if (self.headerViewBlock) {
        
        self.headerViewBlock(nil, section,&title, model, &height);
        //        NSLog(@"section ======== %ld",section);
    }
    if (title.length > 0) {
        height = 44.;
        [self.dynamicProperty setObjectToObject:model name:sectionHeaderTitle value:title];
    }
    [self.dynamicProperty setValueToObject:model name:sectionHeaderHeight value:height];
    
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *footerView      = [UIView new];
    if (!self.footerViewBlock) {
        return footerView;
    }
    id model = nil;
    if (self.innerModelArray.count > section) {
        model = self.innerModelArray[section];
    }
    NSString * title = @"";
    CGFloat height = _sectionFooterHeight;
    if (self.footerViewBlock) {
        
        footerView = self.footerViewBlock(tableView, section,&title, model, &height);
    }
    return footerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{//刷新数据时调用
    
    CGFloat height = _sectionFooterHeight;
    if (!self.footerViewBlock) {
        return height;
    }
    id model = nil;
    if (self.innerModelArray.count > section) {
        model = self.innerModelArray[section];
    }
    height  = [self.dynamicProperty getValueFromObject:model name:sectionFooterHeight];
    if (height >0) {
        return height;
    }
    NSString * title = @"";
    height = _sectionFooterHeight;
    if (self.footerViewBlock) {
        
        self.footerViewBlock(nil, section, &title,model, &height);
    }
    if (title.length > 0) {
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
    id model = nil;
    if (self.innerModelArray.count > section) {
        model = self.innerModelArray[section];
    }
    title = (NSString *)[self.dynamicProperty getObjectFromObject:model name:sectionHeaderTitle];
    if (title.length > 0) {
        //        self.sectionHeaderHeight = 44.;
        return title;
    }
    CGFloat height = _sectionHeaderHeight;
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
    id model = nil;
    if (self.innerModelArray.count > section) {
        model = self.innerModelArray[section];
    }
    title = (NSString *)[self.dynamicProperty getObjectFromObject:model name:sectionFooterTitle];
    if (title.length > 0) {
        return title;
    }
    CGFloat height = _sectionFooterHeight;
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
        if (_section) {//拆解模型
            if (self.innerModelArray.count > indexPath.section) {
                object  = self.innerModelArray[indexPath.section];
            }
            NSArray *subArray = [object valueForKey:_keyPath];
            if (subArray.count > indexPath.row) {
                object  = subArray[indexPath.row];
            }
        }else{
            if (self.innerModelArray.count>indexPath.row) {
                object  = self.innerModelArray[indexPath.row];
            }
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

#pragma mark - 处理左滑按钮
/**
 *  只要实现了这个方法，左滑出现Delete按钮的功能就有了
 *  点击了“左滑出现的Delete按钮”会调用这个方法
 */
//IOS9前自定义左滑多个按钮需实现此方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = nil;
    if (_section) {//拆解模型
        if (self.innerModelArray.count > indexPath.section) {
            object  = self.innerModelArray[indexPath.section];
        }
        NSArray *subArray = [object valueForKey:_keyPath];
        if (subArray.count > indexPath.row) {
            object  = subArray[indexPath.row];
        }
    }else{
        if (self.innerModelArray.count>indexPath.row) {
            object  = self.innerModelArray[indexPath.row];
        }
    }
    if (self.deleteConfirmationButtonBlock) {
        self.deleteConfirmationButtonBlock(tableView,indexPath,object);
    }
    
}
//
///**
// *  修改Delete按钮文字为“删除”
// */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = @"Delete";
    if (self.titleForDeleteConfirmationButtonBlock) {
        
        self.titleForDeleteConfirmationButtonBlock(tableView, indexPath, &title);
    }
    return title;
}

/**
 *  自定义左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = nil;
    if (_section) {//拆解模型
        if (self.innerModelArray.count > indexPath.section) {
            object  = self.innerModelArray[indexPath.section];
        }
        NSArray *subArray = [object valueForKey:_keyPath];
        if (subArray.count > indexPath.row) {
            object  = subArray[indexPath.row];
        }
    }else{
        if (self.innerModelArray.count>indexPath.row) {
            object  = self.innerModelArray[indexPath.row];
        }
    }
    NSArray *array = @[];
    if (self.editActionsForRowAtIndexPathBlock) {
        
        array = self.editActionsForRowAtIndexPathBlock(tableView,indexPath,object);
    }
    
    if (array.count == 0 && (self.titleForDeleteConfirmationButtonBlock || self.deleteConfirmationButtonBlock)) {
        array = nil;
    }
    return array;
}


/**
 处理UIScrollView滚动
 */
#pragma mark - scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scaleView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if(offsetY <= 0)
        {
            self.scaleView.translatesAutoresizingMaskIntoConstraints = YES;
            CGFloat totalOffset = CGRectGetHeight(_originalRect) + fabs(offsetY);
            CGFloat f = totalOffset / CGRectGetHeight(_originalRect);
            CGRect rect = self.scaleView.frame;
            rect.origin.y = offsetY;
            rect.size     = CGSizeMake(CGRectGetWidth(_originalRect) * f, CGRectGetHeight(_originalRect) - offsetY);
            self.scaleView.frame = rect;
            CGPoint point = self.scaleView.center;
            point.x = self.scaleCenterX;
            self.scaleView.center = point;
            if (@available(iOS 11.0, *)) {
            }else{
                self.scaleView.translatesAutoresizingMaskIntoConstraints = NO;
            }
            
        }
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollViewWillBeginDragging) {
        self.scrollViewWillBeginDragging(scrollView);
    }
}
/**
 集成UITableView上下拉刷新
 */
#pragma mark -refreshing
static NSString * const MUHeadKeyPath = @"MUHeadKeyPath";
static NSString * const MUFootKeyPath = @"MUHeadKeyPath";
-(void)addFooterRefreshing:(void (^)(MURefreshComponent *))callback{
    if (!_refreshFooter) {
        _refreshFooter = [MURefreshFooterStyleComponent new];
        _refreshFooterComponent = _refreshFooter;
    }
    _refreshFooter.refreshHandler = ^(MURefreshComponent *component) {
        _isRefreshingWithFooter = YES;
        if (callback) {
            callback(component);
        }
    };
    //    _refreshFooter.refreshHandler = callback;
    _refreshFooter.backgroundColor = [UIColor clearColor];
    if (!_refreshFooter.superview) {
        [_tableView willChangeValueForKey:MUFootKeyPath];
        [_tableView addSubview:_refreshFooter];
        [_tableView didChangeValueForKey:MUFootKeyPath];
    }
}
-(void)addHeaderRefreshing:(void (^)(MURefreshComponent *))callback{
    if (!_refreshHeader) {
        _refreshHeader = [MURefreshHeaderStyleComponent new];
        _refreshHeaderComponent = _refreshHeader;
    }
    _refreshHeader.refreshHandler = ^(MURefreshComponent *component) {
        _isRefreshingWithFooter = NO;
        if (callback) {
            callback(component);
        }
    };
    _refreshHeader.backgroundColor = [UIColor clearColor];
    if (!_refreshHeader.superview) {
        [_tableView willChangeValueForKey:MUHeadKeyPath];
        [_tableView addSubview:_refreshHeader];
        [_tableView didChangeValueForKey:MUHeadKeyPath];
        [_refreshHeader beginRefreshing];
    }
}
-(MURefreshHeaderStyleComponent *)refreshHeaderComponent{
    if (!_refreshHeader) {
        _refreshHeader = [MURefreshHeaderStyleComponent new];
    }
    return _refreshHeader;
}
-(MURefreshFooterStyleComponent *)refreshFooterComponent{
    if (!_refreshFooter) {
        _refreshFooter = [MURefreshFooterStyleComponent new];
    }
    return _refreshFooter;
}
#pragma clang diagnostic pop
@end
