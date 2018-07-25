//
//  MUAuthorizationStatusController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/19.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUAuthorizationStatusController.h"
#import <Photos/Photos.h>
#import "MUAssetsViewController.h"

@interface MUAuthorizationStatusController ()
@property(nonatomic, strong)UILabel *textLabel;
@property (nonatomic,weak) MUAssetsViewController *assetViewController;
@property (nonatomic, copy) NSArray *assetCollections;//资源集合
@end

@implementation MUAuthorizationStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相册权限未开启";
    self.textLabel = [UILabel new];
   
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.numberOfLines = 0;
    self.textLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.textLabel];
    [self rightBarButtonItem];
    
    UILabel *senderLabel = [UILabel new];
  
    senderLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSetting)];
    [senderLabel addGestureRecognizer:tapGesture];
   
    [self.view addSubview:senderLabel];
   
    senderLabel.textColor = self.navigationController.navigationBar.tintColor;
   
    NSString *count = [[NSUserDefaults standardUserDefaults] valueForKey:@"MUAssetsFirstShow"];
    if (!count&&self.imagePickerController.mediaType == MUImagePickerMediaTypeImage) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        self.textLabel.text = [NSString stringWithFormat:@"%@需要您的允许才能获取图片相册\n请点击下方‘允许’授权",app_Name];
        senderLabel.text = @"允许";
    }else{
        senderLabel.text = @"前往设置";
        self.textLabel.text = @"请在系统设置中开启相册授权服务\n(设置>隐私>照片>开启)";
    }
    [self.textLabel sizeToFit];
    self.textLabel.center = CGPointMake(self.view.center.x, self.view.center.y*.62);
    [senderLabel sizeToFit];
     senderLabel.center = CGPointMake(self.view.center.x, self.textLabel.center.y + 64.);
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:senderLabel.text];
    [ mString addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleThick)} range:NSMakeRange(0, senderLabel.text.length)];
    senderLabel.attributedText = mString;
    
}
- (void)updateAssetCollections:(void (^)(NSArray *))complete
{
    
    // Filter albums
    NSArray *assetCollectionSubtypes =  @[
                                          @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                          @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                          @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                          @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                          @(PHAssetCollectionSubtypeSmartAlbumBursts)
                                          ];
  __block  NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
  __block NSMutableArray *userAlbums = [NSMutableArray array];
    
    PHFetchResult *smartAlbums1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    NSArray *fetchResults = @[smartAlbums1, userAlbums1];
    
    for (PHFetchResult *fetchResult in fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    
    self.assetCollections = assetCollections;
    if (complete) {
        complete(assetCollections);
    }
   
}
-(void)rightBarButtonItem{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44., 44.)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mu_leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;
    
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)mu_leftButtonClicked{
 
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)goToSetting{
    NSString *count = [[NSUserDefaults standardUserDefaults] valueForKey:@"MUAssetsFirstShow"];
    if (!count) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    [self updateAssetCollections:^(NSArray * assetCollections) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MUAssetsViewController *assetsController = [MUAssetsViewController new];
                            assetsController.imagePickerController   = self.imagePickerController;
                            assetsController.assetCollections        = assetCollections;
                            [self.navigationController pushViewController:assetsController animated:YES];
                            self.imagePickerController = nil;
                            [[NSUserDefaults standardUserDefaults] setValue:@"10" forKey:@"MUAssetsFirstShow"];
                        });
                    }];
                });
            }
        }];
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
