//
//  ZCBHomeDecorationMoneyApplyDeatilCell.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBHomeDecorationMoneyApplyDeatilCell.h"


@interface ZCBHomeDecorationMoneyApplyDeatilCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;



@end
@implementation ZCBHomeDecorationMoneyApplyDeatilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
