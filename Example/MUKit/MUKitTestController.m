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
#import "MUPaperView.h"
#import <UIView+MUNormal.h>

@interface MUKitTestController ()<UIScrollViewDelegate>
@property(nonatomic, strong)MUCarouselView *carouselView;
@property(nonatomic, strong)MUPaperBaseView *pageView;
@property(nonatomic, strong)MUPaperView *ppageView;
@property(nonatomic, strong)UIScrollView *scrollView;

@end


#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation MUKitTestController
Click_MUSignal(page){
    
    self.ppageView.y_Mu = 100.;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)+200);
//    self.scrollView.delegate = self;
//    [self.view addSubview:self.scrollView];
//    self.view.clickSignalName = @"page";
//    self.title = @"page";
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.ppageView = [[MUPaperView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300) WithTopArray:[self titles] WithObjects:[self controllerArray]];
//    self.ppageView.pagerStyles = MUPagerStyleSlideBlock;
//    self.ppageView.underlineHeight = 2.;
//    self.ppageView.tipsColor = [UIColor purpleColor];
//    self.ppageView.sliderCornerRadiusRatio = 20.;
//    self.ppageView.autoFitTitleLine = YES;
//    self.ppageView.titleScale = 1.15;
////    self.ppageView.fontSizeAutoFit = YES;
////    self.ppageView.topTabHeight = 100.;
//    self.ppageView.hightlightColor = [UIColor whiteColor];
//    [self.scrollView addSubview:self.ppageView];
//
    
    
    self.carouselView = [[MUCarouselView alloc]initWithFrame:CGRectMake(0, 98., [UIScreen mainScreen].bounds.size.width, 100)];
    [self.view addSubview:self.carouselView];
    self.carouselView.titleColor = [UIColor purpleColor];
    self.carouselView.textAlignment = NSTextAlignmentLeft;
    self.carouselView.scrollDirection = MUCarouselScrollDirectionVertical;
    self.carouselView.placeholderImage = [UIImage imageNamed:@"1024_s"];
    // 网络图片数组
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
    
    self.carouselView.titlesArray = @[
                                      @"http://pic34.nipic.com/20131028/2455348_171218804000_2.jpg",
                                      @"http://img1.3lian.com/2015/a2/228/d/129.jpg",
                                      @"http://img.boqiicdn.com/Data/Bbs/Pushs/img79891399602390.jpg",
                                      @"http://sc.jb51.net/uploads/allimg/150703/14-150F3164339355.jpg",
                                      @"http://img1.3lian.com/2015/a2/243/d/187.jpg",
                                      @"http://pic7.nipic.com/20100503/1792030_163333013611_2.jpg",
                                      @"http://www.microfotos.com/pic/0/90/9023/902372preview4.jpg",
                                      @"http://pic1.win4000.com/wallpaper/b/55b9e2271b119.jpg"
                                      ];
  
}
//Click_MUSignal(view){
//    [MUPaymentStyleManager paymentDismissController];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"=======%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 50&&scrollView.contentOffset.y>=0) {
        if (self.ppageView.superview != self.scrollView) {
            [self.ppageView removeFromSuperview];
            [self.scrollView addSubview:self.ppageView];
        }
        self.ppageView.y_Mu =100 - scrollView.contentOffset.y;
//        NSLog(@"=======%f",scrollView.contentOffset.y);
    }else if (scrollView.contentOffset.y>50){
        
        if (self.ppageView.superview != self.view) {
            
            [self.ppageView removeFromSuperview];
            [self.view addSubview:self.ppageView];
        }
        self.ppageView.y_Mu =0;
    }
}
- (NSArray *)changeTopArray {
    return @[
             [[TopTabView alloc] initWithLeftImageName:@"bank" WithRightTitle:@"bank" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"clock" WithRightTitle:@"clock" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"cup" WithRightTitle:@"cup" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"heart" WithRightTitle:@"heart" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"lab" WithRightTitle:@"lab" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"like" WithRightTitle:@"like" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"data" WithRightTitle:@"data" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"tv" WithRightTitle:@"tv" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"display" WithRightTitle:@"pc" WithTitleColor:UIColorFromRGB(0x333333)],
             ];
}

-(NSArray *)controllerArray{
    UIViewController *con1 = [UIViewController new];
    con1.view.backgroundColor = [UIColor whiteColor];
    UIViewController *con2 = [UIViewController new];
    con2.view.backgroundColor = [UIColor purpleColor];
    UIViewController *con3 = [UIViewController new];
    con3.view.backgroundColor = [UIColor cyanColor];
    UIViewController *con4 = [UIViewController new];
    con4.view.backgroundColor = [UIColor orangeColor];
    UIViewController *con5 = [UIViewController new];
    con5.view.backgroundColor = [UIColor greenColor];
    UIViewController *con6 = [UIViewController new];
    con6.view.backgroundColor = [UIColor blackColor];
    NSArray *array =@[con1,con2,con3,con4,con5,con6];
    return array;
}
-(NSArray *)views{
    UIView *con1 = [UIView new];
    con1.backgroundColor = [UIColor blueColor];
    UIView *con2 = [UIView new];
    con2.backgroundColor = [UIColor purpleColor];
    UIView *con3 = [UIView new];
    con3.backgroundColor = [UIColor cyanColor];
    UIView *con4 = [UIView new];
    con4.backgroundColor = [UIColor orangeColor];
    NSArray *array =@[con1,con2,con3,con4];
    return array;
}
-(NSArray *)titles{
    
    return @[@"2432",@"3243",@"2345",@"325326778875343",@"ldslkd",@"8393"];
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
