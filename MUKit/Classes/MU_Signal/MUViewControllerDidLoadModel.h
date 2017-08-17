//
//  MUViewControllerDidLoadModel.h
//  e联盟商家
//
//  Created by Jekity on 3/11/16.
//  Copyright © 2016年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUViewControllerDidLoadModel : NSObject

@property (nonatomic,strong)NSHashTable *hashTabel;

+(instancetype)sharedInstance;
@end
