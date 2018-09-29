//
//  BMKPOISearchResult.h
//  SearchComponent
//
//  本文件包含所有POI检索结果类
//  POI城市检索、POI周边检索、POI矩形区域检索服务都使用 BMKPOISearchResult 类
//  POI详情检索使用 BMKPOIDetailSearchResult 类
//  POI室内检索使用 BMKPOIIndoorSearchResult 类
//
//  Created by Baidu on 2018年05月23日.
//  Copyright © 2018年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKPoiSearchType.h"

#pragma mark - POI搜索结果类
/// POI检索结果类，城市检索、周边检索、矩形区域检索服务都使用此结果类。
@interface BMKPOISearchResult : NSObject
/**
 关于以下4个字段的解释：
 假如检索请求中 pageSize=10 且 pageIndex=2，即开发者期望检索结果每页10条，取第2页的结果。
 如果符合条件的检索结果总数为25条，检索结果总页数就是3，当前页结果个数为5，当前页的索引为3；
 如果符合条件的检索结果总数为8条，此时没有符合条件的检索结果。本对象为nil
 */
/// 符合条件的检索结果总个数
@property (nonatomic, assign) NSInteger totalPOINum;
/// 符合条件的检索结果总页数
@property (nonatomic, assign) NSInteger totalPageNum;
/// 当前页的结果个数
@property (nonatomic, assign) NSInteger curPOINum;
/// 当前页的页数索引
@property (nonatomic, assign) NSInteger curPageIndex;
/// POI列表，成员是BMKPoiInfo
@property (nonatomic, copy) NSArray<BMKPoiInfo *> *poiInfoList;
@end


#pragma mark - POI详情检索结果类
/// POI详情检索结果类
@interface BMKPOIDetailSearchResult : NSObject
/// 符合条件的检索结果总个数
@property (nonatomic, assign) NSInteger totalPOINum;
/// POI列表，成员是BMKPoiInfo
@property (nonatomic, copy) NSArray<BMKPoiInfo *> *poiInfoList;
@end


#pragma mark - POI室内搜索结果类
/// POI室内搜索结果类
@interface BMKPOIIndoorSearchResult : NSObject
/// 符合条件的检索结果总个数
@property (nonatomic, assign) NSInteger totalPOINum;
/// 符合条件的检索结果总页数
@property (nonatomic, assign) NSInteger totalPageNum;
/// 当前页的结果个数
@property (nonatomic, assign) NSInteger curPOINum;
/// 当前页的页数索引
@property (nonatomic, assign) NSInteger curPageIndex;
/// 室内POI列表，成员是BMKPoiIndoorInfo
@property (nonatomic, strong) NSArray<BMKPoiIndoorInfo *> *poiIndoorInfoList;
@end
