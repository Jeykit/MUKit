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

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;


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
        _tableView.estimatedRowHeight = 88.;
        _keyPath             = keyPath;
        _rowHeight           = 44.;
        _sectionHeaderHeight = 0.001;
        _sectionFooterHeight = 0.001;
        _dynamicProperty = [[MUAddedPropertyModel alloc]init];
        _offscreenCells = [NSMutableDictionary dictionary];
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

-(CGFloat)dynamicRowHeight:(UITableViewCell *)cell tableView:(UITableView *)tableView{
    //Use the dictionary of offscreen cells to get a cell for the reuse identifier, creating a cell and storing
    // it in the dictionary if one hasn't already been added for the reuse identifier.
    // WARNING: Don't call the table view's dequeueReusableCellWithIdentifier: method here because this will
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    // The cell's width must be set to the same size it will end up at once it is in the table view.
    // This is important so that we'll get the correct height for different table view widths, since our cell's
    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    // NOTE: if you are displaying a section index (e.g. alphabet along the right side of the table view), or
    // if you are using a grouped table view style where cells have insets to the edges of the table view,
    // you'll need to adjust the cell.bounds.size.width to be smaller than the full width of the table view we just
    // set it to above. See http://stackoverflow.com/questions/3647242 for discussion on the section index width.
    //            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
    return height;
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
        
        CGFloat height  = [self.dynamicProperty getValueFromObject:object name:rowHeight];
        CGFloat tempHeight = height;
        self.selectedCellBlock(tableView, indexPath, object, &height);
        if (height != tempHeight) {
             [self.dynamicProperty setValueToObject:object name:rowHeight value:height];
            [self.dynamicProperty setValueToObject:object name:selectedState value:height];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
       
    }
}

#pragma mark -make sure to call cellForRowAtIndexPath: and call heightForRowAtIndexPath: then;
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
@end
