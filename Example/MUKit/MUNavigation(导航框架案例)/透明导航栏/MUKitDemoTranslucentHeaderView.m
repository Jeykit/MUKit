//
//  MUKitDemoTranslucentHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoTranslucentHeaderView.h"

@implementation MUKitDemoTranslucentHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.scaleImageView.image = [UIImage imageFromColorMu:[UIColor colorWithHexString:@"#FA19E1"]];
}

@end
