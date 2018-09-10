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
#import "RootViewController.h"
#import "TriditionTableViewCell.h"
#import "FlyImageTableViewCell.h"
#import "FlyImageLayerTableViewCell.h"
#import "SDWebImageTableViewCell.h"

@interface MUKitDemoTableViewController ()

@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@property(nonatomic, strong)MUCloudModel *cloundModel;
@end


@implementation MUKitDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MUKitDemo";
  
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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

     self.tableViewManger.tipsView.tipsImage = UIImageNamed(@"icon_store");

        mArray = @[@"keyboard仿微信键盘",@"MUSignal",@"MUNetworing",@"MUNavigation",@"MVVVTableView",@"MVVVCollectionView",@"MUEPaymentManager",@"MUShared",@"MUPaperView",@"MUQRCodeManager",@"MUCarousel",@"HeaderView",@"Search",@"MutileSelectedPhotos",@"imageCache",@"MUTextKit"];
        self.tableViewManger.modelArray = mArray;

    weakify(self)
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        *height = 88.;
        cell.textLabel.text = NSStringFormat(@"%@",model);
        cell.textLabel.font = [UIFont systemFontOfSize:22.];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor     = [UIColor grayColor];
//        cell.textLabel.textColor     = [UIColor colorWithHexString:@"#FF7C7C"];
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"mutile"];
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"Signal"];
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"networking"];
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"navigation"];
                break;
            case 4:
                cell.imageView.image = [UIImage imageNamed:@"TablveView"];
                break;
            case 5:
                cell.imageView.image = [UIImage imageNamed:@"collectionView"];
                break;
            case 6:
                cell.imageView.image = [UIImage imageNamed:@"Payment"];
                break;
            case 7:
                cell.imageView.image = [UIImage imageNamed:@"shared"];
                break;
            case 8:
                cell.imageView.image = [UIImage imageNamed:@"Signal"];
                break;
            case 9:
                cell.imageView.image = [UIImage imageNamed:@"Payment"];
                break;
            case 10:
                cell.imageView.image = [UIImage imageNamed:@"qrcode"];
                break;
            case 11:
                cell.imageView.image = [UIImage imageNamed:@"collectionView"];
                break;
            case 12:
                cell.imageView.image = [UIImage imageNamed:@"header"];
                break;
            case 13:
                cell.imageView.image = [UIImage imageNamed:@"mutile"];
            case 14:
                cell.imageView.image = [UIImage imageNamed:@"mutile"];
            case 15:
                cell.imageView.image = [UIImage imageNamed:@"mutile"];

            default:
                break;
        }
        return cell;
    };

//   self.tableViewManger.headerViewBlock = ^UIView * (UITableView *  tableView, NSUInteger sections, NSString *__autoreleasing   *  title, id   model, CGFloat *  height) {
//       *title  = @"MUKitDemo";
//
//       return nil;
//   };
//
//   self.tableViewManger.footerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString *__autoreleasing *title, id model, CGFloat *height) {
//
//       *title = @"你一定会在这里有所收获";
//       return nil;
//   };
    
   
//    weakify(self)
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
        normalize(self)
        if (indexPath.row == 0) {//微信键盘
            [self.navigationController pushViewControllerStringMu:NameToString(MUWeChatController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        
        if (indexPath.row == 1) {//signal
            
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoSignalController) animated:YES parameters:nil];
            return ;
        }
        if (indexPath.row == 2) {//networking
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoNetworkingController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 3) {//navigation
            UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:ClassName(MUKitDemoMainController)];
            //全局设置navigation bar样式
            navigation.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor colorWithHexString:@"#FA19E1"]];//导航栏图片
            navigation.barStyleMu           = UIBarStyleBlack;//电池电量条样式
            navigation.statusBarStyleMu     = UIStatusBarStyleLightContent;//电池电量条样式
            navigation.navigationBarTintColor = [UIColor whiteColor];//返回按钮箭头颜色
            navigation.titleColorMu         = [UIColor whiteColor];//标题颜色
            [self.navigationController presentViewController:navigation animated:YES completion:nil];
        }
      
        
        if (indexPath.row == 4) {//mvvm tableview
            
            UIViewController  *controller = ClassName(MUKitDemoMVVMTableViewController);
            [self.navigationController pushViewControllerMu:controller animated:YES parameters:nil];

            return ;
        }
        if (indexPath.row == 5) {//mvvm collectionView
            
            UIViewController  *controller = ClassName(MUKitDemoMVVMColloectionController);
            [self.navigationController pushViewController:controller animated:YES];
            return ;
        }
        if (indexPath.row == 6) {// payment
            
            UIViewController  *controller = ClassName(MUKitDemoPaymentTableViewController);
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        if (indexPath.row == 7) {//shared
            
            UIViewController  *controller = ClassName(MUKitDemoSharedTableViewController);
            [self.navigationController pushViewController:controller animated:YES];

        }
        if (indexPath.row == 8) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoPaperTableViewController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 9) {
            
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoQRCodeScanController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
            
        }
        
        if (indexPath.row == 10) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoViewCarouselController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 11) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUKitDemoTableHeaderController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 12) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUSearchController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
        if (indexPath.row == 13) {
            
            MUImagePickerManager  *controller = [MUImagePickerManager new];
            controller.allowsMultipleSelection = YES;
            controller.mediaType = MUImagePickerMediaTypeImage;
//            controller.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor whiteColor]];
            controller.maximumNumberOfSelection = 12;
//            [controller takePhotoPresentIn:self allowedEditedImage:YES selectedImage:^(UIImage *origanlImage, UIImage *editedImage) {
//                NSLog(@"image====%@=======editt======%@",origanlImage,editedImage);
//            }];
            [controller presentInViewController:self];
            weakify(self)
            controller.didFinishedPickerImages = ^(NSArray<__kindof UIImage *> *images) {
                normalize(self)
                for (UIImage *image in images) {
                    NSLog(@"image====%@",image);
                }
            };
            controller.didFinishedPickerVideos = ^(NSArray *videoURLs) {
                
                normalize(self)
                for (NSString *url in videoURLs) {
                    NSLog(@"url====%@",url);
                }
            };
        }
        if (indexPath.row == 14) {
            RootViewController*rootViewController= [RootViewController new];
            rootViewController.suffix = @".jpg";
            rootViewController.heightOfCell = 150;
            rootViewController.cellsPerRow = 1;
            rootViewController.activeIndex = 2;
            rootViewController.cells = @[ @{
                                              @"class": [TriditionTableViewCell class],
                                              @"title": @"UIKit"
                                              },@{
                                              @"class": [SDWebImageTableViewCell class],
                                              @"title": @"SDWebImage"
                                              } ,@{
                                              @"class": [FlyImageTableViewCell class],
                                              @"title": @"MUImageView"
                                              }];
                                            
            [self.navigationController pushViewController:rootViewController animated:YES];
        }
        if (indexPath.row == 15) {
            [self.navigationController pushViewControllerStringMu:NameToString(MUTextKitViewController) animated:YES parameters:^(NSMutableDictionary *dict) {
                
            }];
        }
    };
   

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
