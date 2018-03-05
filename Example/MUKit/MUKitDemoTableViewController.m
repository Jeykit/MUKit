//
//  MUKitDemoTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableViewController.h"

#import "MUCameraAndPhotosManager.h"
#import "MUImagePickerManager.h"

#import "MUImagePickerManager.h"


@interface MUKitDemoTableViewController ()

@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@property(nonatomic, strong)MUCloudModel *cloundModel;
@end


@implementation MUKitDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MUKitDemo";
    self.navigationBarHiddenMu = YES;
  
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self configuredDataSource];
     self.cloundModel = [MUCloudModel initWithRetainObject:self keyPath:NameToString(cloundModel)];
    
}
#pragma -mark init
-(void)configuredDataSource{

    self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];
   __block NSArray *mArray = [NSArray array];

     self.tableViewManger.tipsView.tipsImage = UIImageNamed(icon_store);

        mArray = @[@"MUSignal",@"MVVVTableView",@"MVVVCollectionView",@"MUEPaymentManager",@"MUShared",@"MutileSelectedPhotos",@"MUPaperView",@"QRCodeScan",@"MUCarousel",@"HeaderView",@"Search"];
        self.tableViewManger.modelArray = mArray;

    weakify(self)
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        normalize(self)
        if (iPhoneX) {
            NSLog(@"%@",NSStringFromSelector(_cmd));
        }
//        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        cell.textLabel.text = NSStringFormat(@"%@",model);
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
    
   
//    weakify(self)
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
        normalize(self)
        if (indexPath.row == 0) {
        
            [self.navigationController pushViewControllerStringMu:NameToString(MUViewController) animated:YES parameters:nil];
            return ;
        }
        
        if (indexPath.row == 1) {
            
//            UIViewController  *controller = [NSClassFromString(@"MUKitDemoMVVMTableViewController") new];
            UIViewController  *controller = ClassName(MUKitDemoMVVMTableViewController);
            [self.navigationController pushViewControllerMu:controller animated:YES parameters:nil];

            return ;
        }
        if (indexPath.row == 2) {
            
            UIViewController  *controller = ClassName(MUKitDemoMVVMColloectionController);
//            UIViewController  *controller = [NSClassFromString(@"MUKitDemoMVVMColloectionController") new];
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }
        if (indexPath.row == 3) {
            
            UIViewController  *controller = ClassName(MUKitDemoPaymentTableViewController);
//            UIViewController  *controller = [NSClassFromString(@"MUKitDemoPaymentTableViewController") new];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        if (indexPath.row == 4) {
            
            UIViewController  *controller = ClassName(MUKitDemoSharedTableViewController);
//            UIViewController  *controller = [NSClassFromString(@"MUKitDemoSharedTableViewController") new];
            [self.navigationController pushViewController:controller animated:YES];
//           [MUCameraAndPhotosManager pickImageControllerPresentIn:self selectedImage:^(UIImage *image) {
//
//
//           }];
        }
        if (indexPath.row == 5) {
            
            MUImagePickerManager  *controller = [MUImagePickerManager new];
            controller.navigationBarTintColor = [UIColor orangeColor];
            controller.titleColorMu   = [UIColor blueColor];
            controller.maximumNumberOfSelection = 3;
            [controller presentInViewController:self];
           
        }
        if (indexPath.row == 6) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoPaperTableViewController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 7) {
            
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoQRCodeScanController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
            
        }
        
        if (indexPath.row == 8) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoViewCarouselController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 9) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoTableHeaderController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 10) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUSearchController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
    
    };
   

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
