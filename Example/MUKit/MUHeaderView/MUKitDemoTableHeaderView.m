//
//  MUKitDemoTableHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableHeaderView.h"


@interface MUKitDemoTableHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *button;


@end

@implementation MUKitDemoTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
Click_MUSignal(button){

    UITableView *tableView = (UITableView *)self.superview;
    self.heightContraint.constant += 128;
    self.height_Mu += 128.;
    [tableView reloadData];

}
@end
