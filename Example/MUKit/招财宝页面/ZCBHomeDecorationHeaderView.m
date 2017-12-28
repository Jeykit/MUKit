//
//  ZCBHomeDecorationHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBHomeDecorationHeaderView.h"

@interface ZCBHomeDecorationHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;



@end

@implementation ZCBHomeDecorationHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self updateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
