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
#import <MUPaperBaseView.h>
#import "TopTabView.h"

@interface MUKitTestController ()
@property(nonatomic, strong)MUCarouselView *carouselView;
@property(nonatomic, strong)MUPaperBaseView *pageView;

@end


#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation MUKitTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.clickSignalName = @"page";
    self.title = @"page";
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageView = [[MUPaperBaseView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) WithTopTabType:1];
    self.pageView.blockHeight = 44.;
    self.pageView.titlesFont = 18.;
    self.pageView.titleScale = 1;
    self.pageView.bottomLineHeight = 4.;
    self.pageView.cornerRadiusRatio = 4.;
    self.pageView.slideEnabled = YES;
    self.pageView.defaultPage = 0;
//    self.pageView.autoFitTitleLine = YES;
    self.pageView.fontSizeAutoFit = YES;
    [self.view addSubview:self.pageView];
    self.pageView.normalColor = [UIColor blueColor];
    self.pageView.tabbarHeight = 44.;
    self.pageView.underlineOrBlockColor = [UIColor cyanColor];
    self.pageView.highlightedColor = [UIColor purpleColor];
//    self.pageView.titleArray = @[@"12341",@"22341" ,@"324" ,@"412",@"5324",@"53435",@"32543"];
    self.pageView.titleArray = [self changeTopArray];
    
    __weak typeof(self)weakSelf = self;
    self.pageView.changedBlock = ^(NSUInteger previous, NSUInteger selcted) {
        
        NSLog(@"privious ==== %ld,selected=====%ld, current===%ld",previous,selcted,weakSelf.pageView.currentPageNumber);
        
    };
//    self.pageVie
//    self.carouselView = [[MUCarouselView alloc]initWithFrame:CGRectMake(0, 98., [UIScreen mainScreen].bounds.size.width, 100)];
//    [self.view addSubview:self.carouselView];
//    self.carouselView.placeholderImage = [UIImage imageNamed:@"1024_s"];
//    // 网络图片数组
//    self.carouselView.urlImages = @[
//                       @"http://pic34.nipic.com/20131028/2455348_171218804000_2.jpg",
//                       @"http://img1.3lian.com/2015/a2/228/d/129.jpg",
//                       @"http://img.boqiicdn.com/Data/Bbs/Pushs/img79891399602390.jpg",
//                       @"http://sc.jb51.net/uploads/allimg/150703/14-150F3164339355.jpg",
//                       @"http://img1.3lian.com/2015/a2/243/d/187.jpg",
//                       @"http://pic7.nipic.com/20100503/1792030_163333013611_2.jpg",
//                       @"http://www.microfotos.com/pic/0/90/9023/902372preview4.jpg",
//                       @"http://pic1.win4000.com/wallpaper/b/55b9e2271b119.jpg"
//                       ];
  
}
//Click_MUSignal(view){
//    [MUPaymentStyleManager paymentDismissController];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *)changeTopArray {
    return @[
             [[TopTabView alloc] initWithLeftImageName:@"bank" WithRightTitle:@"bank" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"clock" WithRightTitle:@"clock" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"cup" WithRightTitle:@"cup" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"heart" WithRightTitle:@"heart" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"lab" WithRightTitle:@"lab" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"like" WithRightTitle:@"like" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"data" WithRightTitle:@"data" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"tv" WithRightTitle:@"tv" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"display" WithRightTitle:@"pc" WithTitleColor:UIColorFromRGB(0x333333)],
             ];
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
