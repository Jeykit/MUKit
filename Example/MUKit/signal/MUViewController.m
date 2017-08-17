//
//  MUViewController.m
//  elmsc
//
//  Created by zeng ping on 2017/7/3.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUViewController.h"
#import "MUView.h"
@interface MUViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *sView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (weak, nonatomic) IBOutlet MUView *MUView;
@end

@implementation MUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MUView *mView = [[MUView alloc]initWithFrame:_MUView.bounds];
    [_MUView addSubview:mView];
    self.imageView.userInteractionEnabled = YES;
//    
//    //直接改变UIControl事件触发，信号名默认为控件变量名
//    self.textField.allControlEvents = UIControlEventEditingDidEnd;
//
//    //直接改变UIControl事件触发，并设置信号；信号设置与改变事件触发间无顺序
//    self.textField.allControlEvents = UIControlEventEditingDidEnd;
//    self.textField.clickSignalName  = @"text";
    
    //用链式编程设置属性，属性一样则覆盖前一个
    self.textField.setSignalName(@"text").controlEvents(UIControlEventEditingDidEnd).enforceTarget(self).controlEvents(UIControlEventEditingChanged);
    
//    self.button.clickSignalName     = @"text";
//    self.button.allControlEvents     = UIControlEventTouchDown;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_signal(sView){
     NSLog(@"2223333----------%@",NSStringFromClass([object class]));
}
Click_signal(imageView){
//    MUAliPayment *payment = [MUAliPayment sharedInstance];
//    payment.privateKey    = responseObject[@"data"];
//    payment.appScheme     = @"elmsAppScheme";
//    payment.price         = payMoney;
//    payment.tradeNumber   = order;
//    [payment excutePayment:^(NSDictionary *resultDict) {
//       
//        if ([resultDict[@"resultStatus"] intValue] == 9000) {
//           
//        }else{
//            [SVProgressHUD showErrorWithStatus:@"支付失败"];
//            //                [SVProgressHUD setMinimumDismissTimeInterval:.5];
//        }
//    }];

     NSLog(@"2223333----------%@",NSStringFromClass([object class]));
}
Click_signal(button){
    
     NSLog(@"2223333----------%@",NSStringFromClass([object class]));
    [self.navigationController pushViewController:[NSClassFromString(@"MUTableViewController") new] animated:YES];
}
Click_signal(segmented){
     NSLog(@"2223333----------%@",NSStringFromClass([object class]));
}
Click_signal(textField){
    
    
    NSLog(@"----------%@",self.textField.text);
}
Click_signal(text){
     NSLog(@"2223333----------%@",NSStringFromClass([object class]));
    NSLog(@"11112----------%@",self.textField.text);
}

Click_signal(infoView){
      NSLog(@"子视图----------%@",NSStringFromClass([object class]));
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
