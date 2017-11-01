//
//  MUViewController.m
//  elmsc
//
//  Created by zeng ping on 2017/7/3.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUViewController.h"
#import "MUView.h"
#import <UIViewController+MUPopup.h>
#import <MUPopupController.h>
#import "MUNavigation.h"
#import <UIImage+MUColor.h>


@interface MUViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *sView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (weak, nonatomic) IBOutlet MUView *MUView;
@end

@implementation MUViewController
- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Apple";
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addRightItemWithTitle:@"详情" itemByTapped:^(UIBarButtonItem *item) {
//
//    }];
    [self addLeftItemWithImage:[UIImage imageNamed:@"icon_store"] itemByTapped:^(UIBarButtonItem *item) {
        
    }];
//    self.barBackgroundColorMu = [UIColor purpleColor];
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.navigationBarAlphaMu = 0.5;
//    self.navigationBarHiddenMu = YES;
//    self.navigationBarTranslucentMu = YES;
//    self.view.backgroundColor = [UIColor orangeColor];
//    self.navigationBarBackgroundColorMu = [UIColor purpleColor];
    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor orangeColor]];
//    self.barAlphaMu = 0;
//    self.titleColorMu = [UIColor whiteColor];
//    self.barShadowImageHiddenMu = YES;
    // Do any additional setup after loading the view from its nib.
//    MUView *mView = [[MUView alloc]initWithFrame:_MUView.bounds];
//    [_MUView addSubview:mView];
    self.imageView.userInteractionEnabled = YES;
//    self.navigationBarTranslucentMu = YES;
//    self.navigationBarHiddenMu = YES;
//    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor orangeColor]];
    
//    self.navigationBarAlphaMu = 0;
//   [self addRightItemWithTitle:@"123" itemByTapped:^(UIBarButtonItem *item) {
//      NSLog(@"右边按钮被点击");
//       
//   }];
//    [self addLeftItemWithTitle:@"456" itemByTapped:^(UIBarButtonItem *item) {
//       NSLog(@"左边按钮被点击");
//        
//    }];
//
//    //直接改变UIControl事件触发，信号名默认为控件变量名
//    self.textField.clickSignalName  = @"text";
//    self.textField.allControlEvents = UIControlEventEditingDidEnd;
//    [self.textField addTarget:self action:@selector(idi) forControlEvents:UIControlEventEditingDidEnd];
//
//    //直接改变UIControl事件触发，并设置信号；信号设置与改变事件触发间无顺序
//    self.textField.allControlEvents = UIControlEventEditingDidEndOnExit;
//    self.textField.clickSignalName  = @"text";//可以设置信号名，如果不设置则使用变量名
    
    //用链式编程设置属性，属性一样则覆盖前一个
self.textField.setSignalName(@"text").controlEvents(UIControlEventEditingDidEndOnExit).enforceTarget(self);
     self.textField.controlEvents(UIControlEventEditingDidEndOnExit).setSignalName(@"text").enforceTarget(self);
    
//    self.button.clickSignalName     = @"text";
//    self.button.allControlEvents     = UIControlEventTouchDown;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)idi
{
    NSLog(@"我是控制器上的信号----------%@",self.textField.text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_MUSignal(sView){
     NSLog(@"我是控制器上的信号----------%@",NSStringFromClass([object class]));
}

Click_MUSignal(button){
    
//     NSLog(@"我是控制器上的信号----------%@",NSStringFromClass([object class]));
    [self.navigationController pushViewController:[NSClassFromString(@"MUKitSignalTableViewController") new] animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.popupController pushViewController:[NSClassFromString(@"MUKitSignalTableViewController") new] animated:YES];
//    [self.navigationController pushViewController:[NSClassFromString(@"MUKitSignalTableViewController") new] animated:YES];
}
Click_MUSignal(segmented){
     NSLog(@"我是控制器上的信号----------%@",NSStringFromClass([object class]));
}
Click_MUSignal(textField){
    
    
    NSLog(@"我是控制器上的信号----------%@",self.textField.text);
}
Click_MUSignal(text){
     NSLog(@"我是控制器上的信号----------%@",NSStringFromClass([object class]));
    NSLog(@"我是控制器上的信号----------%@",self.textField.text);
}
Click_MUSignal(imageView){
      NSLog(@"我是控制器上的信号----------%@",NSStringFromClass([object class]));
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
