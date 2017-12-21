//
//  MUAuthorizationStatusController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/19.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUAuthorizationStatusController.h"

@interface MUAuthorizationStatusController ()
@property(nonatomic, strong)UILabel *textLabel;
@end

@implementation MUAuthorizationStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册权限未开启";
    self.textLabel = [UILabel new];
    self.textLabel.text = @"请在系统设置中开启相册授权服务\n(设置>隐私>照片>开启)";
    self.textLabel.numberOfLines = 0;
    [self.textLabel sizeToFit];
    [self.view addSubview:self.textLabel];
    self.textLabel.center = CGPointMake(self.view.center.x, self.view.center.y*.62);
    
    [self rightBarButtonItem];
}
-(void)rightBarButtonItem{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44., 44.)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mu_rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mu_rightButtonClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
