//
//  ZCBCarMoneyApplyController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarMoneyApplyController.h"
#import "ZCBCarMoneyApplyCell.h"

@interface ZCBCarMoneyApplyController ()


@property (strong ,nonatomic) NSMutableArray *modelArray;
@end


static NSString * const cellReusedIdentifier = @"cell";

@implementation ZCBCarMoneyApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self TTTitle:@"我的装修金申请" textColor:[UIColor whiteColor] isShimmering:NO];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight = 64.;
//    [self.tableView registerNib:[UINib nibWithNibName:@"ZCBCarMoneyApplyCell" bundle:nil] forCellReuseIdentifier:cellReusedIdentifier];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [self getData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)getData{
    [BSSCModel POSTResultWithPath:@"m=Api&c=Consumer&a=myapply" Params:^(BSSCParms *ParmsModel) {
        
    } success:^(BSSCModel *model, NSMutableArray<BSSCModel *> *modelArr, id responseObject) {
        
        self.modelArray = modelArr;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZCBCarMoneyApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusedIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelArray[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BSSCModel *model =  self.modelArray[indexPath.row];
    if ([model.schedule_sataus integerValue] == 0 || [model.schedule_sataus integerValue] == 1 || [model.schedule_sataus integerValue] == 2) {
        
        [self.navigationController WillPushViewController:@"ZCBCarMoneyApplyDeatilController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
            [dict addEntriesFromDictionary:@{@"model":model}];
        } callback:nil jumpError:nil];
    }else if ([model.schedule_sataus integerValue] == 3){
        [self.navigationController WillPushViewController:@"ZCBCarMoneyUsedController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
            [dict addEntriesFromDictionary:@{@"model":model}];
        } callback:nil jumpError:nil];
    }else{
        [self.navigationController WillPushViewController:@"ZCBCarMoneyDoneController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
            [dict addEntriesFromDictionary:@{@"model":model}];
        } callback:nil jumpError:nil];
    }
}
*/
@end
