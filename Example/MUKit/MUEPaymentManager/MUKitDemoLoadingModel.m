//
//  MUKitDemoLoadingModel.m
//  MUKit
//
//  Created by Jekity on 2017/8/25.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoLoadingModel.h"

@implementation MUKitDemoLoadingModel
-(instancetype)init{
    
    if (self = [super init]) {
      self.AppDelegateName = @"MUKitDemoAppDelegate";
      self.alipayID        = @"2088811211659673";
      self.alipayScheme    = @"mualipayment";
        
      self.weChatPayID     = @"wxb29a48863b2befe4";
      self.weChatPayScheme = @"wxb29a48863b2befe4";
        
        self.QQID = @"1105500722";
        self.weiboID = @"888888888";
    }
    return self;
}
@end
