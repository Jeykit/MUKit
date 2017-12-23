//
//  SCAdDemoCollectionViewCell.m
//  SCAdViewDemo
//
//  Created by 陈世翰 on 17/2/7.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import "SCAdDemoCollectionViewCell.h"

@implementation SCAdDemoCollectionViewCell

-(void)setName:(NSString *)name{
    _name = name;
    _showImage.image = [UIImage imageNamed:name];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _showImage.layer.masksToBounds = YES;
    _showImage.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.8;
    self.bgView.layer.shadowRadius = 6.0f;
    self.bgView.layer.shadowOffset = CGSizeMake(6, 6);
    self.clipsToBounds =NO;
    self.bgView.clipsToBounds =NO;
}

@end
