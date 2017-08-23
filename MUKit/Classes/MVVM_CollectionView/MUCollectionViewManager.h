//
//  MUCollectionViewManager.h
//  Pods
//
//  Created by Jekity on 2017/8/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UICollectionViewCell *(^MUCollectionViewRenderBlock)(UICollectionViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat * height ,UIEdgeInsets *sectionInsets);
typedef UICollectionReusableView *(^MUCollectionHeaderViewRenderBlock)(UICollectionReusableView * headerView ,NSIndexPath *indexPath,id  model, CGFloat * height);
typedef UICollectionReusableView *(^MUCollectionFooterViewRenderBlock)(UICollectionReusableView * footerView ,NSIndexPath *indexPath,id  model, CGFloat * height);
typedef void (^MUCollectionViewSelectedBlock)(UICollectionView *  collectionView ,NSIndexPath *  indexPath ,id  model ,CGFloat * height);





@class MUWaterfallFlowLayout;
@interface MUCollectionViewManager : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//-(instancetype )initWithCollectionView:(UICollectionView *)collectionView subKeyPath:(NSString *)keyPath;
-(instancetype )initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath;

-(instancetype )initWaterfallWithCollectionView:(UICollectionView *)collectionView flowLayout:(MUWaterfallFlowLayout *)flowLayout itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath;
-(void)registerNib:(NSString *)nibName cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
-(void)registerCellClass:(NSString *)className cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.


- (void)registerHeaderViewClass:(NSString *)className withReuseIdentifier:(NSString *)identifier;
- (void)registerHeaderViewNib:(NSString *)name withReuseIdentifier:(NSString *)identifier;

- (void)registerFooterViewClass:(NSString *)className withReuseIdentifier:(NSString *)identifier;
- (void)registerFooterViewNib:(NSString *)name withReuseIdentifier:(NSString *)identifier;

@property (nonatomic ,assign)CGSize                     itemSize;//defalut is 44 point.
@property (nonatomic ,strong)NSArray                    *modelArray;//model's array
@property (nonatomic ,assign)CGFloat                     sectionHeaderHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionFooterHeight;//defalut is 0.001 point.


@property (nonatomic ,copy)MUCollectionViewRenderBlock        renderBlock;
@property (nonatomic ,copy)MUCollectionHeaderViewRenderBlock  headerViewBlock;
@property (nonatomic ,copy)MUCollectionFooterViewRenderBlock  footerViewBlock;
@property (nonatomic ,copy)MUCollectionViewSelectedBlock      selectedItemBlock;

@end
