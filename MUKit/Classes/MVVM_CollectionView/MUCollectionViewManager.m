//
//  MUCollectionViewManager.m
//  Pods
//
//  Created by Jekity on 2017/8/21.
//
//

#import "MUCollectionViewManager.h"
#import "MUAddedPropertyModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface MUCollectionViewManager()
@property (nonatomic ,weak)UICollectionView *collectionView;
@property (nonatomic ,copy)NSString *keyPath;
@property (nonatomic ,assign,getter=isSection)BOOL section;
@property (nonatomic ,strong)MUAddedPropertyModel *dynamicProperty;
@property (nonatomic ,copy)NSString *cellModelName;
@property (nonatomic ,copy)NSString *sectionModelName;
@property(nonatomic, copy)NSString *cellReuseIdentifier;
@property(nonatomic, strong)UICollectionViewCell *collectionViewCell;
@end


static NSString * const sectionFooterSize = @"sectionFooterSize";
static NSString * const sectionHeaderSize = @"sectionHeaderSize";
static NSString * const sectionFooterTitle  = @"sectionFooterTitle";
static NSString * const sectionHeaderTitle  = @"sectionHeaderTitle";
//static NSString * const selectedState = @"selectedState";
static NSString * const itemSize = @"itemSize";
@implementation MUCollectionViewManager


-(instancetype)initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        _collectionView                      = collectionView;
        _collectionView.collectionViewLayout = flowLayout;
        flowLayout.estimatedItemSize         = CGSizeMake(44., 88.);
        _keyPath                             = keyPath;
        _itemSize                            = CGSizeZero;
        _sectionHeaderSize                   = CGSizeZero;
        _sectionFooterSize                   = CGSizeZero;
        _dynamicProperty                     = [[MUAddedPropertyModel alloc]init];
    }
    return self;
}
-(instancetype)initWithCollectionView:(UICollectionView *)collectionView subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        _collectionView                        = collectionView;
        _keyPath                               = keyPath;
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
        flowLayout.estimatedItemSize           = CGSizeMake(44., 88.);
        _itemSize                              = CGSizeZero;
        _sectionHeaderSize                     = CGSizeZero;
        _sectionFooterSize                     = CGSizeZero;
        _dynamicProperty                       = [[MUAddedPropertyModel alloc]init];
    }
    return self;
}
-(void)registerNib:(NSString *)nibName cellReuseIdentifier:(NSString *)cellReuseIdentifier{
    
    _cellReuseIdentifier = cellReuseIdentifier;
    _collectionViewCell       = [[[NSBundle bundleForClass:NSClassFromString(nibName)] loadNibNamed:NSStringFromClass(NSClassFromString(nibName)) owner:nil options:nil] lastObject];
    [_collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:cellReuseIdentifier];

}
-(void)registerCellClass:(NSString *)className cellReuseIdentifier:(NSString *)cellReuseIdentifier{
    _cellReuseIdentifier = cellReuseIdentifier;
    _collectionViewCell  = [[NSClassFromString(className) alloc]init];
    [_collectionView registerClass:NSClassFromString(className) forCellWithReuseIdentifier:cellReuseIdentifier];
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
    [model addProperty:object propertyName:sectionHeaderSize type:MUAddedPropertyTypeRetain];
    [model addProperty:object propertyName:sectionFooterSize type:MUAddedPropertyTypeRetain];
//    [model addProperty:object propertyName:sectionHeaderTitle type:MUAddedPropertyTypeRetain];
//    [model addProperty:object propertyName:sectionFooterTitle type:MUAddedPropertyTypeRetain];
}
-(void)configuredRowWithDynamicModel:(MUAddedPropertyModel *)model object:(id)object{
    [model addProperty:object propertyName:itemSize type:MUAddedPropertyTypeRetain];
    //    [model addProperty:object propertyName:selectedState type:MUAddedPropertyTypeAssign];
}
-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    [self configuredWithArray:modelArray name:_keyPath];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
}
#pragma mark-dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.isSection) {
        return self.modelArray.count;
    }
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isSection) {
        
        id model = self.modelArray[section];
        NSArray *subArray = [model valueForKey:_keyPath];
        return subArray.count;
    }
    return self.modelArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id object = nil;
    if (self.isSection) {
        object  = self.modelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.modelArray[indexPath.row];
    }
    CGSize size  = self.itemSize;
    UICollectionViewCell *resultCell = nil;
    if (self.renderBlock) {
        resultCell = self.renderBlock(resultCell,indexPath,object,&size);//检测是否有自定义cell
        
        if (!resultCell) {//没有则注册一个
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellReuseIdentifier forIndexPath:indexPath];
            resultCell = self.renderBlock(cell,indexPath,object,&size);
        }
    }

    return resultCell;
}

#pragma mark -UICollectionViewDelegateFlowLayout(UICollectionViewDelegate)
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id object = nil;
    if (self.isSection) {
        object  = self.modelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.modelArray[indexPath.row];
    }
    CGSize size  = [self.dynamicProperty getSizeFromObject:object name:itemSize];
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        return size;
    }
    
    size = self.itemSize;
//    CGSize tempSize = size;
    UICollectionViewCell *cell = nil;
    if (self.renderBlock) {
        cell = self.renderBlock(_collectionViewCell,indexPath,object,&size);//取回真实的cell，实现cell的动态行高
    }
//    if (CGSizeEqualToSize(tempSize, size)) {
//        if (self.cellReuseIdentifier) {
////            size = [self dynamicRowHeight:cell tableView:tableView];//计算cell的动态行高
//            //             NSLog(@"%@--------rowHeight=%f",indexPath,height);
//        }
//    }
    
    [self.dynamicProperty setSizeToObject:object name:itemSize value:size];
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *sectionView      = nil;
    CGSize size = CGSizeZero;
    id model = self.modelArray[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (!self.headerViewBlock) {
            
            return sectionView;
        }
        
        sectionView = self.headerViewBlock(collectionView,indexPath,model,&size);
        [self.dynamicProperty setSizeToObject:model name:sectionHeaderSize value:size];
    }else if (kind == UICollectionElementKindSectionFooter){
        
        if (!self.footerViewBlock) {
            
            return sectionView;
        }
        sectionView = self.footerViewBlock(collectionView,indexPath,model,&size);
        [self.dynamicProperty setSizeToObject:model name:sectionFooterSize value:size];
    }
    return sectionView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = self.sectionHeaderSize;
    if (!self.headerViewBlock) {
        return size;
    }
    id model = self.modelArray[section];
    size  = [self.dynamicProperty getSizeFromObject:model name:sectionHeaderSize];
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        return size;
    }
    size = self.sectionHeaderSize;
    if (self.headerViewBlock) {
        self.headerViewBlock(nil, [NSIndexPath indexPathForRow:0 inSection:section], nil, &size);
    }
    [self.dynamicProperty setSizeToObject:model name:sectionHeaderSize value:size];
    return size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size = self.sectionFooterSize;
    if (!self.footerViewBlock) {
        return size;
    }
    id model = self.modelArray[section];
    size  = [self.dynamicProperty getSizeFromObject:model name:sectionFooterSize];
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        return size;
    }
    size = self.sectionFooterSize;
    if (self.footerViewBlock) {
        self.footerViewBlock(nil, [NSIndexPath indexPathForRow:0 inSection:section], nil, &size);
    }
    [self.dynamicProperty setSizeToObject:model name:sectionFooterSize value:size];
    return size;
}
@end
