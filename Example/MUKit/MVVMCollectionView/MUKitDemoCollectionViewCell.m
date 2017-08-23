//
//  MUKitDemoCollectionViewCell.m
//  MUKit
//
//  Created by Jekity on 2017/8/22.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoCollectionViewCell.h"
#import "MUTempModel.h"
@interface MUKitDemoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation MUKitDemoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}
-(void)setModel:(MUTempModel *)model{
    _model = model;
    self.label.text = model.name;
}
@end
