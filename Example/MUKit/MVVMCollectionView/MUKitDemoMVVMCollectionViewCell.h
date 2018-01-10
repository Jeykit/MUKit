//
//  MUKitDemoMVVMCollectionViewCell.h
//  MUKit
//
//  Created by Jekity on 2017/8/22.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUBaseClass.h"

@class MUTempModel;
@interface MUKitDemoMVVMCollectionViewCell : MUBaseCollectionViewCell
@property(nonatomic, strong)MUTempModel *model;
@end
