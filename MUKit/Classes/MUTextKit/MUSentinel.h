//
//  MUSentinel.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 14/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSentinel : NSObject
@property (nonatomic,readonly)int32_t value;
-(int32_t)increase;
@end
