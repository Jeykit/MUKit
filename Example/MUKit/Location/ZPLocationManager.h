//
//  ZPLocationManager.h
//  ZPApp
//
//  Created by Jekity on 2018/8/13.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@interface ZPLocationManager : NSObject
//是否开启后台定位 默认为NO
@property (nonatomic, assign) BOOL isBackGroundLocation;

//isBackGroudLocation为YES时，设置LocationInterval默认为1分钟
@property (nonatomic, assign) NSTimeInterval locationInterval;

//返回定位地址
@property (nonatomic, copy) void (^locationCallback) (NSString *result);



//通过单例创建
+ (ZPLocationManager *)sharedLocationManager;

//开始定位
- (void)startLocationService;

//停止定位
- (void)stopLocationService;

@end
