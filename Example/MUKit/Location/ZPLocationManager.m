//
//  ZPLocationManager.m
//  ZPApp
//
//  Created by Jekity on 2018/8/13.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "ZPLocationManager.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface ZPLocationManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, assign) NSTimeInterval nowLocationTime;
@property (nonatomic, assign) NSTimeInterval lastLocationTime;
@property (nonatomic) NSTimer *backGroundLocationTime;
@property (nonatomic) NSTimer *restartTime;

//@property (nonatomic) YZBackgroundTaskManager *bgTask;
@property (nonatomic, readwrite) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic, copy, readwrite) NSString *lastGeocoderAddress;
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,strong)  BMKReverseGeoCodeSearchOption *reversegeoCode ;
@end

//为iOS8定位
static CLLocationManager *clLocationManager;
@implementation ZPLocationManager

#pragma mark - Lifecycle (生命周期)

+ (ZPLocationManager *)sharedLocationManager{
    static ZPLocationManager *LocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LocationManager = [[self alloc]init];
    });
    return LocationManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.locationService = [[BMKLocationService alloc]init];
        BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        geoCodeSearch.delegate = self;
        BMKReverseGeoCodeSearchOption *reversegeoCode = [[BMKReverseGeoCodeSearchOption alloc]init];
        _reversegeoCode = reversegeoCode;
        self.geoCodeSearch = geoCodeSearch;
        clLocationManager = [[CLLocationManager alloc]init];
        
       BMKMapManager* _mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [_mapManager start:@"ZwltVKGkOBRUyjMasANAZbkW0R5h9G3o" generalDelegate:nil];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
    }
    return self;
}

- (void)dealloc{
    [self.restartTime invalidate];
    self.restartTime = nil;
    [self.backGroundLocationTime invalidate];
    self.backGroundLocationTime = nil;
}

- (void)setIsBackGroundLocation:(BOOL)isBackGroundLocation{
    _isBackGroundLocation = isBackGroundLocation;
    if (isBackGroundLocation) {
        self.locationInterval = 60;
        self.locationService.pausesLocationUpdatesAutomatically = NO;
        if (@available(iOS 9.0, *)) {
            self.locationService.allowsBackgroundLocationUpdates = YES;
        }
    }
    else{
        self.locationInterval = 0;
        self.locationService.pausesLocationUpdatesAutomatically = YES;
      if (@available(iOS 9.0, *)) {
            self.locationService.allowsBackgroundLocationUpdates = NO;
        }
    }
}
- (void)setLocationInterval:(NSTimeInterval)locationInterval{
    if (locationInterval!=0) {
        NSAssert(self.isBackGroundLocation, @"isBackGroundLocation为NO");
        //        NSParameterAssert(self.isBackGroundLocation); //如果isBackGroundLocation为NO 将会报错
    }
    _locationInterval = locationInterval;
    
    if (self.backGroundLocationTime) {
        [self.backGroundLocationTime invalidate];
        self.backGroundLocationTime = nil;
    }
}

- (void)startLocationService{
    
    self.nowLocationTime = [[NSDate date] timeIntervalSince1970];
    
    //当前时间和最后一次时间相差大于8秒 将重新开启定位 否则返回最近一次定位坐标
    if (self.nowLocationTime - self.lastLocationTime > 8) {
        if (![self _checkCLAuthorizationStatus]) {
            return;
        }
        self.locationService.delegate = self;
        [self.locationService startUserLocationService];
    }

}

- (void)stopLocationService{
    
    if (self.backGroundLocationTime) {
        [self.backGroundLocationTime invalidate];
        self.backGroundLocationTime = nil;
    }
    if (self.restartTime) {
        [self.restartTime invalidate];
        self.restartTime = nil;
    }
    self.locationService.delegate = nil;
    [self.locationService stopUserLocationService];
    
}

#pragma mark - Private (私有方法)
- (void)restartLocationUpdates{
    NSLog(@"重启定位服务");
    if (self.restartTime) {
        [self.restartTime invalidate];
        self.restartTime = nil;
    }
    [self startLocationService];
}



//检测是否打开定位
- (BOOL)_checkCLAuthorizationStatus{
    if ([CLLocationManager locationServicesEnabled] == NO){
        return NO;
    }else{
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            return NO;
        }
        return YES;
    }
}

- (void)applicationEnterBackground{
    
    if (self.isBackGroundLocation) {
        
        if (@available(iOS 8.0 ,*)) {
            [clLocationManager requestAlwaysAuthorization];
        }
        [self startLocationService];
    }
}


#pragma mark - Protocol conformance (协议代理)
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    self.lastLocationTime = [[NSDate date] timeIntervalSince1970];
    
    self.lastCoordinate = userLocation.location.coordinate;
 

    [self reverseGeoCodeCoordinate:self.lastCoordinate];
    
    
    [self stopLocationService];
    
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    
    if (self.locationCallback){
        self.locationCallback(@"");
    }
}

- (void)reverseGeoCodeCoordinate:(CLLocationCoordinate2D)coordinate{
 
 
    BMKGeoCodeSearch *geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    geoCodeSearch.delegate = self;
    BMKReverseGeoCodeSearchOption *reversegeoCode = [[BMKReverseGeoCodeSearchOption alloc]init];
    reversegeoCode.location = coordinate;
    reversegeoCode.isLatestAdmin = YES;
    BOOL flag = [geoCodeSearch reverseGeoCode:reversegeoCode];
    if (flag) {
        NSLog(@"反检索成功");
    }
    else
    {
        NSLog(@"反检索失败");
    }
    
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    NSString *address = @"";
    NSString *detail = @"";
    if (error == BMK_SEARCH_NO_ERROR) {
        self.lastGeocoderAddress = result.address;
        address = [NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.country,result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
        detail = result.sematicDescription;
    }
    else{
        self.lastGeocoderAddress = @"未知位置";
    }
    if (self.locationCallback){
        if (address.length >0) {
            
            NSDictionary *dict = @{@"lng":@(self.lastCoordinate.longitude),@"lat":@(self.lastCoordinate.latitude),@"addr":address,@"describe":detail};
            address= [NSString dictionaryToJson:dict];
            NSLog(@"定位=====%@",address);
        }
        self.locationCallback(address);
    }
  
}
@end
