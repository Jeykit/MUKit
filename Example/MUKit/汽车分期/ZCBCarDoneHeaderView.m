//
//  ZCBCarDoneHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarDoneHeaderView.h"


@interface ZCBCarDoneHeaderView ()


@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;


@end

@implementation ZCBCarDoneHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
//    [self.viewButton setCornerRadius:10.];
//    [self.homeButton setCornerRadius:10 borderWidth:1 borderColor:[UIColor redColor]];
}

@end
