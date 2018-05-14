//
//  MUModel.h
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUNetworkingModel.h"
#import "MUParaModel.h"

@interface MUModel : MUNetworkingModel

MUNetworkingModelInitialization(MUModel,MUParaModel)


@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *Extend;
@property (nonatomic,copy) NSString *PayMoney;
@property (nonatomic,copy) NSString *adImg;
@property (nonatomic,copy) NSString *NumberHouses;
@property (nonatomic,copy) NSString *StartTime;
@property (nonatomic,copy) NSString *EndTime;
@property (nonatomic,copy) NSString *NumberPeople;
@property (nonatomic,copy) NSString *NewHouseAddr;
@property (nonatomic,copy) NSString *NewHouseDevelopers;
@property (nonatomic,copy) NSString *ActivityName;
@property (nonatomic,copy) NSString *NewHouseName;
@property (nonatomic,copy) NSString *NewHouseType;
@property (nonatomic,copy) NSString *ChooseNotice;
@property (nonatomic,copy) NSString *aid;

@end
