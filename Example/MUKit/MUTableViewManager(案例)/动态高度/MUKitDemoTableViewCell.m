//
//  MUKitDemoTableViewCell.m
//  MUKit
//
//  Created by Jekity on 2017/8/18.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableViewCell.h"
#import "MUTempModel.h"
@interface MUKitDemoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation MUKitDemoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.userInteractionEnabled = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MUTempModel *)model{
    _model = model;
    _label.text = model.name;
}
Click_MUSignal(label){
    
    NSLog(@"=======%@",self.label.indexPath);
}
@end
