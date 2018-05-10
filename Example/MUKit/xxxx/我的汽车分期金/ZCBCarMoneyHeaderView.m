//
//  ZCBCarMoneyHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarMoneyHeaderView.h"

@interface ZCBCarMoneyHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UIView *decorationView;
@property (weak, nonatomic) IBOutlet UIView *installmentView;


@end

@implementation ZCBCarMoneyHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
//    [self getData];
}
//-(void)getData{
//    [BSSCModel POSTResultWithPath:@"m=Api&c=Consumer&a=mygold" Params:^(BSSCParms *ParmsModel) {
//
//    } success:^(BSSCModel *model, NSMutableArray<BSSCModel *> *modelArr, id responseObject) {
//
//        _balanceLabel.text = [NSString stringWithFormat:@"%@", [NSString decimalStringWithNumber:responseObject[@"result"][@"gold"][@"gold"]]];
//
//    } failure:^(NSError *error) {
//
//    }];
//
//}
@end
