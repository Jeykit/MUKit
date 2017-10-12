//
//  MUKitDemoViewController.m
//  MUKit
//
//  Created by Jeykit on 08/17/2017.
//  Copyright (c) 2017 Jeykit. All rights reserved.
//

#import "MUKitDemoViewController.h"
#import "MUViewController.h"
#import "MUTranslucentController.h"
#import "MUKitDemoView.h"
#import "MUPasswordView.h"
#import "MUPaymentStyleManager.h"
#import "MUSinglePaymentView.h"
#import "MUSwitchView.h"
#import "ZCHBSellerLoginController.h"
#import <MUPopupController.h>
#import <MUNavigation.h>


@interface MUKitDemoViewController ()

@end

@implementation MUKitDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//     self.barBackgroundColorMu = [UIColor yellowColor];
//    self.barHiddenMu = YES;
    self.barAlphaMu  = 0.8;
//    self.barShadowImageHiddenMu = YES;
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"Signal";
    self.view.clickSignalName = @"view";
    NSLog(@"======%@",NSStringFromClass([self.view.viewController class]));
    

}
Click_MUNavigationBarItemWithTitle(123){
    
}
Click_MUSignal(view){
   
//    [self.navigationController pushViewController:[NSClassFromString(@"ZCHBSellerLoginController") new] animated:YES];
    
//    MUSwitchView * switchView = [[MUSwitchView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220.) count:0];
//    MUTranslucentController *controller = [[MUTranslucentController alloc]initWithCustomView:switchView];
//    switchView.firstModelArray = @[@"1",@"2",@"3",@"4",@"5"];
//    __weak typeof(switchView)weakSelf = switchView;
//    switchView.firstRenderBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//        
//        cell.textLabel.text = model;
//    };
//   switchView.firstSelectedBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//      NSLog(@"%@",model);
//       [weakSelf goForward];
//       
//   };
//    
//    
//    switchView.secondModelArray = @[@"1",@"2",@"3",@"4",@"5"];
//    switchView.secondRenderBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//        
//        cell.textLabel.text = model;
//    };
//    switchView.secondSelectedBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//        NSLog(@"%@",model);
//        [weakSelf back];
//        
//    };
//    [self presentViewController:controller animated:YES completion:^{
//        
//        controller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
//    }];
    
//    [MUPaymentStyleManager paymentStyleOnlySupportSingleView:@[@"1",@"2",@"3",@"4",@"5"] render:^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//        
//         cell.textLabel.text = model;
//    } selected:^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//        
//         NSLog(@"%@",model);
//    }];
//    MUSinglePaymentView *singleView = [[MUSinglePaymentView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 220.) data:@[@"1",@"2",@"3",@"4",@"5"]];
//    
//    MUTranslucentController *controller = [[MUTranslucentController alloc]initWithCustomView:singleView];
//    [self presentViewController:controller animated:YES completion:^{
//        
//        controller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
//    }];
//    
//   singleView.renderBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//       
//       cell.textLabel.text = model;
//   };
//    singleView.selectedBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath, id model) {
//        
//        NSLog(@"%@",model);
//    };
//    [MUPaymentStyleManager paymentStyleOnlySupportPassword:^(NSString *text, MUPasswordView *passwordwordView) {
//        NSLog(@"password=%@",text);
//        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * 5 * NSEC_PER_SEC);
//        dispatch_after(time, dispatch_get_main_queue(), ^(void){
//           
//             dispatch_time_t time1 = dispatch_time(DISPATCH_TIME_NOW, 0.8 * 5 * NSEC_PER_SEC);
//            passwordwordView.paying = YES;
//            dispatch_after(time1, dispatch_get_main_queue(), ^(void){
//                
//                passwordwordView.donePayment = YES;
//                [MUPaymentStyleManager paymentPushViewController:@"MUKitTestController" parameters:nil];
//            });
//        });
//        
//       
//    } forgotPassword:^(NSString *text) {
//        
//         NSLog(@"forgotPassword=%@",text);
//    }];
    
//    MUPopupController *popupController = [[MUPopupController alloc] initWithRootViewController:[MUViewController new]];
//    popupController.containerView.layer.cornerRadius = 4;
////    if (NSClassFromString(@"UIBlurEffect")) {
////        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
////        popupController.backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
////        popupController.backgroundView.alpha = 0.5; // This is not necessary
////    }
//    popupController.style = MUPopupStyleFormSheet;
////    popupController.style = MUPopupStyleBottomSheet;
//    [popupController presentInViewController:self];
    [self.navigationController pushViewController:[NSClassFromString(@"MUViewController") new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
