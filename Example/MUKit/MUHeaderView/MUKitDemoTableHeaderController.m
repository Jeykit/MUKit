//
//  MUKitDemoTableHeaderController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/27.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableHeaderController.h"
#import "MUKitDemoTableHeaderView.h"

@interface MUKitDemoTableHeaderController ()
@property(nonatomic, strong)MUKitDemoTableHeaderView *headerView;
@end

@implementation MUKitDemoTableHeaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Header";
    self.navigationBarTintColor = [UIColor whiteColor];
    self.titleColorMu = [UIColor whiteColor];
    self.tableView.tableHeaderView = [MUKitDemoTableHeaderView viewForXibNOMargainMuWithRetainObject:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

Click_MUSignal(button){
    
    self.headerView.heightContraint.constant += 128;
    self.headerView.height_Mu += 128.;
    [self.tableView reloadData];
}

@end
