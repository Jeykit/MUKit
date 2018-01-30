//
//  ZCBCarController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarController.h"
#import "ZCBCarHeaderView.h"
//#import "wxx_web_ViewController.h"
#import "ZCBCarNumberView.h"


@interface ZCBCarController ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property(nonatomic, strong)ZCBCarHeaderView *headerView;
@end

@implementation ZCBCarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self TTTitle:@"装修贷款" textColor:[UIColor whiteColor] isShimmering:NO];
//    self.headerView = [ZCBCarHeaderView ViewFromXib];
//    self.headerView.mj_w = hScreenWidth;
//    self.headerView.AutoWidth = hScreenWidth;
    self.tableview.tableHeaderView = self.headerView;
//    self.tableview.backgroundColor = TTGrayColor(245);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self TTRightBarTitle:@"我的装修金" textColor:[UIColor whiteColor]];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
   
    
}
/*
Click_signal(numberButton){

    ZCBCarNumberView *addressView = [ZCBCarNumberView sharedInstance];
//    addressView.resultBlock = ^(NSString *string) {
//        normalize(self)
//        self.headerView.moneyLabel.text = string;
//    };
    [addressView showPickerView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    White_StatusBar;
     [self TTNVDefaultBarWithImg:[UIImage imageWithColor:TTZCBIconRed] bindScrollView:self.tableview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
TTRightClick{
    
    [self.navigationController WillPushViewController:@"ZCBCarMoneyController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
        
        
    } callback:nil jumpError:nil];
}

Click_signal(applyButton){
    

   
    if (self.headerView.textField.text.length < 11) {
        CommonProgressShowTip(@"请输入正确手机号码");
        return;
    }else{
         [self uploadData:self.headerView.textField.text];
    }
    
}
-(void)uploadData:(NSString *)mobile{
    [BSSCModel POSTResultWithPath:@"m=Api&c=User&a=checkUser" Params:^(BSSCParms *ParmsModel) {
        ParmsModel.mobile = mobile;
    } success:^(BSSCModel *model, NSMutableArray<BSSCModel *> *modelArr, id responseObject) {
        
        [self.navigationController WillPushViewController:@"ZCBCarRealEstateInfomationController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
            [dict addEntriesFromDictionary:@{@"contract_url":self.headerView.model.contract_url,@"phone":self.headerView.textField.text,@"money":self.headerView.moneyLabel.text}];
        } callback:nil jumpError:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}*/
@end
