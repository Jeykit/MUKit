//
//  ZCBHomeDecorationMoneyInstallmentCell.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBHomeDecorationMoneyInstallmentCell.h"


@interface ZCBHomeDecorationMoneyInstallmentCell ()

@property (weak, nonatomic) IBOutlet UILabel *installmentLable;

@property (weak, nonatomic) IBOutlet UILabel *loanMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *paymentLbale;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (weak, nonatomic) IBOutlet UILabel *statusLable;

@end
@implementation ZCBHomeDecorationMoneyInstallmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
