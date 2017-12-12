//
//  MUKitDemoTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableViewController.h"
#import <MUTableViewManager.h>
#import "MUKitSignalTableViewController.h"
#import "MUKitDemoMVVMTableViewController.h"
#import "MUKitDemoViewController.h"
#import "MUKitDemoMVVMColloectionController.h"
#import "MUKitDemoPaymentTableViewController.h"
#import "MUCameraAndPhotosManager.h"
#import "MUKitDemoHeaderViewController.h"
#import "MUNavigation.h"
#import "MUKitDemoQRCodeScanController.h"
#import "UIImage+MUColor.h"
#import "MUImagePickerManager.h"
#import "MUKitDemoSharedTableViewController.h"

@interface MUKitDemoTableViewController ()

@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end


static NSString *const cellReusedIndentifier = @"cell";
@implementation MUKitDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demo";
//    self.navigationController.navigationBar.backIndicatorImage
//    self.view.window.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor purpleColor];
//    self.view.frame = [UIScreen mainScreen].bounds;
//    self.barBackgroundColorMu = [UIColor orangeColor];
//    self.barShadowImageHiddenMu = YES;
//    self.view.backgroundColor = [UIColor lightGrayColor];
//    self.navigationController.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor orangeColor]];
//    self.navigationController.navigationBarBackgroundImageMu = [UIImage imageFromGradientColorMu:@[[UIColor orangeColor],[UIColor purpleColor]] gradientType:MUGradientTypeTopToBottom imageSize:CGSizeMake(CGRectGetWidth(self.view.frame), 64.)];
    self.navigationBarHiddenMu = YES;
//    self.tableView
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
//    self.navigationController.navigationBarBackgroundColorMu = [UIColor purpleColor];
//    self.navigationController.titleColorMu = [UIColor whiteColor];
//    self.navigationController.navigationBarTintColor = [UIColor whiteColor];
//    self.navigationController.barStyleMu            = UIBarStyleBlack;
    
//    [self addLeftItemWithTitle:@"123" itemByTapped:^(UIBarButtonItem *item) {
//
//
//    }];
//    [self addLeftItemWithImage:[UIImage imageNamed:@"icon_store"] itemByTapped:^(UIBarButtonItem *item) {
//        
//    }];
    [self configuredDataSource];
    
}
#pragma -mark init
-(void)configuredDataSource{

    self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];
   __block NSArray *mArray = [NSArray array];
    __weak typeof(self)weakSelef = self;
   
     self.tableViewManger.tipsView.tipsImage = [UIImage imageNamed:@"icon_store"];
//    [self.tableViewManger addHeaderRefreshing:^(MURefreshHeaderComponent *refresh) {
    
        
//          weakSelef.tableViewManger.modelArray = mArray;
        mArray = @[@"signal",@"MVVVTableView",@"MVVVCollectionView",@"paymentController",@"takePhotos",@"header",@"QRCodeScan",@"selectedPhotos",@"shared"];
        weakSelef.tableViewManger.modelArray = mArray;
//        [refresh endRefreshing];
//        dispatch_after(((int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            mArray = [@[@"signal",@"MVVVTableView",@"MVVVCollectionView",@"paymentController"] mutableCopy];
//            weakSelef.tableViewManger.modelArray = mArray;
//            [refresh endRefreshing];
//        });
//    }];

    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
    };

   self.tableViewManger.headerViewBlock = ^UIView * (UITableView *  tableView, NSUInteger sections, NSString *__autoreleasing   *  title, id   model, CGFloat *  height) {
       *title  = @"Demo";
       
       return nil;
   };
    
   self.tableViewManger.footerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString *__autoreleasing *title, id model, CGFloat *height) {
       
       *title = @"我想写就写";
       return nil;
   };
    
    __weak typeof(self) weakSelf = self;
    
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
        
        if (indexPath.row == 0) {
            
//            UIViewController *controller = [NSClassFromString(@"MUKitDemoDynamicRowHeightController") new];
//            MUKitDemoViewController  *controller = [MUKitDemoViewController new];
//            [weakSelf.navigationController pushViewControllerStringMu:@"MUKitDemoViewController" animated:YES parameters:nil];
            [weakSelf.navigationController pushViewControllerStringMu:@"MUKitTestController" animated:YES parameters:nil];
//            [weakSelf.navigationController pushViewController:controller animated:YES];
            return ;
        }
        
        if (indexPath.row == 1) {
            
            
            MUKitDemoMVVMTableViewController  *controller = [MUKitDemoMVVMTableViewController new];
            [weakSelf.navigationController pushViewControllerMu:controller animated:YES parameters:nil];
//            [weakSelf.navigationController pushViewController:controller animated:YES];
            return ;
        }
        if (indexPath.row == 2) {
            
            MUKitDemoMVVMColloectionController  *controller = [MUKitDemoMVVMColloectionController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
            return ;
        }
        if (indexPath.row == 3) {
            
            MUKitDemoPaymentTableViewController *controller = [MUKitDemoPaymentTableViewController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        
        if (indexPath.row == 4) {
            
           [MUCameraAndPhotosManager pickImageControllerPresentIn:weakSelf selectedImage:^(UIImage *image) {
               
               
           }];
        }
        if (indexPath.row == 5) {
            
            MUKitDemoHeaderViewController  *controller = [MUKitDemoHeaderViewController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row == 6) {
            
            MUKitDemoQRCodeScanController  *controller = [MUKitDemoQRCodeScanController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row == 7) {
            
            MUImagePickerManager  *controller = [MUImagePickerManager new];
            controller.navigationBarTintColor = [UIColor orangeColor];
            controller.titleColorMu   = [UIColor blueColor];
            controller.maximumNumberOfSelection = 3;
            [controller presentInViewController:weakSelf];
            
        }
        if (indexPath.row == 8) {
            
            MUKitDemoSharedTableViewController  *controller = [MUKitDemoSharedTableViewController new];
            [weakSelf.navigationController pushViewController:controller animated:YES];
            
        }
    };
   

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
