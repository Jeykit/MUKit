//
//  ZCBCarMoneyApplyDeatilCell.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarMoneyApplyDeatilCell.h"


@interface ZCBCarMoneyApplyDeatilCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;



@end
@implementation ZCBCarMoneyApplyDeatilCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(NSDictionary *)model{
    _model = model;
    _dateLabel.text = model[@"date"];
   
   
    _informationLabel.text = model[@"title"];
    if ([model[@"sataus"] integerValue] == 1) {
//        _informationLabel.textColor = [UIColor redColor];
        _iconImageView.image = [UIImage imageNamed:@"zh_icon_23"];
        switch (self.schedule_sataus) {
            case 0:
                _iconImageView.image = [UIImage imageNamed:@"zh_icon_23"];
                _informationLabel.textColor = [UIColor colorWithRed:22./255. green:156./255. blue:85./255. alpha:1.];
                break;
            case 1:
                _iconImageView.image = [UIImage imageNamed:@"zh_icon_23"];
                _informationLabel.textColor = [UIColor colorWithRed:22./255. green:156./255. blue:85./255. alpha:1.];
                break;
            case 2:
                _iconImageView.image = [UIImage imageNamed:@"zh_icon_23"];
                _informationLabel.textColor = [UIColor redColor];
                break;
            default:
                break;
        }
    }else{
          _informationLabel.textColor = [UIColor grayColor];
        _iconImageView.image = [UIImage imageNamed:@"zh_icon_24"];
    }
}
-(void)setLast:(BOOL)last{
    _last = last;
    _lineView.hidden = last;
}
@end
