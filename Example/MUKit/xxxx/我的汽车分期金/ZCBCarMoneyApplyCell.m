//
//  ZCBCarMoneyApplyCell.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarMoneyApplyCell.h"



@interface ZCBCarMoneyApplyCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation ZCBCarMoneyApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(void)setModel:(BSSCModel *)model{
//    _model = model;
//    _moneyLabel.text = [NSString stringWithFormat:@"%@元",model.money];
//    _dateLabel.text = [NSString timeWithTimeIntervalString:model.add_time Format:@"yyyy-MM-dd"];
//    if (model.typeName) {
//        _statusLabel.text = [NSString stringWithFormat:@"%@ 》",model.typeName];
//    }
//    switch ([model.schedule_sataus integerValue]) {
//        case 0:
//            _statusLabel.textColor = [UIColor orangeColor];
//            break;
//        case 1:
//            _statusLabel.textColor = [UIColor blueColor];
//            break;
//        case 2:
//            _statusLabel.textColor = [UIColor redColor];
//            break;
//        case 3:
//            _statusLabel.textColor = [UIColor purpleColor];
//            break;
//        case 4:
//            _statusLabel.textColor = [UIColor grayColor];
//            break;
//        default:
//            break;
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
