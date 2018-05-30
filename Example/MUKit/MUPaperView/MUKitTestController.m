//
//  MUKitTestController.m
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitTestController.h"
#import "MUKitTestHeaderView.h"
#import "ZPWBaseTableView.h"


@interface MUKitTestController ()<UIScrollViewDelegate>


@property(nonatomic, strong)MUKitTestHeaderView *headerView;

@end


#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation MUKitTestController


-(void)loadView{
    if (iPhoneX) {
        ZPWBaseTableView *baseView = [[ZPWBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 83.) style:UITableViewStyleGrouped];
        baseView.bounces = NO;
        self.tableView             = baseView;
    }else{
        ZPWBaseTableView *baseView = [[ZPWBaseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.) style:UITableViewStyleGrouped];
        baseView.bounces = NO;
        self.tableView             = baseView;
        
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [MUKitTestHeaderView viewForXibNOMargainMuWithRetainObject:self];
    self.headerView.titleArray = [self titles];

}
//Click_MUSignal(view){
//    [MUPaymentStyleManager paymentDismissController];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSArray *)titles{
    
    return @[@"2432",@"3243"];
}



@end
