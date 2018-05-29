//
//  MUKitTestController.m
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitTestController.h"
#import "TopTabView.h"


@interface MUKitTestController ()<UIScrollViewDelegate>

@property(nonatomic, strong)MUPaperView *ppageView;
@property(nonatomic, strong)UIScrollView *scrollView;

@end


#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation MUKitTestController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)+400);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
  
    if (self.flag == 0) {
        self.ppageView = [[MUPaperView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight) WithTopArray:[self titles] WithObjects:[self controllerArray]];
        self.title = @"Underline";
        self.ppageView.hightlightColor = [UIColor purpleColor];
        self.ppageView.pagerStyles = MUPagerStyleBottomLine;
        self.ppageView.underlineHeight = 2.;
        self.ppageView.titleScale = 1.15;
        self.ppageView.autoFitTitleLine = YES;
        //    self.ppageView.fontSizeAutoFit = YES;
    }
//    else if(self.flag == 1){
//        self.ppageView = [[MUPaperView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight) WithTopArray:[self titles] WithObjects:[self views]];
//        self.title = @"Block";
////        self.ppageView.topTabHeight = 100.;
//        self.ppageView.pagerStyles = MUPagerStyleSlideBlock;
//        self.ppageView.sliderCornerRadiusRatio = 5.;
//        self.ppageView.autoFitTitleLine = YES;
//        self.ppageView.sliderHeight = 60.;
//    }else{
//        self.ppageView = [[MUPaperView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight) WithTopArray:[self changeTopArray] WithObjects:[self views]];
//        self.title = @"Customer";
//        self.ppageView.pagerStyles = MUPagerStyleBottomLine;
//        self.ppageView.underlineHeight = 2.;
//    }
   
    self.ppageView.tipsColor = [UIColor purpleColor];
//    self.ppageView.topTabHeight = 88.;
    self.ppageView.hightlightColor = [UIColor purpleColor];
    [self.scrollView addSubview:self.ppageView];
//

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
             [[TopTabView alloc] initWithLeftImageName:@"lab" WithRightTitle:@"lab" WithTitleColor:UIColorFromRGB(0x333333)],
             [[TopTabView alloc] initWithLeftImageName:@"like" WithRightTitle:@"like" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"data" WithRightTitle:@"data" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"tv" WithRightTitle:@"tv" WithTitleColor:UIColorFromRGB(0x333333)],
//             [[TopTabView alloc] initWithLeftImageName:@"display" WithRightTitle:@"pc" WithTitleColor:UIColorFromRGB(0x333333)],
             ];
}

-(NSArray *)controllerArray{
    UIViewController *con1 = [UIViewController new];
    con1.view.backgroundColor = [UIColor cyanColor];
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
    UIView *con5 = [UIView new];
    con5.backgroundColor = [UIColor blackColor];
    UIView *con6 = [UIView new];
    con6.backgroundColor = [UIColor yellowColor];
    NSArray *array =@[con1,con2,con3,con4,con5,con6];
    return array;
}
-(NSArray *)titles{
    
    return @[@"2432",@"3243",@"2345",@"325326778875343",@"ldslkd",@"8393"];
}


@end
