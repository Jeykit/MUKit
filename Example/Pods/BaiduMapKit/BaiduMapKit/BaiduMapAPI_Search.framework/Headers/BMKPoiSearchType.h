//
//  BMKPOISearchType.h
//  SearchComponent
//
//  Created by Baidu on 2018年05月23日.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BMKPOIDetailInfo;

enum {
    BMKInvalidCoordinate = -1,  ///<无效坐标
    BMKCarTrafficFIRST = 60,    ///<驾乘检索策略常量：躲避拥堵，若无实时路况，默认按照时间优先策略
    BMKCarTimeFirst = 0,        ///<驾乘检索策略常量：时间优先
    BMKCarDisFirst,                ///<驾乘检索策略常量：最短距离
    BMKCarFeeFirst,                ///<驾乘检索策略常量：较少费用
    BMKBusTimeFirst,            ///<公交检索策略常量：时间优先
    BMKBusTransferFirst,        ///<公交检索策略常量：最少换乘
    BMKBusWalkFirst,            ///<公交检索策略常量：最小步行距离
    BMKBusNoSubway,                ///<公交检索策略常量：不含地铁
    BMKTypeCityList = 7,        ///<POI检索类型：城市列表
    BMKTypePoiList = 11,        ///<POI检索类型：城市内搜索POI列表
    BMKTypeAreaPoiList = 21,    ///<POI检索类型：范围搜索、周边搜索POI列表
    BMKTypeAreaMultiPoiList = 45    ///<POI检索类型：多关键字范围搜索、周边搜索POI列表
};


#pragma mark - POI信息类
/// POI信息类
@interface BMKPoiInfo : NSObject
/// POI名称
@property (nonatomic, copy) NSString *name;
/// POI坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;
/// POI地址信息
@property (nonatomic, copy) NSString *address;
/// POI电话号码
@property (nonatomic, copy) NSString *phone;
/// POI唯一标识符uid
@property (nonatomic, copy) NSString *UID;
/// POI所在省份
@property (nonatomic, copy) NSString *province;
/// POI所在城市
@property (nonatomic, copy) NSString *city;
/// POI所在行政区域
@property (nonatomic, copy) NSString *area;
/// POI对应的街景图ID
@property (nonatomic, copy) NSString *streetID;
/// POI是否有详情信息
@property (nonatomic, assign) BOOL hasDetailInfo;
/// POI详情信息
@property (nonatomic, strong) BMKPOIDetailInfo *detailInfo;
@end


#pragma mark - POI详情信息类
@interface BMKPOIDetailInfo : NSObject
/// 距离中心点的距离，圆形区域检索时返回
@property (nonatomic, assign) NSInteger distance;
/// POI类型："hotel","cater","life"等
@property (nonatomic, copy) NSString *type;
/// POI标签
@property (nonatomic, copy) NSString *tag;
/// POI对应的导航引导点坐标。大型面状POI的导航引导点，一般为各类出入口，方便结合导航、路线规划等服务使用
@property (nonatomic, assign) CLLocationCoordinate2D naviLocation;
/// POI详情页URL
@property (nonatomic, copy) NSString *detailURL;
/// POI商户的价格
@property (nonatomic, assign) CGFloat price;
/// POI营业时间
@property (nonatomic, copy) NSString *openingHours;
/// POI总体评分
@property (nonatomic, assign) CGFloat overallRating;
/// POI口味评分
@property (nonatomic, assign) CGFloat tasteRating;
/// POI服务评分
@property (nonatomic, assign) CGFloat serviceRating;
/// POI环境评分
@property (nonatomic, assign) CGFloat environmentRating;
/// POI星级（设备）评分
@property (nonatomic, assign) CGFloat facilityRating;
/// POI卫生评分
@property (nonatomic, assign) CGFloat hygieneRating;
/// POI技术评分
@property (nonatomic, assign) CGFloat technologyRating;
/// POI图片数目
@property (nonatomic, assign) NSInteger imageNumber;
/// POI团购数目
@property (nonatomic, assign) NSInteger grouponNumber;
/// POI优惠数目
@property (nonatomic, assign) NSInteger discountNumber;
/// POI评论数目
@property (nonatomic, assign) NSInteger commentNumber;
/// POI收藏数目
@property (nonatomic, assign) NSInteger favoriteNumber;
/// POI签到数目
@property (nonatomic, assign) NSInteger checkInNumber;
@end


#pragma mark - 室内POI信息类
/// 室内POI信息类
@interface BMKPoiIndoorInfo : NSObject
/// POI名称
@property (nonatomic, copy) NSString *name;
/// POI唯一标识符
@property (nonatomic, copy) NSString *UID;
/// 该室内POI所在 室内ID
@property (nonatomic, copy) NSString *indoorID;
/// 该室内POI所在楼层
@property (nonatomic, copy) NSString *floor;
/// POI地址
@property (nonatomic, copy) NSString *address;
/// POI所在城市
@property (nonatomic, copy) NSString *city;
/// POI电话号码
@property (nonatomic, copy) NSString *phone;
/// POI坐标
@property (nonatomic, assign) CLLocationCoordinate2D pt;
/// POI标签
@property (nonatomic, copy) NSString *tag;
/// 价格
@property (nonatomic, assign) CGFloat price;
/// 星级（0-50），50表示五星
@property (nonatomic, assign) NSInteger starLevel;
/// 是否有团购
@property (nonatomic, assign) BOOL grouponFlag;
/// 是否有外卖
@property (nonatomic, assign) BOOL takeoutFlag;
/// 是否排队
@property (nonatomic, assign) BOOL waitedFlag;
/// 团购数,-1表示没有团购信息
@property (nonatomic, assign) NSInteger grouponNum;
/// 折扣信息FIXME
@property (nonatomic, assign) NSInteger discount;
@end
