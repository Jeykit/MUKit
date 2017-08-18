//
//  MUTableViewManager.m
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUTableViewManager.h"
#import "MUAddedPropertyModel.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface MUTableViewManager()

@property (nonatomic ,weak)UITableView *tableView;

@property (nonatomic ,copy)NSString *keyPath;

@property (nonatomic ,assign,getter=isSection)BOOL section;

@property (nonatomic ,strong)MUAddedPropertyModel *dynamicProperty;

@property (nonatomic ,copy)NSString *cellModelName;
@property (nonatomic ,copy)NSString *sectionModelName;
@end


static NSString * const sectionFooterHeight = @"sectionFooterHeight";
static NSString * const sectionHeaderHeight = @"sectionHeaderHeight";
static NSString * const sectionFooterTitle  = @"sectionFooterTitle";
static NSString * const sectionHeaderTitle  = @"sectionHeaderTitle";

static NSString * const selectedState = @"selectedState";
static NSString * const rowHeight = @"rowHeight";
@implementation MUTableViewManager
-(instancetype)initWithTableView:(UITableView *)tableView subKeyPath:(NSString *)keyPath{
    if (self = [super init]) {
        _tableView           = tableView;
        _keyPath             = keyPath;
        _rowHeight           = 44.;
        _sectionHeaderHeight = 0.001;
        _sectionFooterHeight = 0.001;
        _dynamicProperty = [[MUAddedPropertyModel alloc]init];
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
    [model addProperty:object propertyName:selectedState type:MUAddedPropertyTypeAssign];
}

#pragma mark - dataSource
-(void)setModelArray:(NSMutableArray *)modelArray{
    _modelArray = modelArray;
     [self configuredWithArray:modelArray name:_keyPath];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   
}

#pragma mark - dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSection) {
       return self.modelArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.isSection) {
        
        id model = self.modelArray[section];
        NSArray *subArray = [model valueForKey:_keyPath];
        return subArray.count;
    }
    return self.modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    id object = nil;
    if (self.isSection) {
        object  = self.modelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.modelArray[indexPath.row];
    }
     CGFloat height  = self.rowHeight;
    if (self.renderBlock) {
        cell = self.renderBlock(tableView,indexPath,object,&height);
    }
    CGFloat state = [self.dynamicProperty getValueFromObject:object name:selectedState];
    if (state<=0) {
        [self.dynamicProperty setValueToObject:object name:rowHeight value:height];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id object = nil;
    if (self.isSection) {
        object  = self.modelArray[indexPath.section];
        NSArray *subArray = [object valueForKey:_keyPath];
        object  = subArray[indexPath.row];
    }else{
        object  = self.modelArray[indexPath.row];
    }
    CGFloat height  = [self.dynamicProperty getValueFromObject:object name:rowHeight];
    if (height > 0) {
        return height;
    }
    height = self.rowHeight;
    if (self.renderBlock) {
        self.renderBlock(nil,indexPath,nil,&height);
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
    id model = self.modelArray[section];
    CGFloat height = self.sectionHeaderHeight;
    if (self.headerViewBlock) {
        
        headerView = self.headerViewBlock(tableView,section,&title,model,&height);
    }
    tableView.sectionHeaderHeight = 0;
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{//刷新数据时调用

    
    if (!self.isSection) {
        
        return 44.;
    }
    id model = self.modelArray[section];
    CGFloat height = self.sectionHeaderHeight;
    if (!self.headerViewBlock) {
        return height;
    }
     NSString * title = @"";
    height  = [self.dynamicProperty getValueFromObject:model name:sectionHeaderHeight];
    if (height >0) {
        return height;
    }
    height = self.sectionHeaderHeight;
    if (self.headerViewBlock) {
        
        self.headerViewBlock(nil, section,&title, nil, &height);
    }
    [self.dynamicProperty setValueToObject:model name:sectionHeaderHeight value:height];

    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    UIView *footerView      = nil;
    if (!self.footerViewBlock) {
        return footerView;
    }
    id model = self.modelArray[section];
    NSString * title = @"";
    CGFloat height = self.sectionFooterHeight;
    if (self.footerViewBlock) {
        
        footerView = self.footerViewBlock(tableView, section,&title, model, &height);
    }
    return footerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{//刷新数据时调用
    id model = self.modelArray[section];
    CGFloat height = self.sectionFooterHeight;
    if (!self.footerViewBlock) {
        return height;
    }
    height  = [self.dynamicProperty getValueFromObject:model name:sectionFooterHeight];
    if (height >0) {
        return height;
    }
    NSString * title = @"";
    height = self.sectionFooterHeight;
    if (self.footerViewBlock) {
        
        self.footerViewBlock(nil, section, &title,nil, &height);
    }
    [self.dynamicProperty setValueToObject:model name:sectionFooterHeight value:height];
    [self.dynamicProperty setObjectToObject:model name:sectionFooterTitle value:title];
    return height;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * title = @"";
    if (!self.headerViewBlock) {
        return nil;
    }
    id model = self.modelArray[section];
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
    id model = self.modelArray[section];
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
            object  = self.modelArray[indexPath.section];
            NSArray *subArray = [object valueForKey:_keyPath];
            object  = subArray[indexPath.row];
        }else{
            object  = self.modelArray[indexPath.row];
        }
        
        CGFloat height  = 0;
        self.selectedCellBlock(tableView, indexPath, object, &height);
        if (height > 0) {
             [self.dynamicProperty setValueToObject:object name:rowHeight value:height];
            [self.dynamicProperty setValueToObject:object name:selectedState value:height];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
       
    }
}

#pragma mark -make sure to call cellForRowAtIndexPath: and call heightForRowAtIndexPath: then;
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{//make sure to call
    
    return self.rowHeight;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    
//    return 0.001;
//}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//    return 0.001;
//}
@end
