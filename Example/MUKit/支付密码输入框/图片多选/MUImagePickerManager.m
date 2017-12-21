//
//  MUImagePickerManager.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/7.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUImagePickerManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MUAssetsViewController.h"
#import "MUImagePickerController.h"

@interface MUImagePickerManager()
@property (nonatomic, strong) MUImagePickerController *albumsNavigationController;
@property (nonatomic, copy) NSArray *fetchResults;//提取的结果集
@property (nonatomic, copy) NSArray *assetCollections;//资源集合
@property(nonatomic, weak)MUAssetsViewController *assetsViewController;
@end
@implementation MUImagePickerManager
-(instancetype)init{
    if (self = [super init]) {
        // Set default values
        self.assetCollectionSubtypes = @[
                                         @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                         @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                         @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                         @(PHAssetCollectionSubtypeSmartAlbumBursts)
                                         ];
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        self.fetchResults = @[smartAlbums, userAlbums];
        [self updateAssetCollections];
        
         _selectedAssets = [NSMutableOrderedSet orderedSet];
        [self setUpAlbumsNavigationViewController];
        
        self.allowsMultipleSelection    = YES;
        self.minimumNumberOfSelection   = 1;
        self.numberOfColumnsInPortrait  = 4;
        self.numberOfColumnsInLandscape = 7;
        self.mediaType                  = MUImagePickerMediaTypeImage;//默认是图片
        
    }
    return self;
}
- (void)updateAssetCollections
{
 
    // Filter albums
    NSArray *assetCollectionSubtypes = self.assetCollectionSubtypes;
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
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
}
//初始化
- (void)setUpAlbumsNavigationViewController{
   
    MUAssetsViewController *assetsController = [MUAssetsViewController new];
    assetsController.imagePickerController   = self;
    assetsController.assetCollections        = self.assetCollections;
    self.assetsViewController                = assetsController;
    if ([self authorizationStatus]) {
         self.albumsNavigationController = [[MUImagePickerController alloc]initWithRootViewController:assetsController];
    }else{
         self.albumsNavigationController = [[MUImagePickerController alloc]initWithRootViewController:[NSClassFromString(@"MUAuthorizationStatusController") new]];
    }
   
}
-(void)presentInViewController:(UIViewController *)viewController{
    [self presentInViewController:viewController completion:nil];
}

-(void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion{
    
    [viewController presentViewController:self.albumsNavigationController animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}
-(void)dismiss{
    [self dismissWithCompletion:nil];
}
-(void)dismissWithCompletion:(void (^)(void))completion{
    [self.albumsNavigationController dismissViewControllerAnimated:YES completion:^{
        
        if (completion) {
            completion();
        }
    }];
}
-(void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor{
    _navigationBarTintColor = navigationBarTintColor;
    self.albumsNavigationController.navigationBar.tintColor = navigationBarTintColor;
}
-(void)setNavigationBarShadowImageHiddenMu:(BOOL)navigationBarShadowImageHiddenMu{
    _navigationBarShadowImageHiddenMu = navigationBarShadowImageHiddenMu;
    if (navigationBarShadowImageHiddenMu) {
        self.albumsNavigationController.navigationBar.shadowImage = [UIImage new];
    }
}
-(void)setNavigationBarBackgroundImageMu:(UIImage *)navigationBarBackgroundImageMu{
    _navigationBarBackgroundImageMu = navigationBarBackgroundImageMu;
    [self.albumsNavigationController.navigationBar setBackgroundImage:navigationBarBackgroundImageMu forBarMetrics:UIBarMetricsDefault];
}
-(void)setTitleColorMu:(UIColor *)titleColorMu{
    _titleColorMu = titleColorMu;
    self.assetsViewController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:titleColorMu};
}
-(void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    _allowsMultipleSelection = allowsMultipleSelection;
    self.assetsViewController.allowsMultipleSelection = allowsMultipleSelection;
}
-(void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection{
    _maximumNumberOfSelection = maximumNumberOfSelection;
    self.assetsViewController.maximumNumberOfSelection = maximumNumberOfSelection;
}
-(void)setMinimumNumberOfSelection:(NSUInteger)minimumNumberOfSelection{
    _minimumNumberOfSelection = minimumNumberOfSelection;
    self.assetsViewController.minimumNumberOfSelection = minimumNumberOfSelection;
}
-(void)setNumberOfColumnsInPortrait:(NSUInteger)numberOfColumnsInPortrait{
    _numberOfColumnsInPortrait = numberOfColumnsInPortrait;
    self.assetsViewController.numberOfColumnsInPortrait = numberOfColumnsInPortrait;
}
-(void)setNumberOfColumnsInLandscape:(NSUInteger)numberOfColumnsInLandscape{
    _numberOfColumnsInLandscape = numberOfColumnsInLandscape;
    self.assetsViewController.numberOfColumnsInLandscape = numberOfColumnsInLandscape;
}
-(void)setDidPickedAImage:(void (^)(UIImage *))didPickedAImage{
    _didPickedAImage = didPickedAImage;
    self.assetsViewController.didPickedAImage = didPickedAImage;
}
-(void)setDidFinishedPickerImages:(void (^)(NSArray *))didFinishedPickerImages{
    _didFinishedPickerImages = didFinishedPickerImages;
    self.assetsViewController.didFinishedPickerImages = didFinishedPickerImages;
}

-(BOOL)authorizationStatus{
     ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
     if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
         return NO;
     }
    return YES;
}
@end
