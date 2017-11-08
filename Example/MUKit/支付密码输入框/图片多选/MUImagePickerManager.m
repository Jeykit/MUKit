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

@interface MUImagePickerManager()
@property (nonatomic, strong) UINavigationController *albumsNavigationController;
@property (nonatomic, copy) NSArray *fetchResults;//提取的结果集
@property (nonatomic, copy) NSArray *assetCollections;//资源集合
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
        self.minimumNumberOfSelection   = 1;
        self.numberOfColumnsInPortrait  = 4;
        self.numberOfColumnsInLandscape = 7;
        self.mediaType                  = MUImagePickerMediaTypeImage;//默认是图片
        [self setUpAlbumsNavigationViewController];
        
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
    self.albumsNavigationController = [[UINavigationController alloc]initWithRootViewController:assetsController];
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
@end
