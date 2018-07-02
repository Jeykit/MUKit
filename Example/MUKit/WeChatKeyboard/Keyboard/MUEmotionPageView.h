//
//  MUEmotionPageView.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUEmotionModel.h"

#define MUEmotionMaxRows 3
#define MUEMotionMaxCols 7
#define MUEmotionPageSize ((MUEmotionMaxRows * MUEMotionMaxCols) - 1)
@interface MUEmotionPageView : UIView
@property (nonatomic, strong) NSArray *emotions;

@end
