//
//  MUKitDemoMVVMCollectionViewCell.m
//  MUKit
//
//  Created by Jekity on 2017/8/22.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoMVVMCollectionViewCell.h"
#import "MUTempModel.h"
@interface MUKitDemoMVVMCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation MUKitDemoMVVMCollectionViewCell
-(void)setModel:(MUTempModel *)model{
    _model = model;
    _label.text = model.name;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
