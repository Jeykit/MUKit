//
//  MUWaterfallFlowLayout.m
//  MUKit
//
//  Created by Jekity on 2017/8/23.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUWaterfallFlowLayout.h"


@interface MUWaterfallFlowLayout()<UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong)NSMutableArray                  * attributeArray;
@property(nonatomic, strong)UICollectionViewLayoutAttributes* headerAttributes;
@property(nonatomic, strong)UICollectionViewLayoutAttributes* footerAttribytes;
@property(nonatomic, strong)NSMutableArray *itemHeightArray;
@property(nonatomic, assign)CGFloat contentHeight;
@end
@implementation MUWaterfallFlowLayout
- (void)prepareLayout{
    self.attributeArray = [[NSMutableArray alloc] init];
    [super prepareLayout];
    
    NSInteger numberOfSections = [self numberOfSections:self.collectionView];//总的section数
    
    _contentHeight = 0;
    CGFloat itemSpacing =0;
    for (int i = 0; i < numberOfSections; i++) {
        self.itemHeightArray = [NSMutableArray array];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:i];
        
        UIEdgeInsets sectionInset = [self sectionInset:self delegate:self.delegate collectionView:self.collectionView section:i];
       
        CGSize  sectionHeaderSize = [self sectionHeaderSize:self delegate:self.delegate collectionView:self.collectionView section:i];
        CGSize  sectionFooterSize = [self sectionFooterSize:self delegate:self.delegate collectionView:self.collectionView section:i];
        UICollectionViewLayoutAttributes* attribute;
        
        
        if(sectionHeaderSize.height > 0){
            attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
            attribute.frame = CGRectMake(0, sectionInset.top + _contentHeight, sectionHeaderSize.width, sectionHeaderSize.height);
            self.headerAttributes = attribute;
            [self.attributeArray addObject:attribute];
        }
        for (NSInteger m = 0; m < self.itemCount; m++) {
            [self.itemHeightArray addObject:@(self.sectionInset.top+sectionHeaderSize.height)];
        }
        
        _contentHeight += sectionHeaderSize.height;

        NSUInteger cloumnCount = 0;
        CGFloat minColumnHeight = 0;
        NSInteger numberOfItemsInSection = [self numberOfItemsInSection:self.collectionView row:i];
        for (int j = 0; j < numberOfItemsInSection; j++) {
            
            cloumnCount = j%_itemCount;
            minColumnHeight = [self.itemHeightArray[cloumnCount] floatValue];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            itemSpacing = [self minimumInteritemSpacingForSectionAtIndex:self delegate:self.delegate collectionView:self.collectionView row:j];
            CGSize size = [self sizeForItemAtIndexPath:self delegate:self.delegate collectionView:self.collectionView indexPath:indexPath];
            
            CGFloat x = sectionInset.left + (itemSpacing + size.width) * cloumnCount;
            CGFloat y = minColumnHeight + self.minimumLineSpacing;
            
            attris.frame = CGRectMake(x,y,size.width,size.height);
            CGFloat maxHeight = CGRectGetMaxY(attris.frame);
            self.itemHeightArray[cloumnCount] = @(maxHeight);//保存对应列的最大y值
            [self.attributeArray addObject:attris];
            if (self.contentHeight < maxHeight) {
                self.contentHeight = maxHeight;
            }
            
        }
        if(sectionFooterSize.height > 0){
            attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
            attribute.frame = CGRectMake(0, _contentHeight, sectionFooterSize.width, sectionFooterSize.height);
            self.footerAttribytes = attribute;
            [self.attributeArray addObject:attribute];
        }
        _contentHeight += sectionFooterSize.height;
    }
    
}
-(NSUInteger)numberOfSections:(UICollectionView *)collectionView{//return sections in collections
    NSUInteger sections = 1;
    if([collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]){
        sections = [collectionView.dataSource numberOfSectionsInCollectionView:collectionView];
    }
    return sections;
}

-(UIEdgeInsets)sectionInset:(UICollectionViewFlowLayout *)flowLayout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate collectionView:(UICollectionView *)collectionView section:(NSUInteger)section{
    UIEdgeInsets sectionInset = flowLayout.sectionInset;
    if([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]){
        sectionInset = [delegate collectionView:collectionView layout:flowLayout insetForSectionAtIndex:section];
    }
    return sectionInset;
}

-(CGSize)sectionHeaderSize:(UICollectionViewFlowLayout *)flowLayout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate collectionView:(UICollectionView *)collectionView section:(NSUInteger)section {
    
    CGSize  sectionHeaderSize = flowLayout.headerReferenceSize;
    if([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]){
        sectionHeaderSize = [delegate collectionView:collectionView layout:flowLayout referenceSizeForHeaderInSection:section];
    }
    return sectionHeaderSize;
}

-(CGSize)sectionFooterSize:(UICollectionViewFlowLayout *)flowLayout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate collectionView:(UICollectionView *)collectionView section:(NSUInteger)section {
    
    CGSize  sectionFooterSize = flowLayout.headerReferenceSize;
    if([delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]){
        sectionFooterSize = [delegate collectionView:collectionView layout:flowLayout referenceSizeForFooterInSection:section];
    }
    return sectionFooterSize;
}

-(NSUInteger)numberOfItemsInSection:(UICollectionView *)collectionView row:(NSUInteger)row{
    
    NSInteger numberOfItemsInSection = 0;
    if([collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]){
        numberOfItemsInSection = [self.collectionView.dataSource collectionView:collectionView numberOfItemsInSection:row];
    }
    return numberOfItemsInSection;
}

-(CGFloat)minimumInteritemSpacingForSectionAtIndex:(UICollectionViewFlowLayout *)flowLayout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate collectionView:(UICollectionView *)collectionView row:(NSUInteger)row{
    
    CGFloat itemSpacing = flowLayout.minimumInteritemSpacing;
    if([delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]){
        itemSpacing =  [delegate collectionView:collectionView layout:flowLayout minimumInteritemSpacingForSectionAtIndex:row];
    }
    return itemSpacing;
}

-(CGSize)sizeForItemAtIndexPath:(UICollectionViewFlowLayout *)flowLayout delegate:(id<UICollectionViewDelegateFlowLayout>)delegate collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    if([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]){
        
        size = [delegate collectionView:collectionView layout:flowLayout sizeForItemAtIndexPath:indexPath];
    }
    return size;
}
//- (CGSize)collectionViewContentSize{
//    CGRect frame = [[self.attributeArray lastObject] frame];
//    return CGSizeMake(self.collectionView.frame.size.width, frame.origin.y + frame.size.height);
//}

- (NSArray<UICollectionViewLayoutAttributes*> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attributeArray;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if (elementKind == UICollectionElementKindSectionFooter) {
        return self.footerAttribytes;
    }
    return self.headerAttributes;
}
-(CGSize)collectionViewContentSize{
    
    return CGSizeMake(0, self.contentHeight);
}
@end
