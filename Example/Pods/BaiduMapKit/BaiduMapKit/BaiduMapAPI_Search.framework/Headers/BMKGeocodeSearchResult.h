//
//  BMKGeocodeSearchResult.h
//  SearchComponent
//
//  Created by Baidu on 2018年05月24日.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKTypes.h>

#pragma mark - RC检索结果类
/// 地址编码结果类
@interface BMKGeoCodeSearchResult : NSObject
/// 地址对应的经纬度坐标
@property (nonatomic, assign) CLLocationCoordinate2D location;
@end

#pragma mark - RGC检索结果类
/// 反地理编码结果类
@interface BMKReverseGeoCodeSearchResult : NSObject
/// 地址坐标
@property (nonatomic, assign) CLLocationCoordinate2D location;
/// 地址名称
@property (nonatomic, copy) NSString *address;
/// 商圈名称
@property (nonatomic, copy) NSString *businessCircle;
/// 层次化地址信息
@property (nonatomic, strong) BMKAddressComponent* addressDetail;
/// 地址周边POI信息，成员类型为BMKPoiInfo
@property (nonatomic, copy) NSArray *poiList;
/// 结合当前位置POI的语义化结果描述
@property (nonatomic, copy) NSString *sematicDescription;
/// 城市编码（此字段不再更新）
@property (nonatomic, copy) NSString *cityCode; __deprecated_msg("自4.1.0不再更新");
@end
