//
//  MUEmotionModel.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface MUEmotionModel : NSObject <YYModel>
@property (nonatomic, copy) NSString *face_name;

@property (nonatomic, copy) NSString *face_id;

@property (nonatomic, copy) NSString *code;
@end
