//
//  MUCardLayout.m
//  AFNetworking
//
//  Created by Jekity on 2017/12/23.
//

#import "MUCardLayout.h"

#define ACTIVE_DISTANCE 200
#define kScreen_Height       CGRectGetHeight(self.collectionView.frame)
#define kScreen_Width       CGRectGetWidth(self.collectionView.frame)
@implementation MUCardLayout{
    
    NSUInteger _index;
}
// 初始化方法
- (instancetype)init
{
    if (self == [super init]) {
        _index = 0;
    }
    return self;
}
// 该方法会自动重载
- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat offset = self.collectionView.frame.size.width - self.itemSize.width;
    offset = offset / 2.0;
    self.sectionInset = UIEdgeInsetsMake(0, offset, 0, offset);
}

////以下三个方法必须一起重载  分别是返回可见区域尺寸    获取可见区域内可见的item数组    当滚动的时候一直重绘collectionView

#pragma mark 重载方法2
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *layoutAttributesCopy = [NSMutableArray arrayWithCapacity:layoutAttributes.count];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    for (UICollectionViewLayoutAttributes *attribute in layoutAttributes) {
        UICollectionViewLayoutAttributes *attributeCopy = [attribute copy];
        CGFloat distance = visibleRect.origin.x + visibleRect.size.width / 2.0 - attributeCopy.center.x;
        CGFloat normalizedDistance = fabs(distance / 400);
        CGFloat zoom = 1 - self.threeDimensionalScale * normalizedDistance;
        attributeCopy.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        attributeCopy.zIndex = 1;
//        attribute.alpha = self.itemAlpha;
        [layoutAttributesCopy addObject:attributeCopy];
    }
    return layoutAttributesCopy;
}

#pragma mark 重载方法3
// 滚动的时候会一直调用
// 当边界发生变化的时候，是否应该刷新布局。如果YES那么就是边界发生变化的时候，重新计算布局信息  这里的newBounds变化的只有偏移量的变化
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}



#pragma mark 指向item的中心
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect currentContentRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [self layoutAttributesForElementsInRect:currentContentRect];
    CGFloat adjustOffset = CGFLOAT_MAX;
    CGFloat centerX = currentContentRect.origin.x + currentContentRect.size.width / 2.0;
    for (UICollectionViewLayoutAttributes *attribute in layoutAttributes) {
        if (fabs(attribute.center.x - centerX) < fabs(adjustOffset)) {
            adjustOffset = attribute.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffset, proposedContentOffset.y);
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    _index = currentIndex;
}
@end
