//
//  MUCardView.h
//  AFNetworking
//
//  Created by Jekity on 2017/12/23.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,MUViewScrollDirection) {
    MUViewScrollDirectionHorizontal = 0,//轮播向右
    MUViewScrollDirectionVertical//轮播向左
};

@class MUCardLayout;
@interface MUCardView : UIView

-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array cellNibName:(NSString *)name;
-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array cellClassName:(NSString *)cellClassName;
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


@property (nonatomic,assign)BOOL scrollEnabled;


@property (nonatomic,assign)BOOL autoScrollEnabled;

/**
 *   广告的大小 advertisement's item size
 */
@property (nonatomic,assign)CGSize itemSize;
/**
 *   最小行间距
 */
@property (nonatomic,assign)CGFloat minimumLineSpacing;
/**
 *   最小item间距
 */
/**
 *   无限轮播 默认为yes     Default is Yes
 */
@property (nonatomic,assign)BOOL allowedInfinite;
@property (nonatomic,assign)CGFloat minimumInteritemSpacing;

@property(nonatomic, copy)void(^(muDidClickItem))(NSInteger index ,id model);

@property(nonatomic, copy)void (^renderBlock)(UICollectionViewCell *  cell ,NSIndexPath *  indexPath ,id  model);
/**
 *   scroll direction 轮播的方向 默认为向右
 */
@property (nonatomic,assign)MUViewScrollDirection autoScrollDirection;

@end
