//
//  BMKPOISearchOption.h
//  SearchComponent
//
//  本文件中包含了5种POI检索对应的请求参数信息类，以及其中用到的参数类、枚举等。
//  请求参数信息类的命名规则统一为 BMKPOIXXXSearchOption
//
//  Created by Baidu on 2018/5/8.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMKPoiSearchType.h"


#pragma mark - 枚举类型
/**
 检索过滤条件中的POI的行业类型
 
 - BMK_POI_INDUSTRY_TYPE_HOTEL: 宾馆
 - BMK_POI_INDUSTRY_TYPE_CATER: 餐饮
 - BMK_POI_INDUSTRY_TYPE_LIFE: 生活娱乐
 */
typedef NS_ENUM(NSUInteger, BMKPOIIndustryType) {
    BMK_POI_INDUSTRY_TYPE_HOTEL = 1,
    BMK_POI_INDUSTRY_TYPE_CATER,
    BMK_POI_INDUSTRY_TYPE_LIFE,
};

/**
 检索过滤条件中的排序依据类型
 类型整体分为宾馆行业、餐饮行业、生活娱乐行业3大类
 
 - BMK_POI_SORTNAME_TYPE_HOTEL_DEFAULT: 宾馆行业，默认排序
 - BMK_POI_SORTNAME_TYPE_HOTEL_PRICE: 宾馆行业，按价格排序
 - BMK_POI_SORTNAME_TYPE_HOTEL_DISTANCE: 宾馆行业，按距离排序（只对周边检索有效）
 - BMK_POI_SORTNAME_TYPE_HOTEL_TOTAL_SCORE: 宾馆行业，按好评排序
 - BMK_POI_SORTNAME_TYPE_HOTEL_LEVEL: 宾馆行业，按星级排序
 - BMK_POI_SORTNAME_TYPE_HOTEL_HEALTH_SCORE: 宾馆行业，按卫生排序
 - BMK_POI_SORTNAME_TYPE_CATER_DEFAULT: 餐饮行业，默认排序
 - BMK_POI_SORTNAME_TYPE_CATER_PRICE: 餐饮行业，按价格排序
 - BMK_POI_SORTNAME_TYPE_CATER_DISTANCE: 餐饮行业，按距离排序（只对周边检索有效）
 - BMK_POI_SORTNAME_TYPE_CATER_TASTE_RATING: 餐饮行业，按口味排序
 - BMK_POI_SORTNAME_TYPE_CATER_OVERALL_RATING: 餐饮行业，按好评排序
 - BMK_POI_SORTNAME_TYPE_CATER_SERVICE_RATING: 餐饮行业，按服务排序
 - BMK_POI_SORTNAME_TYPE_LIFE_DEFAULT: 生活娱乐行业，默认排序
 - BMK_POI_SORTNAME_TYPE_LIFE_PRICE: 生活娱乐行业，按价格排序
 - BMK_POI_SORTNAME_TYPE_LIFE_DISTANCE: 生活娱乐行业，按距离排序（只对周边检索有效）
 - BMK_POI_SORTNAME_TYPE_LIFE_OVERALL_RATING: 生活娱乐行业，按好评排序
 - BMK_POI_SORTNAME_TYPE_LIFE_COMMENT_NUMBER: 生活娱乐行业，按服务排序
 */
typedef NS_ENUM(NSUInteger, BMKPOISortBasisType) {
    BMK_POI_SORT_BASIS_TYPE_HOTEL_DEFAULT = 1,
    BMK_POI_SORT_BASIS_TYPE_HOTEL_PRICE,
    BMK_POI_SORT_BASIS_TYPE_HOTEL_DISTANCE,
    BMK_POI_SORT_BASIS_TYPE_HOTEL_TOTAL_SCORE,
    BMK_POI_SORT_BASIS_TYPE_HOTEL_LEVEL,
    BMK_POI_SORT_BASIS_TYPE_HOTEL_HEALTH_SCORE,
    
    BMK_POI_SORT_BASIS_TYPE_CATER_DEFAULT = 10,
    BMK_POI_SORT_BASIS_TYPE_CATER_PRICE,
    BMK_POI_SORT_BASIS_TYPE_CATER_DISTANCE,
    BMK_POI_SORT_BASIS_TYPE_CATER_TASTE_RATING,
    BMK_POI_SORT_BASIS_TYPE_CATER_OVERALL_RATING,
    BMK_POI_SORT_BASIS_TYPE_CATER_SERVICE_RATING,
    
    BMK_POI_SORT_BASIS_TYPE_LIFE_DEFAULT = 20,
    BMK_POI_SORT_BASIS_TYPE_LIFE_PRICE,
    BMK_POI_SORT_BASIS_TYPE_LIFE_DISTANCE,
    BMK_POI_SORT_BASIS_TYPE_LIFE_OVERALL_RATING,
    BMK_POI_SORT_BASIS_TYPE_LIFE_COMMENT_NUMBER,
};

/**
 POI检索排序规则
 
 - BMK_POI_SORT_RULE_DESCENDING: 从高到底，降序排列
 - BMK_POI_SORT_RULE_ASCENDING: 从低到高，升序排列
 */
typedef NS_ENUM(NSUInteger, BMKPOISortRuleType) {
    BMK_POI_SORT_RULE_DESCENDING = 0,
    BMK_POI_SORT_RULE_ASCENDING,
};

/**
 POI检索结果详细程度
 
 - BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
 - BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
 */
typedef NS_ENUM(NSUInteger, BMKPOISearchScopeType) {
    BMK_POI_SCOPE_BASIC_INFORMATION = 1,
    BMK_POI_SCOPE_DETAIL_INFORMATION,
};


#pragma mark - POI检索过滤条件类
@interface BMKPOISearchFilter : NSObject
/// POI所属行业类型，设置该字段可提高检索速度和过滤经度
@property (nonatomic, assign) BMKPOIIndustryType industryType;
/**
 排序依据，根据industryType字段指定的行业类型不同，此字段应设置为对应行业的依据值
 比如industryType字段的值为BMK_POI_INDUSTRY_TYPE_CATER，则此字段应选择BMK_POI_SORT_BASIS_TYPE_CATER_XXX对应的枚举值
 */
@property (nonatomic, assign) BMKPOISortBasisType sortBasis;
/// 排序规则
@property (nonatomic, assign) BMKPOISortRuleType sortRule;
/// 是否有团购
@property (nonatomic, assign) BOOL isGroupon;
/// 是否有打折
@property (nonatomic, assign) BOOL isDiscount;
@end


#pragma mark - POI城市检索参数信息类
/// POI城市检索参数信息类
@interface BMKPOICitySearchOption : NSObject
/// 检索关键字，必选。举例：天安门
@property (nonatomic, copy) NSString *keyword;
/// 检索分类，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,酒店
@property (nonatomic, copy) NSArray<NSString *> *tags;
/// 区域名称(市或区的名字，如北京市，海淀区)或区域编码，必选
@property (nonatomic, copy) NSString *city;
/// 区域数据返回限制，可选，为true时，仅返回city对应区域内数据
@property (nonatomic, assign) BOOL isCityLimit;
/// 检索结果详细程度
@property (nonatomic, assign) BMKPOISearchScopeType scope;
/// 检索过滤条件。scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
@property (nonatomic, strong) BMKPOISearchFilter *filter;
/// 分页页码，默认为0,0代表第一页，1代表第二页，以此类推
@property (nonatomic, assign) NSInteger pageIndex;
/// 单次召回POI数量，默认为10条记录，最大返回20条。
@property (nonatomic, assign) NSInteger pageSize;
@end


#pragma mark - POI周边检索参数信息类
/// POI周边检索参数信息类
@interface BMKPOINearbySearchOption : NSObject
/**
 检索关键字，必选。
 在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
 最多支持10个关键字。
 */
@property (nonatomic, copy) NSArray<NSString *> *keywords;
/**
 检索分类，可选。
 该字段与keywords字段组合进行检索。
 支持多个分类，如美食和酒店。每个分类对应数组中一个元素
 */
@property (nonatomic, copy) NSArray<NSString *> *tags;
/// 检索中心点的经纬度，必选
@property (nonatomic, assign) CLLocationCoordinate2D location;
/**
 检索半径，可选，单位是米。
 当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
 */
@property (nonatomic, assign) NSInteger radius;
/**
 是否严格限定召回结果在设置检索半径范围内。默认值为false。
 值为true代表检索结果严格限定在半径范围内；值为false时不严格限定。
 注意：值为true时会影响返回结果中total准确性及每页召回poi数量，我们会逐步解决此类问题。
 */
@property (nonatomic, assign) BOOL isRadiusLimit;
/// 检索结果详细程度
@property (nonatomic, assign) BMKPOISearchScopeType scope;
/// 检索过滤条件。scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
@property (nonatomic, strong) BMKPOISearchFilter *filter;
/// 分页页码，默认为0,0代表第一页，1代表第二页，以此类推
@property (nonatomic, assign) NSInteger pageIndex;
/// 单次召回POI数量，默认为10条记录，最大返回20条。
@property (nonatomic, assign) NSInteger pageSize;
@end


#pragma mark - POI矩形区域检索参数信息类
/// POI矩形区域检索参数信息类
@interface BMKPOIBoundSearchOption : NSObject
/**
 检索关键字，必选。
 在矩形检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
 最多支持10个关键字。
 */
@property (nonatomic, copy) NSArray<NSString *> *keywords;
/**
 检索分类，可选。
 该字段与keywords字段组合进行检索。
 支持多个分类，如美食和酒店。每个分类对应数组中一个元素
 */
@property (nonatomic, copy) NSArray<NSString *> *tags;
/// 矩形检索区域的左下角经纬度坐标，必选
@property (nonatomic, assign) CLLocationCoordinate2D leftBottom;
/// 矩形检索区域的右上角经纬度坐标，必选
@property (nonatomic, assign) CLLocationCoordinate2D rightTop;
/// 检索结果详细程度
@property (nonatomic, assign) BMKPOISearchScopeType scope;
/// 检索过滤条件。scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
@property (nonatomic, strong) BMKPOISearchFilter *filter;
/// 分页页码，默认为0,0代表第一页，1代表第二页，以此类推
@property (nonatomic, assign) NSInteger pageIndex;
/// 单次召回POI数量，默认为10条记录，最大返回20条。
@property (nonatomic, assign) NSInteger pageSize;
@end


#pragma mark - POI详情检索参数信息类
/// POI详情检索信息类
@interface BMKPOIDetailSearchOption : NSObject
/// POI的唯一标识符集合，必选
@property (nonatomic, copy) NSArray<NSString *> *poiUIDs;
/// 检索结果详细程度
@property (nonatomic, assign) BMKPOISearchScopeType scope;
@end


#pragma mark - POI室内检索参数信息类
/// 室内POI检索参数信息类
@interface BMKPOIIndoorSearchOption : NSObject
/// 室内检索唯一标识符，必选
@property (nonatomic, copy) NSString *indoorID;
/// 室内检索关键字，必选
@property (nonatomic, copy) NSString *keyword;
/// 楼层（可选），设置后，会优先获取该楼层的室内POI，然后是其它楼层的。如“F3”,"B3"等。
@property (nonatomic, copy) NSString *floor;
/// 分页页码，默认为0,0代表第一页，1代表第二页，以此类推
@property (nonatomic, assign) NSInteger pageIndex;
/// 单次召回POI数量，默认为10条记录，最大返回20条。
@property (nonatomic, assign) NSInteger pageSize;
@end
