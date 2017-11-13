//
//  MUKitTestController.m
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitTestController.h"
#import "MUPaymentStyleManager.h"
#import "MUCarouselView.h"

@interface MUKitTestController ()
@property(nonatomic, strong)MUCarouselView *carouselView;
@end

@implementation MUKitTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.clickSignalName = @"view";
    self.carouselView = [[MUCarouselView alloc]initWithFrame:CGRectMake(0, 98., [UIScreen mainScreen].bounds.size.width, 100)];
    [self.view addSubview:self.carouselView];
    self.carouselView.localImages = @[@"1024_s",@"icon_store"];
}
//Click_MUSignal(view){
//    [MUPaymentStyleManager paymentDismissController];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
