//
//  MUCardLayout.m
//  AFNetworking
//
//  Created by Jekity on 2017/12/23.
//

#import "MUCardLayout.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.1
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)


@implementation MUCardLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kScreen_Width - 100, 200);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 15;
        self.minimumInteritemSpacing = 20;
        self.sectionInset = UIEdgeInsetsMake(64, 35, 0, 35);
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat distance = self.collectionView.contentOffset.x + self.collectionView.contentInset.left - attributes.center.x;
            distance = ABS(distance);
            CGFloat scale = MIN(MAX(1 - distance/(self.collectionView.bounds.size.width), 0.85), 1);
            attributes.transform = CGAffineTransformMakeScale(scale, scale);
            
//            if (distance < kScreen_Width / 2 + self.itemSize.width) {
//                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - distance / ACTIVE_DISTANCE);
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
//                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0 , -zoom * 25, 0);
//                attributes.alpha = zoom - ZOOM_FACTOR;
//            }
            
        }
    }
    
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect lastRect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    //获得collectionVIew中央的X值(即显示在屏幕中央的X)
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    //这个范围内所有的属性
    NSArray* array = [self layoutAttributesForElementsInRect:lastRect];
    //需要移动的距离
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attri in  array) {
        if (fabs(attri.center.x - centerX) < fabs(adjustOffsetX)) {
            adjustOffsetX = attri.center.x - centerX;
        }
    }
   
    return CGPointMake((proposedContentOffset.x + adjustOffsetX), proposedContentOffset.y);
    
 
}

- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in arr) {
        [arrM addObject:[attr copy]];
    }
    return arrM;
}
@end
