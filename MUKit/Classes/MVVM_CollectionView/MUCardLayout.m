//
//  MUCardLayout.m
//  AFNetworking
//
//  Created by Jekity on 2017/12/23.
//

#import "MUCardLayout.h"

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
}

////以下三个方法必须一起重载  分别是返回可见区域尺寸    获取可见区域内可见的item数组    当滚动的时候一直重绘collectionView
#pragma mark 重载方法1
// 返回可见区域的的内容尺寸
- (CGSize)collectionViewContentSize
{
    return [super collectionViewContentSize];
}

#pragma mark 重载方法2
// 返回rect中所有元素的布局属性
// 返回的是包含UICollectionViewLayoutAttributes的NSArray
// UICollectionViewAttributes可以是cell，追加视图以及装饰视图的信息，通过以下三个不同的方法可以获取到不同类型的UICollectionViewLayoutAttributes属性
// layoutAttributesForCellWithIndexPath：  返回对应cell的UICollectionViewAttributes布局属性
// layoutAtttibutesForSupplementaryViewOfKind：withIndexPath： 返回装饰的布局属性 如果没有追加视图可不重载
// layoutAttributesForDecorationViewOfKind：withIndexPath： 返回装饰的布局属性  如果没有可以不重载
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //    //1. 获取可见区域
    CGRect visibleRect;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        visibleRect= CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }else{
        visibleRect = CGRectMake(0,self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    //    //2. 获得这个区域的item
    NSArray *visibleItemArray =[[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:visibleRect]copyItems:YES];
    //    NSArray *visibleItemArray =[[NSArray alloc] initWithArray: [super layoutAttributesForElementsInRect:rect] copyItems:YES];
    //3. 遍历，让靠近中心线的item方法，离开的缩小
    NSInteger closest_index = 0;
    CGFloat distanceToCenter = 10000.0;
    CGFloat z_index = 0;
    for (UICollectionViewLayoutAttributes *attributes in visibleItemArray)
    {
        
        CGFloat scale = 0;
        CGFloat absOffset = 0;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            //1. 获取每个item距离可见区域左侧边框的距离 有正负
            CGFloat leftMargin = attributes.center.x - self.collectionView.contentOffset.x;
            //2. 获取边框距离屏幕中心的距离（固定的）
            CGFloat halfCenterX = self.collectionView.frame.size.width / 2;
            //3. 获取距离中心的的偏移量，需要绝对值
            absOffset = fabs(halfCenterX - leftMargin);
            //4. 获取的实际的缩放比例 距离中心越多，这个值就越小，也就是item的scale越小 中心是方法最大的
            scale = 1 - absOffset / halfCenterX;
        }else{
            //1. 获取每个item距离可见区域左侧边框的距离 有正负
            CGFloat topMargin = attributes.center.y - self.collectionView.contentOffset.y;
            //2. 获取边框距离屏幕中心的距离（固定的）
            CGFloat halfCenterY = self.collectionView.frame.size.height / 2;
            //3. 获取距离中心的的偏移量，需要绝对值
            absOffset = fabs(halfCenterY - topMargin);
            //4. 获取的实际的缩放比例 距离中心越多，这个值就越小，也就是item的scale越小 中心是方法最大的
            scale = 1 - absOffset / halfCenterY;
        }
        
        //5. 缩放
        if (self.threeDimensionalScale>0) {
            attributes.transform3D = CATransform3DMakeScale(1 + scale * (self.threeDimensionalScale-1), 1 + scale * (self.threeDimensionalScale-1),1);
        }
        //6. 是否需要透明
        if (self.itemAlpha>0||self.itemAlpha<1)
        {
            if (scale < self.itemAlpha)
            {
                attributes.alpha = self.itemAlpha;
            }
            else if (scale > 0.99)
            {
                attributes.alpha = 1.0;
            }
            else
            {
                attributes.alpha = scale;
            }
        }
        //7.层次 : 比较取得最靠近中间的item,重置z-index
        if (absOffset<distanceToCenter) {
            attributes.zIndex = z_index;
            z_index++;
            distanceToCenter = absOffset;
            closest_index = [visibleItemArray indexOfObject:attributes];
        }else{
            z_index--;
            attributes.zIndex = z_index;
            
        }
    }
    //设置最近的item的z-index
    if (visibleItemArray && visibleItemArray.count>0) {
        UICollectionViewLayoutAttributes *closest_attribute = visibleItemArray[closest_index];
        closest_attribute.zIndex = 1000;
        CGFloat minItemSapceing = self.minimumInteritemSpacing;
        CGFloat minLineSapceing = self.minimumLineSpacing;
        CGRect originalFrame = closest_attribute.frame;
        if (visibleItemArray.count > closest_index - 1) {
            
            NSArray *subarray1 = [visibleItemArray subarrayWithRange:NSMakeRange(0, closest_index)];
            for (UICollectionViewLayoutAttributes * attribute1 in [subarray1 reverseObjectEnumerator]) {
                
                CGRect newFrame = attribute1.frame;
                if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                    newFrame.origin.x = originalFrame.origin.x - newFrame.size.width - minItemSapceing;
                    attribute1.frame = newFrame;
                }else{
                    newFrame.origin.y = originalFrame.origin.y - newFrame.size.height - minLineSapceing;
                    attribute1.frame = newFrame;
                }
                originalFrame = newFrame;
                
            }
        }
        
        originalFrame = closest_attribute.frame;
        if (visibleItemArray.count > closest_index) {
            
            if (visibleItemArray.count - closest_index == 2||visibleItemArray.count == closest_index + 1) {
                 UICollectionViewLayoutAttributes * attribute = visibleItemArray[closest_index];
                if (visibleItemArray.count != closest_index + 1) {
                    attribute = visibleItemArray[closest_index + 1];
                    CGRect newFrame = attribute.frame;
                    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                        newFrame.origin.x = originalFrame.origin.x + minItemSapceing + originalFrame.size.width;
                    }else{
                        newFrame.origin.y = originalFrame.origin.y + minLineSapceing + originalFrame.size.height;
                    }
                    
                    attribute.frame = newFrame;
                    originalFrame = newFrame;
                }
               
            }else{
                NSArray *subarray1 = [visibleItemArray subarrayWithRange:NSMakeRange(closest_index, visibleItemArray.count - 1)];
                for (UICollectionViewLayoutAttributes * attribute1 in subarray1) {
                    
                    if (attribute1 == closest_attribute) {
                        continue;
                    }
                    CGRect newFrame = attribute1.frame;
                    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                        newFrame.origin.x = originalFrame.origin.x + minItemSapceing + originalFrame.size.width;
                    }else{
                        newFrame.origin.y = originalFrame.origin.y + minLineSapceing + originalFrame.size.height;
                    }
                    attribute1.frame = newFrame;
                    originalFrame = newFrame;
                    
                }
            }
            
        }
    }
    return visibleItemArray;
}

#pragma mark 重载方法3
// 滚动的时候会一直调用
// 当边界发生变化的时候，是否应该刷新布局。如果YES那么就是边界发生变化的时候，重新计算布局信息  这里的newBounds变化的只有偏移量的变化
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // 把collectionView本身的中心位子（固定的）,转换成collectionView整个内容上的point
    CGPoint pInView = [self.collectionView.superview convertPoint:self.collectionView.center toView:self.collectionView];
    
    // 通过坐标获取对应的indexpath
    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
    
    if (indexPathNow.row == 0)
    {
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
            if (newBounds.origin.x < MUScreenSize().width / 2)
            {
                if (_index != indexPathNow.row)
                {
                    _index = 0;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mu_collectioViewScrollToIndex:)])
                    {
                        [self.delegate mu_collectioViewScrollToIndex:_index];
                    }
                    
                }
            }
        }else{
            if (newBounds.origin.y < MUScreenSize().height / 2)
            {
                if (_index != indexPathNow.row)
                {
                    _index = 0;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mu_collectioViewScrollToIndex:)])
                    {
                        [self.delegate mu_collectioViewScrollToIndex:_index];
                    }
                    
                }
            }
        }
        
    }
    else
    {
        //        NSLog(@"%ld,%ld",_index,indexPathNow.row);
        if (_index != indexPathNow.row)
        {
            _index = indexPathNow.row;
            if (self.delegate && [self.delegate respondsToSelector:@selector(mu_collectioViewScrollToIndex:)])
            {
                [self.delegate mu_collectioViewScrollToIndex:_index];
            }
        }
        
        
    }
    
    
    [super shouldInvalidateLayoutForBoundsChange:newBounds];
    return YES;
}



#pragma mark 指向item的中心
// 该方法可写可不写，主要是让滚动的item根据距离中心的值，确定哪个必须展示在中心，不会像普通的那样滚动到哪里就停到哪里
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // ProposeContentOffset是本来应该停下的位子
    // 1. 先给一个字段存储最小的偏移量 那么默认就是无限大
    CGFloat minOffset = CGFLOAT_MAX;
    // 2. 获取到可见区域的centerX 和centerY
    CGFloat horizontalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;
    CGFloat verticalCenter = proposedContentOffset.y+self.collectionView.bounds.size.height/2;
    // 3. 拿到可见区域的rect
    CGRect visibleRect;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        visibleRect= CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }else{
        visibleRect = CGRectMake(0,proposedContentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    }
    // 4. 获取到所有可见区域内的item数组
    NSArray *visibleAttributes = [super layoutAttributesForElementsInRect:visibleRect];
    
    // 5. 遍历数组，找到距离中心最近偏移量是多少 可以是垂直偏移量也可以是水平偏移量
    for (UICollectionViewLayoutAttributes *atts in visibleAttributes)
    {
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            // 可见区域内每个item对应的中心X坐标
            CGFloat itemCenterX = atts.center.x;
            // 比较是否有更小的，有的话赋值给minOffset
            if (fabs(itemCenterX - horizontalCenter) <= fabs(minOffset)) {
                minOffset = itemCenterX - horizontalCenter;
            }
        }else{
            // 可见区域内每个item对应的中心X坐标
            CGFloat itemCenterY = atts.center.y;
            // 比较是否有更小的，有的话赋值给minOffset
            if (fabs(itemCenterY - verticalCenter) <= fabs(minOffset)) {
                minOffset = itemCenterY - verticalCenter;
            }
        }
        
        
        
    }
    // 这里需要注意的是  eg水平方向为例：  上面获取到的minOffset有可能是负数，那么代表左边的item还没到中心，如果确定这种情况下左边的item是距离最近的，那么需要左边的item居中，意思就是collectionView的偏移量需要比原本更小才是，例如原先是1000的偏移，但是需要展示前一个item，所以需要1000减去某个偏移量，因此不需要更改偏移的正负
    
    // eg水平方向为例 ：但是当propose小于0的时候或者大于contentSize（除掉左侧和右侧偏移以及单个cell宽度）  、
    // eg水平方向为例 ： 防止当第一个或者最后一个的时候不会有居中（偏移量超过了本身的宽度），直接卡在推荐的停留位置
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat centerOffsetX = proposedContentOffset.x + minOffset;
        if (centerOffsetX < 0) {
            centerOffsetX = 0;
        }
        
        if (centerOffsetX > self.collectionView.contentSize.width -(self.sectionInset.left + self.sectionInset.right + self.itemSize.width)) {
            centerOffsetX = floor(centerOffsetX);
        }
        return CGPointMake(centerOffsetX, proposedContentOffset.y);
    }else{
        CGFloat centerOffsetY = proposedContentOffset.y + minOffset;
        if (centerOffsetY < 0) {
            centerOffsetY = 0;
        }
        
        if (centerOffsetY > self.collectionView.contentSize.height -(self.sectionInset.top + self.sectionInset.bottom + self.itemSize.height)) {
            centerOffsetY = floor(centerOffsetY);
        }
        return CGPointMake(proposedContentOffset.x, centerOffsetY);
    }
}
CGSize MUScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    _index = currentIndex;
}
@end
