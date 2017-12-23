//
//  MUCardLayout.h
//  AFNetworking
//
//  Created by Jekity on 2017/12/23.
//

#import <UIKit/UIKit.h>


@protocol MUCollectionViewFlowLayoutDelegate <NSObject>

-(void)mu_collectioViewScrollToIndex:(NSInteger)index;

@end
@interface MUCardLayout : UICollectionViewFlowLayout

/**
 *  非当前广告的alpha值 如果不需要，填负数
 */
@property (nonatomic,assign) CGFloat itemAlpha;
/**
 *  3D缩放值，若为0，则为2D广告
 */
@property (nonatomic,assign)CGFloat threeDimensionalScale;
/**
 *   循环起始点
 */
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,assign) id<MUCollectionViewFlowLayoutDelegate>delegate;

@end
