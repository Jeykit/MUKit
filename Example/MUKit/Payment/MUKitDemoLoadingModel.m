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
        
      self.weChatPayID     = @"wx7163dbd76eac21a9";
      self.weChatPayScheme = @"wx7163dbd76eac21a9";
    }
    return self;
}
@end
