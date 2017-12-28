//
//  ZCBHomeDecorationRealEstateInfomationHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBHomeDecorationRealEstateInfomationHeaderView.h"


@interface ZCBHomeDecorationRealEstateInfomationHeaderView()

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;

@property (weak, nonatomic) IBOutlet UIView *decorationContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decorationContentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *houseContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *houseContentViewHeightConstraint;

@end
@implementation ZCBHomeDecorationRealEstateInfomationHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
