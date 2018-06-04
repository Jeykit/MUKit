//
//  MUTableViewManager.h
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MURefreshHeaderStyleComponent.h"
#import "MURefreshFooterStyleComponent.h"
#import "MUTipsView.h"


@class MURefreshHeaderComponent;
@class MURefreshFooterComponent;
@class MUTipsView;

@interface MUTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>

/**
 Unavailable. Please use initWithTableView: method
 */
-(instancetype)init NS_UNAVAILABLE;

/**
 Unavailable.Please use initWithTableView: method
 */
-(instancetype) new NS_UNAVAILABLE;
/**
 @param tableView MUTableViewManager不会持有传递过来的tableView
 这个初始化方法不会设置tableView的delegate和dataSource，目的是应对一些只需要图片下拉放大功能的情况
 */
-(instancetype)initWithTableView:(UITableView *)tableView;



/**
 @param tableView MUTableViewManager不会持有传递过来的tableView
 @param nibName 如果cell是xib，则传入相应xib的name
 @param keyPath 如果是分组模型，则传入相应的keyPath
 */
-(instancetype)initWithTableView:(UITableView *)tableView registerCellNib:(NSString *)nibName subKeyPath:(NSString *)keyPath;


/**
 @param tableView MUTableViewManager不会持有传递过来的tableView
 @param className cell的类名
 @param keyPath 如果是分组模型，则传入相应的keyPath
 */
-(instancetype)initWithTableView:(UITableView *)tableView registerCellClass:(NSString *)className subKeyPath:(NSString *)keyPath;

/**
模型数组，这个参数会根据下拉刷新或者上拉刷新的状态判断是否自动拼接数据，适合分页情况下使用
 */
@property (nonatomic ,strong)NSArray                     *modelArray;



/**
 模型数组，无论上拉刷新抑或下拉刷新都不会拼接数据
 */
@property (nonatomic ,strong)NSArray                     *modelAllArray;//model's array


/**
清空所有数据显示
 */
@property (nonatomic ,assign)BOOL                        clearData;



/**
 内部生成的注册cell对应的cellReuseIdentifier
 */
@property(nonatomic, copy ,readonly)NSString             *cellReuseIdentifier;



/**
 传递过来的UITableView
 */
@property(nonatomic, readonly)UITableView                *retainTableView;



/**
 UITableView数据为空时，则通过它设置相应的提示信息
 */
@property(nonatomic, readonly)MUTipsView                 *tipsView;



/**
 UITableView的backgroundViewImage
 */
@property(nonatomic, strong)UIImage                      *backgroundViewImage;//tableView



/**
 需要下拉放大的UIView(UIImageView)
 */
@property(nonatomic, weak)UIView                         *scaleView;//下拉缩放的图片backgroundView image


/**
 @param cell 注册的cell，也可以返回自定义的cell
 @param indexPath cell对应的NSIndexPath
 @param model 根据传进来的‘modelArray’模型数组，自动拆解后的模型
 @param height cell对应的高度
 */
@property(nonatomic, copy)UITableViewCell *(^renderBlock)(UITableViewCell *  cell ,NSIndexPath *  indexPath ,id  model ,CGFloat *  height);



/**
 @param tableView cell对应的UITableView
 @param sections 对应的分组
 @param title sections对应的title
 @param model 根据传进来的‘modelArray’模型数组，自动拆解后的模型
 @param height headerView对应的高度
 */
@property(nonatomic, copy)UIView *(^headerViewBlock)(UITableView * tableView ,NSUInteger sections, NSString **  title,id  model, CGFloat *  height);



/**
 @param tableView cell对应的UITableView
 @param sections 对应的分组
 @param title sections对应的title
 @param model 根据传进来的‘modelArray’模型数组，自动拆解后的模型
 @param height footerVie对应的高度
 */
@property(nonatomic, copy)UIView *(^footerViewBlock)(UITableView *  tableView ,NSUInteger sections,NSString **  title ,id  model ,CGFloat *  height);




/**
 @param tableView cell对应的UITableView
 @param indexPath cell对应的NSIndexPath
 @param model 根据传进来的‘modelArray’模型数组，自动拆解后的模型
 @param height cell对应的高度(如果点击后需要改变cell的高度，则可直接设置)
 */
@property(nonatomic, copy)void (^selectedCellBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,id  model ,CGFloat *   height);


/**
 //自定义删除按钮标题
 @param tableView cell对应的UITableView
 @param indexPath cell对应的NSIndexPath
 @return NSArray 对应自定义的UITableViewRowAction数组
 */
@property(nonatomic, copy)void (^titleForDeleteConfirmationButtonBlock)(UITableView *  tableView ,NSIndexPath *  indexPath ,NSString **title);
/**
 //删除按钮响应方法
 @param tableView cell对应的UITableView
 @param indexPath cell对应的NSIndexPath
 @return NSArray 对应自定义的UITableViewRowAction数组
 */
@property(nonatomic, copy)void (^deleteConfirmationButtonBlock)(UITableView *  tableView ,NSIndexPath *  indexPath,id model);
/**
 //自定义左滑出现按钮的方法
 @param tableView cell对应的UITableView
 @param indexPath cell对应的NSIndexPath
 @return NSArray 对应自定义的UITableViewRowAction数组
 */
@property(nonatomic, copy)NSArray<__kindof UITableViewRowAction*> *(^editActionsForRowAtIndexPathBlock)(UITableView *  tableView ,NSIndexPath *  indexPath,id model);

/**
 UISrollView的代理方法
 */
@property(nonatomic, copy)void (^scrollViewDidScroll)(UIScrollView *  scrollView);
@property(nonatomic, copy)void (^scrollViewWillBeginDragging)(UIScrollView *  scrollView);
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
@end

