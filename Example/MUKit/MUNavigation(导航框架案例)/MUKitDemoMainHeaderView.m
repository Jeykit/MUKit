//
//  MUKitDemoMainHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoMainHeaderView.h"
#import <UIView+MUNormal.h>


@interface MUKitDemoMainHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;

@end

@implementation MUKitDemoMainHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.button1 setMUCornerRadius:49.*.125 borderWidth:1. borderColor:[UIColor blueColor]];
    [self.button2 setMUCornerRadius:49.*.125 borderWidth:1. borderColor:[UIColor blackColor]];
    self.button3.cornerRadius_Mu = 49.*.125;
    self.button4.cornerRadius_Mu = 49.*.125;
    self.button5.cornerRadius_Mu = 49.*.125;
    self.button6.cornerRadius_Mu = 49.*.125;
}

@end
