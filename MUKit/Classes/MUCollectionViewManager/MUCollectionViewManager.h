//
//  MUCollectionViewManager.h
//  Pods
//
//  Created by Jekity on 2017/8/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MURefreshHeaderStyleComponent.h"
#import "MURefreshFooterStyleComponent.h"
#import "MUTipsView.h"

@class MUWaterfallFlowLayout;

@interface MUCollectionViewManager : NSObject<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


-(instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          registerNib:(NSString *)nibName
                      itemCountForRow:(CGFloat)count
                           subKeyPath:(NSString *)keyPath;

-(instancetype)initWithCollectionView:(UICollectionView *)collectionView
                    registerCellClass:(NSString *)className
                      itemCountForRow:(CGFloat)count
                           subKeyPath:(NSString *)keyPath;


- (void)registerHeaderViewClass:(NSString *)className
            withReuseIdentifier:(NSString *)identifier;

- (void)registerHeaderViewNib:(NSString *)name
          withReuseIdentifier:(NSString *)identifier;

- (void)registerFooterViewClass:(NSString *)className
            withReuseIdentifier:(NSString *)identifier;

- (void)registerFooterViewNib:(NSString *)name
          withReuseIdentifier:(NSString *)identifier;

@property (nonatomic ,assign)CGSize                      itemSize;//defalut is 44 point.

/**
 模型数组，这个参数会根据下拉刷新或者上拉刷新的状态判断是否自动拼接数据，适合分页情况下使用
 */
@property (nonatomic ,strong)NSArray                     *modelArray;//model's array

@property(nonatomic, copy ,readonly)NSString             *cellReuseIdentifier;

@property(nonatomic, readonly)UICollectionView           *collectionView;

@property(nonatomic, readonly)MUTipsView                 *tipsView;//提示视图

@property(nonatomic, strong)UIImage                      *backgroundViewImage;//collectionView

@property(nonatomic, weak)UIView                         *scaleView;//下拉缩放的图片backgroundView image


//动态更改每行显示的item个数
@property (nonatomic,assign) CGFloat itemCounts;

/**
 所有的数组模型，如果使用的是modelArray，则它的数据可能只是分页数据中的一段
 */
@property (readonly) NSArray *dataArray;

@property(nonatomic, copy)UICollectionViewCell *(^renderBlock)(UICollectionViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat * height ,UIEdgeInsets *sectionInsets);


@property(nonatomic, copy)UICollectionReusableView *(^headerViewBlock)(UICollectionReusableView * headerView ,NSString ** title,NSIndexPath *indexPath,id  model, CGFloat * height);

@property(nonatomic, copy)UICollectionReusableView *(^footerViewBlock)(UICollectionReusableView * footerView ,NSString ** title,NSIndexPath *indexPath,id  model, CGFloat * height);

@property(nonatomic, copy)void (^selectedItemBlock)(UICollectionView *  collectionView ,NSIndexPath *  indexPath ,id  model ,CGFloat * height);

//scroll
@property(nonatomic, copy)void (^scrollViewWillBeginDragging)(UIScrollView *  scrollView);
@property(nonatomic, copy)void (^scrollViewDidScroll)(UIScrollView *  scrollView);
@property(nonatomic, copy)void (^scrollViewDidEndDragging)(UIScrollView *  scrollView , BOOL decelerate);
@property(nonatomic, copy)void (^scrollViewDidEndScrollingAnimation)(UIScrollView *  scrollView);

#pragma mark-refreshing

@property(nonatomic, weak)MURefreshComponent *refreshHeaderComponent;
@property(nonatomic, weak)MURefreshComponent *refreshFooterComponent;

/**
 下拉刷新
 */
-(void)addHeaderRefreshing:(void(^)(MURefreshComponent *refresh))callback;


/**
 上拉刷新
 */
-(void)addFooterRefreshing:(void(^)(MURefreshComponent *refresh))callback;


//刷新完成
@property (nonatomic,copy) void (^reloadDataFinished)(BOOL finished);

//清空collectionView数据展示 modelArray会置nil
- (void)clearData;
@end
