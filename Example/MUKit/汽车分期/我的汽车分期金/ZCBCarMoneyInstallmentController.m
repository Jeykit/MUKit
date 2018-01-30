//
//  ZCBCarMoneyInstallmentController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarMoneyInstallmentController.h"
#import "ZCBCarMoneyInstallmentCell.h"

@interface ZCBCarMoneyInstallmentController ()
@property (strong ,nonatomic) NSMutableArray *modelArray;
@end

static NSString * const cellReusedIdentifier = @"cell";
@implementation ZCBCarMoneyInstallmentController

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    [self TTTitle:@"我的装修金分期" textColor:[UIColor whiteColor] isShimmering:NO];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight = 120.;
//    self.tableView.backgroundColor = TTGrayColor(241);
//    [self.tableView registerNib:[UINib nibWithNibName:@"ZCBCarMoneyInstallmentCell" bundle:nil] forCellReuseIdentifier:cellReusedIdentifier];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
//
//    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)getData{
    [BSSCModel POSTResultWithPath:@"m=Api&c=Consumer&a=myCatalogueg" Params:^(BSSCParms *ParmsModel) {
        
    } success:^(BSSCModel *model, NSMutableArray<BSSCModel *> *modelArr, id responseObject) {
        
//        self.modelArray = model.stagesList;
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
    ZCBCarMoneyInstallmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusedIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BSSCModel *model =  self.modelArray[indexPath.row];
    [self.navigationController WillPushViewController:@"ZCBCarMoneyInstallmentDetailController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
        [dict addEntriesFromDictionary:@{@"model":model}];
    } callback:nil jumpError:nil];
}
 */

@end
