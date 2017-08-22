//
//  MUCollectionViewManager.h
//  Pods
//
//  Created by Jekity on 2017/8/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UICollectionViewCell *(^MUCollectionViewRenderBlock)(UICollectionViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGSize * size);//return your cell that you register in MUTableViewManager or your custom's cell
typedef UICollectionReusableView *(^MUCollectionHeaderViewRenderBlock)(UICollectionView * collectionView ,NSIndexPath *indexPath,id  model, CGSize * size);
typedef UICollectionReusableView *(^MUCollectionFooterViewRenderBlock)(UICollectionView * collectionView ,NSIndexPath *indexPath,id  model, CGSize * size);
typedef void (^MUCollectionViewSelectedBlock)(UICollectionView *  collectionView ,NSIndexPath *  indexPath ,id  model ,CGSize *   size);






@interface MUCollectionViewManager : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(instancetype )initWithCollectionView:(UICollectionView *)collectionView subKeyPath:(NSString *)keyPath;
-(instancetype )initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout subKeyPath:(NSString *)keyPath;
-(void)registerNib:(NSString *)nibName cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
-(void)registerCellClass:(NSString *)className cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
@property (nonatomic ,assign)CGSize                     itemSize;//defalut is 44 point.
@property (nonatomic ,assign)CGSize                     sectionHeaderSize;//defalut is 44 point.
@property (nonatomic ,assign)CGSize                     sectionFooterSize;//defalut is 0.001 point.
@property (nonatomic ,strong)NSArray                    *modelArray;//model's array
@property (nonatomic ,copy)MUCollectionViewRenderBlock        renderBlock;
@property (nonatomic ,copy)MUCollectionHeaderViewRenderBlock  headerViewBlock;
@property (nonatomic ,copy)MUCollectionFooterViewRenderBlock  footerViewBlock;
@property (nonatomic ,copy)MUCollectionViewSelectedBlock      selectedItemBlock;

@end
