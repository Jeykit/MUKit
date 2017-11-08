//
//  MUVideoIndicatorView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/8.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUVideoIconView.h"
#import "MUSlomoIconView.h"

@interface MUVideoIndicatorView : UIView
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) MUVideoIconView *videoIcon;
@property (nonatomic, strong) MUSlomoIconView *slomoIcon;

@end
