//
//  MUKitDemoViewController.m
//  MUKit
//
//  Created by Jeykit on 08/17/2017.
//  Copyright (c) 2017 Jeykit. All rights reserved.
//

#import "MUKitDemoViewController.h"

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

Click_signal(view){
    
    [self.navigationController pushViewController:[NSClassFromString(@"MUViewController") new] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
