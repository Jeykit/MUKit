//
//  MUTableViewCell.h
//  elmsc
//
//  Created by zeng ping on 2017/7/7.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUBaseClass.h"

@class MUTempModel;
@interface MUTableViewCell : MUBaseTableViewCell
@property(nonatomic, strong)MUTempModel *model;
@end
