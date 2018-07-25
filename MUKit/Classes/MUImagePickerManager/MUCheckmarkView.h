//
//  MUCheckmarkView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/8.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MUCheckmarkView : UIView

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat checkmarkLineWidth;

@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *bodyColor;
@property (nonatomic, strong) IBInspectable UIColor *checkmarkColor;
@end
