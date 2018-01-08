//
//  MUKitDemoQRCodeScanController.m
//  MUKit
//
//  Created by Jekity on 2017/10/19.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoQRCodeScanController.h"
#import "MUNavigation.h"
#import "MUQRCodeScanTool.h"

@interface MUKitDemoQRCodeScanController ()
@property(nonatomic, strong)MUQRCodeScanTool *QRCodeScanView;
@end

@implementation MUKitDemoQRCodeScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QRCodeScan";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarTranslucentMu = YES;
    self.titleColorMu = [UIColor blueColor];
    _QRCodeScanView = [[MUQRCodeScanTool alloc]initWithFrame:self.view.frame backgroundImage:[UIImage imageNamed:@"scanscanBg"] scanlineImage:[UIImage imageNamed:@"scanLine"]];
    _QRCodeScanView.backgroundColor = [UIColor blackColor];
//    _QRCodeScanView.backgroundImage = [UIImage imageNamed:@"scanscanBg"];
//    _QRCodeScanView.scanlineImage   = [UIImage imageNamed:@"scanLine"];
    _QRCodeScanView.tipsString      = @"将二维码放入框内 即可自动扫描";
    [self.view addSubview:_QRCodeScanView];
    
    [_QRCodeScanView startScanning];
    _QRCodeScanView.QRCodeScanedResult = ^(NSArray<AVMetadataMachineReadableCodeObject *> *result, NSString *resultString) {
        
         NSLog(@"扫描结果====%@",resultString);
    };
    
}

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
