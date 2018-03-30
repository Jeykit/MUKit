//
//  MUCollectionViewManager.m
//  Pods
//
//  Created by Jekity on 2017/8/21.
//
//

#import "MUCollectionViewManager.h"
#import "MUAddedPropertyModel.h"
#import "MUWaterfallFlowLayout.h"
#import "MUDefalutTitleCollectionReusableView.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIView+MUNormal.h"
#import "UIView+MUSignal.h"
#import "MUNavigation.h"

@interface MUCollectionViewManager()
@property (nonatomic ,weak)UICollectionView *innerCollectionView;
@property (nonatomic ,copy)NSString *keyPath;
@property (nonatomic ,assign,getter=isSection)BOOL section;
@property (nonatomic ,strong)MUAddedPropertyModel *dynamicProperty;
@property (nonatomic ,copy)NSString *cellModelName;
@property (nonatomic ,copy)NSString *sectionModelName;
@property (nonatomic, copy)NSString *cellReuseIdentifier;
@property (nonatomic, strong)UICollectionViewCell     *collectionViewCell;
@property (nonatomic, assign)UIEdgeInsets             sectionInsets;
@property (nonatomic, strong)UICollectionReusableView *headerView;
@property (nonatomic, strong)UICollectionReusableView *footerView;

@property (nonatomic, copy)NSString *headerReuseIdentifier;
@property (nonatomic, copy)NSString *footerReuseIdentifier;
@property (nonatomic, assign)CGFloat itemWidth;

@property (nonatomic, weak)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign)NSUInteger                   itemCount;
@property(nonatomic, strong)MURefreshFooterComponent *refreshFooter;

@property(nonatomic, assign)BOOL regisetrHeaderTitle;
@property(nonatomic, assign)BOOL regisetrFooterTitle;

@property(nonatomic, strong)NSMutableArray *innerModelArray;

@property(nonatomic, strong)MUTipsView *tipView;
@property(nonatomic, strong)UIImageView *backgroundView;

@property(nonatomic, assign)CGRect originalRect;
@property(nonatomic, assign)CGFloat scaleCenterX;
@end


static NSString * const sectionFooterHeight   = @"sectionFooterHeight";
static NSString * const sectionHeaderHeight   = @"sectionHeaderHeight";
static NSString * const sectionFooterTitle    = @"sectionFooterTitle";
static NSString * const sectionHeaderTitle    = @"sectionHeaderTitle";
static NSString * const sectionInsets         = @"selectedInsets";
static NSString * const itemHeight            = @"itemHeight";
@implementation MUCollectionViewManager

-(UICollectionView *)collectionView{
    return _innerCollectionView;
}
-(void)setBackgroundViewImage:(UIImage *)backgroundViewImage{
    _backgroundViewImage = backgroundViewImage;
    if (backgroundViewImage) {
        self.backgroundView.image = backgroundViewImage;
        self.backgroundView.height_Mu = CGRectGetHeight(self.innerCollectionView.frame);
    }
}
//-(void)setBackgroundViewColor:(UIColor *)backgroundViewColor{
//    _backgroundViewColor = backgroundViewColor;
//    if (_backgroundViewColor) {
//        self.backgroundView.backgroundColor = backgroundViewColor;
//    }
//}
-(UIImageView *)backgroundView{
    if (!_backgroundView) {
        UIViewController *tempController = self.innerCollectionView.viewController;
        if (tempController.navigationController) {
            _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -tempController.navigationBarAndStatusBarHeight, CGRectGetWidth(self.innerCollectionView.frame),0)];
        }else{
            _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.innerCollectionView.frame),0)];
        }
        UIView *view = [UIView new];
        [view addSubview:_backgroundView];
        self.innerCollectionView.backgroundView =  view;
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
-(instancetype)initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout registerNib:(NSString *)nibName itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath{
    
    if (self = [super init]) {
        _innerCollectionView                      = collectionView;
        _innerCollectionView.collectionViewLayout = flowLayout;
        if ([flowLayout isKindOfClass:[MUWaterfallFlowLayout class]]) {
            MUWaterfallFlowLayout *water = (MUWaterfallFlowLayout*)flowLayout;
            water.itemCount              = count;
            water.delegate               = self;
        
        }
        UIViewController *tempController = _innerCollectionView.viewController;
        
        if (tempController.navigationController) {
            _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_innerCollectionView.frame), CGRectGetHeight(_innerCollectionView.bounds) - 64.)];
        }else{
            _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_innerCollectionView.frame), CGRectGetHeight(_innerCollectionView.bounds))];
        }
         [_innerCollectionView addSubview:_tipView];
        _tipsView = _tipView;
        _flowLayout                          = flowLayout;
        _keyPath                             = keyPath;
        _itemSize                            = CGSizeZero;
        _sectionInsets                       = UIEdgeInsetsMake(0, 0, 0, 0);
        _dynamicProperty                     = [[MUAddedPropertyModel alloc]init];
        _sectionHeaderHeight                 = 0;
        _sectionFooterHeight                 = 0;
        _itemWidth                           = 0;
        _itemCount                           = count;
        _regisetrHeaderTitle                 = NO;
        _regisetrFooterTitle                 = NO;
        _cellReuseIdentifier                 = @"MUCellReuseIdentifier";
        _collectionViewCell       = [[[NSBundle bundleForClass:NSClassFromString(nibName)] loadNibNamed:NSStringFromClass(NSClassFromString(nibName)) owner:nil options:nil] lastObject];
        [_innerCollectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:_cellReuseIdentifier];
    }
    return self;
}

-(instancetype)initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout registerCellClass:(NSString *)className itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        _innerCollectionView                      = collectionView;
        _innerCollectionView.collectionViewLayout = flowLayout;
        _flowLayout                          = flowLayout;
        if ([flowLayout isKindOfClass:[MUWaterfallFlowLayout class]]) {
            MUWaterfallFlowLayout *water = (MUWaterfallFlowLayout*)flowLayout;
            water.itemCount              = count;
            water.delegate               = self;
        }
        UIViewController *tempController = _innerCollectionView.viewController;
        
        if (tempController.navigationController) {
            _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_innerCollectionView.frame), CGRectGetHeight(_innerCollectionView.bounds) - 64.)];
        }else{
            _tipView             = [[MUTipsView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_innerCollectionView.frame), CGRectGetHeight(_innerCollectionView.bounds))];
        }
        [_innerCollectionView addSubview:_tipView];
        _tipsView = _tipView;
        _keyPath                             = keyPath;
        _itemSize                            = CGSizeZero;
        _sectionInsets                       = UIEdgeInsetsMake(0, 0, 0, 0);
        _dynamicProperty                     = [[MUAddedPropertyModel alloc]init];
        _sectionHeaderHeight                 = 0;
        _sectionFooterHeight                 = 0;
        _itemWidth                           = 0;
        _itemCount                           = count;
        _regisetrHeaderTitle                 = NO;
        _regisetrFooterTitle                 = NO;
        _cellReuseIdentifier                 = @"MUCellReuseIdentifier";
        _collectionViewCell  = [[NSClassFromString(className) alloc]init];
        [_innerCollectionView registerClass:NSClassFromString(className) forCellWithReuseIdentifier:_cellReuseIdentifier];
    }
    return self;
}
#pragma  -mark header
-(void)registerHeaderViewClass:(NSString *)className withReuseIdentifier:(NSString *)identifier{
    
    _headerReuseIdentifier = identifier;
    _headerView = [[NSClassFromString(className) alloc]init];
     [_innerCollectionView registerClass:NSClassFromString(className) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

-(void)registerHeaderViewNib:(NSString *)name withReuseIdentifier:(NSString *)identifier{
    _headerReuseIdentifier = identifier;
    _headerView       = [[[NSBundle bundleForClass:NSClassFromString(name)] loadNibNamed:NSStringFromClass(NSClassFromString(name)) owner:nil options:nil] lastObject];
    [_innerCollectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
}

#pragma -mark footer
-(void)registerFooterViewClass:(NSString *)className withReuseIdentifier:(NSString *)identifier{
    _footerReuseIdentifier = identifier;
    _footerView = [[NSClassFromString(className) alloc]init];
    [_innerCollectionView registerClass:NSClassFromString(className) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
}
-(void)registerFooterViewNib:(NSString *)name withReuseIdentifier:(NSString *)identifier{
    _footerReuseIdentifier = identifier;
    _footerView       = [[[NSBundle bundleForClass:NSClassFromString(name)] loadNibNamed:NSStringFromClass(NSClassFromString(name)) owner:nil options:nil] lastObject];
    [_innerCollectionView registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
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
    [model addProperty:object propertyName:sectionInsets type:MUAddedPropertyTypeRetain];

}
-(void)configuredRowWithDynamicModel:(MUAddedPropertyModel *)model object:(id)object{
//    [model addProperty:object propertyName:itemSize type:MUAddedPropertyTypeRetain];
    [model addProperty:object propertyName:itemHeight type:MUAddedPropertyTypeAssign];
   
}
-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    if (modelArray.count > 0) {
        [self.tipsView removeFromSuperview];
    }else{
        [self.collectionView addSubview:self.tipsView];
    }
    [self insertModelArray:modelArray];
}
-(void)setInnerModelArray:(NSMutableArray *)innerModelArray{
    _innerModelArray = innerModelArray;
    [self configuredWithArray:innerModelArray name:_keyPath];
    
}
-(void)insertModelArray:(NSArray *)array{//数据源处理
    
    if (!self.refreshFooter.refresh) {//下拉刷新
        
        self.innerModelArray      = [array mutableCopy];
        self.innerCollectionView.delegate   = self;
        self.innerCollectionView.dataSource = self;
    }
    else{//上拉刷新
        [self.innerModelArray addObjectsFromArray:array];
       
    }
    [self.innerCollectionView reloadData];
    self.refreshFooter.refresh  = NO;
}
#pragma mark-dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.isSection) {
        return self.innerModelArray.count;
    }
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isSection) {
        
        id model = self.innerModelArray[section];
        NSArray *subArray = [model valueForKey:_keyPath];
        return subArray.count;
    }
    return self.innerModelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id object = nil;
    
    if (self.isSection) {
        object  = self.innerModelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.innerModelArray[indexPath.row];
    }
    CGFloat height  = 0;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UICollectionViewCell *resultCell = nil;
    if (self.renderBlock) {
        resultCell = self.renderBlock(resultCell,indexPath,object,&height,&insets);//检测是否有自定义cell
        
        if (!resultCell) {//没有则注册一个
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
            resultCell = self.renderBlock(cell,indexPath,object,&height,&insets);
        }
    }
    
    return resultCell;
}

#pragma mark -UICollectionViewDelegateFlowLayout(UICollectionViewDelegate)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id object              = nil;
    id sectionModel        = nil;
    UIEdgeInsets oldInsets = UIEdgeInsetsZero;
    if (self.isSection) {
        object  = self.innerModelArray[indexPath.section];
        sectionModel = object;
        NSValue *value = (NSValue *)[self.dynamicProperty getObjectFromObject:object name:sectionInsets];
        oldInsets = [value UIEdgeInsetsValue];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.innerModelArray[indexPath.row];
        oldInsets = self.sectionInsets;
    }
    CGFloat height  = [self.dynamicProperty getValueFromObject:object name:itemHeight];
    
    if (height > 0) {
//        NSLog(@"%@--------itemSize=%f",indexPath,height);
        return CGSizeMake(_itemWidth, height);
    }
    
    height = 0;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    UICollectionViewCell *cell = nil;
    if (self.renderBlock) {
        cell = self.renderBlock(_collectionViewCell,indexPath,object,&height,&insets);//取回真实的cell，实现cell的动态行高
       
    }
    if (self.isSection) {//分组
        if (!UIEdgeInsetsEqualToEdgeInsets(insets, oldInsets)) {
            [self.dynamicProperty setObjectToObject:sectionModel name:sectionInsets value:[NSValue valueWithUIEdgeInsets:insets]];
        }
        
    }else{
        if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
            
            self.sectionInsets = insets;
        }
    }
   
    if (self.cellReuseIdentifier&&height==0) {
        height = [self dynamicItemSize:cell itemWidth:_itemWidth];//计算cell的动态行高
    }
    if (!_itemWidth) {
        _itemWidth = (CGRectGetWidth(collectionView.frame) - insets.left - insets.right - _flowLayout.minimumInteritemSpacing * (_itemCount - 1))/_itemCount;//计算item宽度
    }
    [self.dynamicProperty setValueToObject:object name:itemHeight value:height];
    return CGSizeMake(_itemWidth, height);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    id object = nil;
    if (self.isSection) {
        object  = self.innerModelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.innerModelArray[indexPath.row];
    }
   
    CGFloat height  = 0;
    UICollectionReusableView *resultCell = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (self.headerViewBlock) {
            NSString *title = @"";
            resultCell = self.headerViewBlock(resultCell,&title,indexPath,object,&height);//检测是否有自定义cell
            if (!resultCell) {//没有自定义的cell
                
                if (title.length > 1) {//有标题
                    if (!self.regisetrHeaderTitle) {
                        [collectionView registerClass:[MUDefalutTitleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderTitle];
                        self.regisetrHeaderTitle = YES;
                    }
                     MUDefalutTitleCollectionReusableView *   titleCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderTitle forIndexPath:indexPath];
                    titleCell.title = title;
//                    titleCell.image = [UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"];
                    return titleCell;
                }
                UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:_headerReuseIdentifier forIndexPath:indexPath];
                resultCell = self.headerViewBlock(view,&title,indexPath,object,&height);
            }
        }

    }else if (kind == UICollectionElementKindSectionFooter){
        if (self.footerViewBlock) {
            NSString *title = @"";
            resultCell = self.footerViewBlock(resultCell,&title,indexPath,object,&height);//检测是否有自定义cell
            if (!resultCell) {
                if (title.length > 0) {//有标题
                    if (!self.regisetrFooterTitle) {
                        [collectionView registerClass:[MUDefalutTitleCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterTitle];
                        self.regisetrFooterTitle = YES;
                    }
                    MUDefalutTitleCollectionReusableView *   titleCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:sectionFooterTitle forIndexPath:indexPath];
                    titleCell.title = title;
//                    titleCell.image = [UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"];
                    return titleCell;
                }

                UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:_footerReuseIdentifier forIndexPath:indexPath];
                resultCell = self.footerViewBlock(view,&title,indexPath,object,&height);
            }
        }
    }
    return resultCell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (!self.headerViewBlock) {
        return CGSizeMake(0, height);
    }
    id model = self.innerModelArray[section];
    height  = [self.dynamicProperty getValueFromObject:model name:sectionHeaderHeight];
    if (height > 0) {
        return CGSizeMake(CGRectGetWidth(_innerCollectionView.frame), height);
    }
    height = self.sectionHeaderHeight;
    NSString *title = @"";
    if (self.headerViewBlock) {
        self.headerViewBlock(nil,&title,[NSIndexPath indexPathForRow:0 inSection:section] ,nil, &height);
        if (title.length > 0) {
            
            return CGSizeMake(CGRectGetWidth(_innerCollectionView.frame), 44.);
        }
    }
    [self.dynamicProperty setValueToObject:model name:sectionHeaderHeight value:height];
     return CGSizeMake(CGRectGetWidth(_innerCollectionView.frame), height);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGFloat height = 0;
    if (!self.footerViewBlock) {
        return CGSizeMake(0, height);
    }
    id model = self.innerModelArray[section];
    height  = [self.dynamicProperty getValueFromObject:model name:sectionFooterHeight];
    if (height > 0) {
        return CGSizeMake(CGRectGetWidth(_innerCollectionView.frame), height);
    }
    NSString *title = @"";
    
    height = self.sectionFooterHeight;
    if (self.footerViewBlock) {
        self.footerViewBlock(nil,&title, [NSIndexPath indexPathForRow:0 inSection:section], nil, &height);
        if (title.length > 0) {
            
            return CGSizeMake(CGRectGetWidth(_innerCollectionView.frame), 44.);
        }
    }
    [self.dynamicProperty setValueToObject:model name:sectionFooterHeight value:height];
    return CGSizeMake(CGRectGetWidth(_innerCollectionView.frame), height);
}

//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
   
    UIEdgeInsets insets = self.sectionInsets;
    if (!self.footerViewBlock) {
        return self.sectionInsets;
    }
    id model = self.innerModelArray[section];
    NSValue *object  = (NSValue *)[self.dynamicProperty getObjectFromObject:model name:sectionInsets];
    insets = [object UIEdgeInsetsValue];
    if (!UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        _sectionInsets = insets;
        _itemWidth = (CGRectGetWidth(collectionView.frame) - insets.left - insets.right - _flowLayout.minimumInteritemSpacing * (_itemCount - 1))/_itemCount;//计算item宽度
        return insets;
    }
    CGFloat height = 0;
    if (self.renderBlock) {
        self.renderBlock(nil, [NSIndexPath indexPathForRow:0 inSection:section], nil, &height, &insets);
    }
    _sectionInsets = insets;
    _itemWidth = (CGRectGetWidth(collectionView.frame) - insets.left - insets.right - _flowLayout.minimumInteritemSpacing * (_itemCount - 1))/_itemCount;//计算item宽度
    [self.dynamicProperty setObjectToObject:model name:sectionInsets value:[NSValue valueWithUIEdgeInsets:insets]];
 
  
    return insets;//分别为上、左、下、右
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedItemBlock) {
        id object = nil;
        if (self.isSection) {
            object  = self.innerModelArray[indexPath.section];
            NSArray *subArray = [object valueForKey:_keyPath];
            object  = subArray[indexPath.row];
        }else{
            object  = self.innerModelArray[indexPath.row];
        }
        
        CGFloat height  = [self.dynamicProperty getValueFromObject:object name:itemHeight];
        CGFloat tempHeight = height;
        self.selectedItemBlock(collectionView, indexPath, object, &height);
        if (height != tempHeight) {
            [self.dynamicProperty setValueToObject:object name:itemHeight value:height];
            //            [self.dynamicProperty setValueToObject:object name:selectedState value:height];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            
        }
        
    }
}
#pragma -mark dynamic row height
-(CGFloat)dynamicItemSize:(UICollectionViewCell *)cell itemWidth:(CGFloat)itemWidth{
    
    CGFloat contentViewWidth = itemWidth;
    cell.bounds = CGRectMake(0.0f, 0.0f, itemWidth, CGRectGetHeight(cell.bounds));
  
    // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
    // of growing horizontally, in a flow-layout manner.
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    
    // [bug fix] after iOS 10.3, Auto Layout engine will add an additional 0 width constraint onto cell's content view, to avoid that, we add constraints to content view's left, right, top and bottom.
    static BOOL isSystemVersionEqualOrGreaterThen10_2 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isSystemVersionEqualOrGreaterThen10_2 = [UIDevice.currentDevice.systemVersion compare:@"10.2" options:NSNumericSearch] != NSOrderedAscending;
    });
    
    CGSize fittingSize = CGSizeZero;
    NSArray<NSLayoutConstraint *> *edgeConstraints;
    if (isSystemVersionEqualOrGreaterThen10_2) {
        // To avoid confilicts, make width constraint softer than required (1000)
        widthFenceConstraint.priority = UILayoutPriorityRequired - 1;
        
        // Build edge constraints
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        edgeConstraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
        [cell addConstraints:edgeConstraints];
        
        
        [cell.contentView addConstraint:widthFenceConstraint];
        
        //            fittingHeight = 44.;
        // Auto layout engine does its math
        fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        // Clean-ups
        [cell.contentView removeConstraint:widthFenceConstraint];
        if (isSystemVersionEqualOrGreaterThen10_2) {
            [cell removeConstraints:edgeConstraints];
        }
    }
    
    if (CGSizeEqualToSize(fittingSize, CGSizeZero)) {
#if DEBUG
        // Warn if using AutoLayout but get zero height.
        if (cell.contentView.constraints.count > 0) {
            if (!objc_getAssociatedObject(self, _cmd)) {
                NSLog(@"[MUCollectionViewManager] Warning once only: Cannot get a proper cell height (now 0) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
                objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
#endif
        // Try '- sizeThatFits:' for frame layout.
        // Note: fitting height should not include separator view.
        fittingSize = [cell sizeThatFits:CGSizeMake(contentViewWidth, 0)];
    }
    
    // Still zero height after all above.
    if (CGSizeEqualToSize(fittingSize, CGSizeZero)) {
        // Use default row height.
        fittingSize = CGSizeMake(44., 44.);
    }
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
//    fittingSize = CGSizeMake(fittingSize.width, fittingSize.height - 1);
    return fittingSize.height;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
  
        if (self.isSection) {
            
            if (self.innerModelArray.count == indexPath.section + 1) {
                id object  = self.innerModelArray[indexPath.section];
                NSArray *subArray = [object valueForKey:_keyPath];
                if (subArray.count == indexPath.row + 1) {
                    [self.refreshFooter startRefresh];
                }
            }
            
        }else{
            if (self.innerModelArray.count == indexPath.row + 1) {
                
                [self.refreshFooter startRefresh];
            }
        }
}
#pragma mark - scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scaleView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if(offsetY <= 0)
        {
            self.scaleView.translatesAutoresizingMaskIntoConstraints = YES;
            CGFloat totalOffset = CGRectGetHeight(_originalRect) + fabs(offsetY);
            CGFloat f = totalOffset / CGRectGetHeight(_originalRect);
            self.scaleView.y_Mu = offsetY;
            self.scaleView.height_Mu =  CGRectGetHeight(_originalRect) - offsetY;
            self.scaleView.width_Mu   = CGRectGetWidth(_originalRect) * f;
            self.scaleView.centerX_Mu = self.scaleCenterX;
            
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (self.scrollViewWillBeginDragging) {
        self.scrollViewWillBeginDragging(scrollView);
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
    _refreshFooter.frame = CGRectMake(self.innerCollectionView.contentOffset.x, self.innerCollectionView.contentSize.height + self.innerCollectionView.contentOffset.y - self.innerCollectionView.contentInset.top, self.innerCollectionView.bounds.size.width, 44.);
    _refreshFooter.hidden = NO;
    [self.innerCollectionView insertSubview:_refreshFooter atIndex:0];
}
-(void)addHeaderRefreshing:(void (^)(MURefreshHeaderComponent *))callback{
    MURefreshHeaderComponent *refreshHeader = [[MURefreshHeaderComponent alloc]initWithFrame:CGRectZero callback:callback];
    refreshHeader.frame = CGRectMake(self.innerCollectionView.contentOffset.x, -64.+self.innerCollectionView.contentOffset.y, self.innerCollectionView.bounds.size.width, 64.);
    
    [self.innerCollectionView insertSubview:refreshHeader atIndex:0];
//    [refreshHeader startRefresh];
}



@end
