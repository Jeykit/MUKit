//
//  MUOverlayView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/8.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUCircleView.h"
#import "MUCheckmarkView.h"

@interface MUOverlayView : UIView
@property(nonatomic, strong)MUCircleView *circleView;
@property(nonatomic, strong)MUCheckmarkView *checkmarkView;
@property(nonatomic, strong)UIColor *tintColor;
@end
