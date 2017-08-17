//
//  MUTempModel.h
//  SigmaTableViewModel
//
//  Created by zeng ping on 2017/8/14.
//  Copyright © 2017年 yangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUTempModel : NSObject
@property (nonatomic ,copy)NSString *name;
-(instancetype)initWithString:(NSString *)string;
@end
