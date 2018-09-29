//
//  BMKGeoCodeSearchOption.h
//  SearchComponent
//  本文件中包含了 正/反地理编码服务 的请求参数信息类
//  
//  Created by Baidu on 2018/5/8.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#pragma mark - GC请求参数类
/// 正地理编码参数信息类
@interface BMKGeoCodeSearchOption : NSObject
/**
 待解析的地址。必选。
 可以输入2种样式的值，分别是：
 1、标准的结构化地址信息，如北京市海淀区上地十街十号 【推荐，地址结构越完整，解析精度越高】
 2、支持“*路与*路交叉口”描述方式，如北一环路和阜阳路的交叉路口
 注意：第二种方式并不总是有返回结果，只有当地址库中存在该地址描述时才有返回。
 */
@property (nonatomic, copy) NSString *address;
/**
 地址所在的城市名。可选。
 用于指定上述地址所在的城市，当多个城市都有上述地址时，该参数起到过滤作用。
 注意：指定该字段，不会限制坐标召回城市。
 */
@property (nonatomic, copy) NSString *city;
@end


#pragma mark - RGC请求参数类
/// 反地理编码参数信息类
@interface BMKReverseGeoCodeSearchOption : NSObject
/// 待解析的经纬度坐标（必选）
@property (nonatomic, assign) CLLocationCoordinate2D location;
/// 是否访问最新版行政区划数据（仅对中国数据生效）
@property (nonatomic, assign) BOOL isLatestAdmin;
@end



