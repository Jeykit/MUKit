//
//  MUKitDemoNetworkingController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/12.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoNetworkingController.h"
#import "MUKitDemoNetworkingHeaderViews.h"

@interface MUKitDemoNetworkingController ()

@property (nonatomic,strong) MUKitDemoNetworkingHeaderViews *headerView;
@end

@implementation MUKitDemoNetworkingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MUNetworking";
    self.navigationBarTintColor = [UIColor whiteColor];
    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor colorWithHexString:@"#767F90"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [MUKitDemoNetworkingHeaderViews viewForXibNOMargainMuWithRetainObject:self];
    self.tableView.backgroundColor = [UIColor colorWithRed:242./255. green:242./255. blue:242./255. alpha:1.];
    [MUModel GlobalStatus:nil networkingStatus:^(NSUInteger status) {
        if (status == 404) {//
           
        }
    }];
    [MUModel GlobalConfigurationWithModelName:@"MUModel" parameterModel:@"MUParaModel" domain:@"http://room.api.zp365.com/" Certificates:nil dataFormat:@{@"Success":@"Success",@"Status":@"ret",@"Data":@"Content",@"Message":@"Result"}];
   [MUModel requestHeader:@{@"UserType":@"0"}];
}
//模型数据
Click_MUSignal(button1){
    [MUModel GET:@"api/OpenActivity/GetOpenActivityInfo" parameters:^(MUParaModel *parameter) {
        parameter.ID = @"17";
    } success:^(MUModel *model, NSArray<MUModel *> *modelArray, id responseObject) {
        
        self.headerView.textView1.text = [NSString stringWithFormat:@"id:%@\n\nNewHouseName:%@\n\nNewHouseAddr:%@\n\nActivityName:%@\n\nStartTime:%@\n\nEndTime:%@\n",model.id,model.NewHouseName,model.NewHouseAddr,model.ActivityName,model.StartTime,model.EndTime];
        self.headerView.textview2.text = [NSString dictionaryToJson:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg) {
       
    }];
}
//模型数组
Click_MUSignal(button2){
    [MUModel GET:@"api/OpenActivity/GetOpenActivityListByApp" parameters:^(MUParaModel *parameter) {
        
    } success:^(MUModel *model, NSArray<MUModel *> *modelArray, id responseObject) {
        
        NSString *resultString = @"";
        for (MUModel *tempModel in modelArray) {
            resultString = [NSString stringWithFormat:@"%@aid:%@\nActivityName:%@\n\n",resultString,tempModel.aid,tempModel.ActivityName];
        }
       self.headerView.textView1.text = resultString;
       self.headerView.textview2.text = [NSString dictionaryToJson:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg) {
    }];
}
@end
