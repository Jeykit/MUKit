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
@interface MUKitDemoViewController ()

@end

@implementation MUKitDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Signal";
    self.view.clickSignalName = @"view";
    self.view.backgroundColor = [UIColor redColor];
}
Click_MUSignal(view){
    
    
//    self.definesPresentationContext = YES;
//    MUViewController *viewcontroller = [[MUViewController alloc]init];
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:viewcontroller];
//    viewcontroller.view.backgroundColor = [UIColor clearColor];
//    navi.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self.navigationController presentViewController:navi animated:YES completion:^{
//        
//        [UIView animateWithDuration:0.4 animations:^{
//            
//            viewcontroller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//        }];
//    }];
    
    MUKitDemoView *temp = [[MUKitDemoView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400.)];
    MUTranslucentController *controller = [[MUTranslucentController alloc]initWithCustomView:temp];
    controller.leftImage = [UIImage imageNamed:@"MUKit.bundle/refresh_arrow.png"];
    [self presentViewController:controller animated:YES completion:^{
        [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            controller.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        } completion:^(BOOL finished) {
            
            
        }];
       
        
    }];
//    [self.navigationController presentViewController:viewcontroller animated:YES completion:nil];
//     viewcontroller.preferredContentSize =CGSizeMake(100, 200);
//    viewcontroller.view.superview.frame = CGRectMake(0, 0, 512, 374);
//    viewcontroller.view.superview.center = self.view.center;
//    [self.navigationController pushViewController:[NSClassFromString(@"MUViewController") new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
