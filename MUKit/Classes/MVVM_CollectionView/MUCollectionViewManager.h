//
//  MUCollectionViewManager.h
//  Pods
//
//  Created by Jekity on 2017/8/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MURefreshHeaderComponent.h"
#import "MURefreshFooterComponent.h"
#import "MUTipsView.h"

@class MUWaterfallFlowLayout;

@interface MUCollectionViewManager : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
////-(instancetype )initWithCollectionView:(UICollectionView *)collectionView subKeyPath:(NSString *)keyPath;
//-(instancetype )initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath;
//
//-(instancetype )initWaterfallWithCollectionView:(UICollectionView *)collectionView flowLayout:(MUWaterfallFlowLayout *)flowLayout itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath;
//-(void)registerNib:(NSString *)nibName cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.
//-(void)registerCellClass:(NSString *)className cellReuseIdentifier:(NSString *)cellReuseIdentifier;//don't not register more than once.if you do that,it will take take the final result.

-(instancetype)initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout registerNib:(NSString *)nibName itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath;
-(instancetype)initWithCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout registerCellClass:(NSString *)className itemCountForRow:(NSUInteger)count subKeyPath:(NSString *)keyPath;

- (void)registerHeaderViewClass:(NSString *)className withReuseIdentifier:(NSString *)identifier;
- (void)registerHeaderViewNib:(NSString *)name withReuseIdentifier:(NSString *)identifier;

- (void)registerFooterViewClass:(NSString *)className withReuseIdentifier:(NSString *)identifier;
- (void)registerFooterViewNib:(NSString *)name withReuseIdentifier:(NSString *)identifier;

@property (nonatomic ,assign)CGSize                     itemSize;//defalut is 44 point.
@property (nonatomic ,strong)NSArray                     *modelArray;//model's array
@property (nonatomic ,assign)CGFloat                     sectionHeaderHeight;//defalut is 44 point.
@property (nonatomic ,assign)CGFloat                     sectionFooterHeight;//defalut is 0.001 point.
@property (nonatomic ,assign)BOOL  moreData;
@property(nonatomic, copy ,readonly)NSString             *cellReuseIdentifier;
@property(nonatomic, readonly)UICollectionView           *collectionView;
@property(nonatomic, readonly)MUTipsView                 *tipsView;//提示视图
@property(nonatomic, strong)UIImage                      *backgroundViewImage;//tableView
@property(nonatomic, weak)UIView                         *scaleView;//下拉缩放的图片backgroundView image

@property(nonatomic, copy)UICollectionViewCell *(^renderBlock)(UICollectionViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat * height ,UIEdgeInsets *sectionInsets);


@property(nonatomic, copy)UICollectionReusableView *(^headerViewBlock)(UICollectionReusableView * headerView ,NSString ** title,NSIndexPath *indexPath,id  model, CGFloat * height);

@property(nonatomic, copy)UICollectionReusableView *(^footerViewBlock)(UICollectionReusableView * footerView ,NSString ** title,NSIndexPath *indexPath,id  model, CGFloat * height);

@property(nonatomic, copy)void (^selectedItemBlock)(UICollectionView *  collectionView ,NSIndexPath *  indexPath ,id  model ,CGFloat * height);

//scroll
@property(nonatomic, copy)void (^scrollViewWillBeginDragging)(UIScrollView *  scrollView);
@property(nonatomic, copy)void (^scrollViewDidScroll)(UIScrollView *  scrollView);
@property(nonatomic, copy)void (^scrollViewDidEndDragging)(UIScrollView *  scrollView , BOOL decelerate);
@property(nonatomic, copy)void (^scrollViewDidEndScrollingAnimation)(UIScrollView *  scrollView);

-(void)addHeaderRefreshing:(void(^)(MURefreshHeaderComponent *refresh))callback;
-(void)addFooterRefreshing:(void(^)(MURefreshFooterComponent *refresh))callback;
@end
